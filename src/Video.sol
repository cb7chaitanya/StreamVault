// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol"; 

contract VideoSharing is ReentrancyGuard {
    address constant WeaveVmUploadPrecompile = address(0x17); //WeaveVM precompile address for data upload from solidity to arweave 
    address constant WeaveVmReadPrecompile = address(0x18); //WeaveVM precompile address for data read from arweave via solidity
    IERC20 public token; //ERC20 token contract address for token-gated access and payments
    address public platformAddress; //Platform address to send platform fee to

    struct Video {
        uint id; //Unique identifier for video
        string title; //Title for video
        string description; //Description for video
        address uploader; //Uploader address
        uint uploadDate; //Upload date for video
        string arweaveTxId; //Arweave identifier for locating video
        string thumbnailUrl; //Thumbnail for video
        uint duration; //Video Length
        string[] categoryList ; //categoryList  for labelling videos in categories, etc.
        uint likesCount; //Tracking count of likes on a video
        uint commentsCount; //Tracking count of comments on a video
    } 

    struct Comment {
        uint id; //Unique identifier for comment
        address commenter; //Author of the comment
        string content; //Content of the comment
        uint timestamp; //Time of publishing 
    }

    mapping(uint => Video) public videos; //Maintaining a list of Videos adhering to the video structure
    mapping(uint => mapping(uint => Comment)) public videoComments; //Mapping to associate multiple comments with a video
    mapping(uint => mapping(address => bool)) public videoLikes; //Mapping to associate likes on a video with a user
    mapping(address => mapping(address => bool)) public hasAccess; //Mapping to track users who paid for access
    mapping(uint => mapping(address => uint)) public videoTips; //Mapping to track total tips a video has recieved per viewer
    mapping(address => uint) public channelAccessFee; //Mapping to track access fee for all videos by uploader

    uint public videoCount; //Total video count 
    uint public constant platformFeePercentage = 100;

    event VideoUploaded(uint id, string title, string description, address uploader, uint uploadDate, string arweaveTxId, string thumbnailUrl, uint duration); //Maintaining logs for video upload 
    event VideoLiked(uint videoId, address liker); //Maintaining logs for video likes
    event VideoUnliked(uint videoId, address unliker); //Maintaining logs for video unlikes
    event CommentAdded(uint videoId, uint commentId, address commenter); //Maintaining logs for new comments on the video
    event ChannelAccessGranted(address uploader, address viewer); //Maintaining logs for granting access to videos
    event Tipped(uint videoId, address tipper, uint amount); //Maintaining logs for tipping per video and viewer
    event FundsWithdrawn(address uploader, uint amount); //Maintaining logs for funds which were withdrawn 
    event CommentEdited(uint videoId, uint commentId, address commenter); //Maintaining logs for edition in comment
    event CommentDeleted(uint videoId, uint commentId, address commenter); //Maintaining logs for comment deletion

    constructor(address _tokenAddress, address _platformAddress){
        token = IERC20(_tokenAddress); //Initialising token address for payments
        platformAddress = _platformAddress; //Platform address for 
    }

    //Upload video directly to Arweave using WeaveVM's precompile (0x17)
    function uploadVideo(
        string memory _title, //Video title
        string memory _description, //Video Description
        bytes memory _videoData, //Binary file for video Data
        string[] memory _categoryList , //categoryList  for video
        string memory _thumbnailUrl, //Thumbnail URL for video
        uint _videoLength, //Video Duration
        uint _accessFee //Fee for access 
    )external {
        (bool success, bytes memory responseData) = WeaveVmUploadPrecompile.call(
            abi.encodeWithSignature("storeData(bytes)", _videoData)
        ); //Utilising Upload precompile call for uploading data

        require(success, "Arweave Upload Failed"); //Checking for arweave upload validity

        string memory arweaveTxId = abi.decode(responseData, (string)); //Getting arweave tx id from response data
        videoCount++; //Incrementing video count
        videos[videoCount] = Video({
            id: videoCount,
            title: _title,
            description: _description,
            uploader: msg.sender,
            uploadDate: block.timestamp,
            arweaveTxId: arweaveTxId,
            likesCount: 0,
            commentsCount: 0,
            categoryList : _categoryList,
            thumbnailUrl: _thumbnailUrl,
            duration: _videoLength
        }); 
        channelAccessFee[msg.sender] = _accessFee; //Set Channel Level access fee for uploader
        emit VideoUploaded(videoCount, _title, _description, msg.sender, block.timestamp, arweaveTxId, _thumbnailUrl, _videoLength); //Event for notifying offchain apps/clients that video has been uploaded
    }

    function likeVideo(uint _videoId) public {
        require(hasAccess[videos[_videoId].uploader][msg.sender] || msg.sender == videos[_videoId].uploader, "Access denied");
        require(!videoLikes[_videoId][msg.sender], "You have already liked this video!!!"); //condition to check whether the current user has already liked the video or not
        videoLikes[_videoId][msg.sender] = true; //setting video liked to true
        videos[_videoId].likesCount++; //incrementing likes count for a video

        emit VideoLiked(_videoId, msg.sender); //Event for notifying offchain apps/clients that video has been liked
    }

    function addComment(uint _videoId, string memory _text) public {
        require(hasAccess[videos[_videoId].uploader][msg.sender] || msg.sender == videos[_videoId].uploader, "Access denied");
        videos[_videoId].commentsCount++; //Incrementing comment count for video given the id
        uint commentId = videos[_videoId].commentsCount; //Setting comment id for new comment 

        videoComments[_videoId][commentId] = Comment({
            id: commentId,
            commenter: msg.sender,
            content: _text,
            timestamp: block.timestamp
        });

        emit CommentAdded(_videoId, commentId, msg.sender); //Event for notifying offchain apps/clients that video has a new comment 
    }

   function unlikeVideo(uint _videoId) public {
        require(videoLikes[_videoId][msg.sender] && videos[_videoId].likesCount > 0, "You haven't liked this video!!!"); //Checking for if the video has been liked by the user or to prevent underflow of likes
        videoLikes[_videoId][msg.sender] = false; //Setting video liked boolean to false after unliking for a user on a specific video
        videos[_videoId].likesCount--; //Decrementing the count of likes on a video

        emit VideoUnliked(_videoId, msg.sender); //Event for notifying offchain apps/clients that a video has been unliked
    }


    function getVideo(uint _videoId) public view returns (string memory) {
        require(hasAccess[videos[_videoId].uploader][msg.sender] || msg.sender == videos[_videoId].uploader, "Access denied"); //Token gating the video to add content access controls for users
        
        string memory arweaveTxId = videos[_videoId].arweaveTxId; //Getting arweave tx id for a video using video id 

        (bool success, bytes memory data) = WeaveVmReadPrecompile.staticcall(
            abi.encodeWithSignature("fetchData(string)", arweaveTxId)
        ); //Utilising read precompile for reading data off of arweave 

        require(success, "Error fetching data"); //Checking for if the read was a success or not 
        
        return string(data); //Returning data after fetching 
    }   

    function payForAccess(address _uploader) external nonReentrant {
        require(channelAccessFee[_uploader] > 0, "Uploader has no access fee set"); //Check for Access fee by uploader
        require(!hasAccess[_uploader][msg.sender], "Access already granted"); //Check for if access has already been granted to the msg sender

        uint fee = channelAccessFee[_uploader]; //Setting fee for channel access
        uint platformFee = (fee * platformFeePercentage)/10000;
        uint uploaderEarnings = fee - platformFee;
        require(token.transferFrom(msg.sender, _uploader, uploaderEarnings), "Access payment failed!"); //Check for if the tokens have been transferred or not to the uploader
        require(token.transferFrom(msg.sender, platformAddress, platformFee), "Platform fee transfer failed!"); //Check for if the tokens have been transferred or not to the platform 
        hasAccess[_uploader][msg.sender] = true; //Setting has access to be true after payment confirmation
        emit ChannelAccessGranted(_uploader, msg.sender); //Event for notifying offchain apps/clients that a person has been granted access to a channel       
    }

    function tipVideo(uint _videoId, uint _amount) external nonReentrant {
        require(_amount > 0, "Tip Amount has to be greater than zero"); //Check for the tip amount to be greater than zero
        uint platformFee = (_amount * 1)/100; //Calculate platform fee from the total amount
        uint uploaderAmount = _amount - platformFee; //Calculate amount left to be sent uploader
        require(token.transferFrom(msg.sender, videos[_videoId].uploader, uploaderAmount), "Tip failed!"); //Check for if the tip payment succeeds to uploader
        require(token.transferFrom(msg.sender, platformAddress, platformFee), "Platform fee failed!"); //Check for if the fee payment succeeds to platform 
        videoTips[_videoId][msg.sender] += _amount; //Adding amount sent by the user to videoTips 
        emit Tipped(_videoId, msg.sender, _amount); //Event for notifying offchain apps/clients that an amount has been tipped 
    }

    function withdawTips() external nonReentrant {
        uint totalTips; //Local variable to hold total tips on all videos a channel has 
        for(uint i=1; i<=videoCount; i++){
            if(videos[i].uploader == msg.sender){
                totalTips += videoTips[i][msg.sender]; 
                videoTips[i][msg.sender] = 0;
            }
        } //Iterating over all videos, selecting for videos uploaded by message sender 
        require(totalTips > 0, "No tips available for withdrawal!"); //Check for if there are no tips available for withdrawal
        require(token.transfer(msg.sender, totalTips), "Withdrawal failed!"); //Check for withdrawal succeeds or not 
        emit FundsWithdrawn(msg.sender, totalTips); //Event for notifying offchain apps/clients that funds have been withdrawn 
    }

    function editComment(uint _videoId, uint _commentId, string memory _newContent) public {
        require(videoComments[_videoId][_commentId].commenter == msg.sender, "You are not the author of this comment!"); //Check for if the person signing message is the author 
        videoComments[_videoId][_commentId].content = _newContent; //Setting comment content to new Content
        emit CommentEdited(_videoId, _commentId, msg.sender); //Event for notfiying offchain apps/clients that a comment has been edited
    }
    
    function deleteComment(uint _videoId, uint _commentId) public {
        require(videoComments[_videoId][_commentId].commenter == msg.sender, "You are not the author of this comment!"); //Check for if the person signing message is the author 
        delete videoComments[_videoId][_commentId]; //Emptying comment data to free up some space and recover gas
        videos[_videoId].commentsCount--; //Decrementing comments count  for a video
        emit CommentDeleted(_videoId, _commentId, msg.sender); //Event for notfiying offchain apps/clients that a comment has been deleted
    }
}