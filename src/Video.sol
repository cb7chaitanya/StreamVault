// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol"; 

contract VideoSharing is ReentrancyGuard {
    address constant WeaveVmUploadPrecompile = address(0x17); //WeaveVM precompile address for data upload from solidity to arweave 
    address constant WeaveVmReadPrecompile = address(0x18); //WeaveVM precompile address for data read from arweave via solidity
    IERC20 public token; //ERC20 token contract address for token-gated access and payments

    struct Video {
        uint id; //Unique identifier for video
        string title; //Title for video
        string description; //Description for video
        address uploader; //Uploader address
        uint uploadDate; //Upload date for video
        string arweaveTxId; //Arweave identifier for locating video
        string thumbnailUrl; //Thumbnail for video
        uint duration; //Video Length
        string[] tags; //Tags for labelling videos in categories, etc.
        uint likesCount; //Tracking count of likes on a video
        uint commentsCount; //Tracking count of comments on a video
        uint accessFee; //Fee Required to access the video
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
    mapping(uint => mapping(address => bool)) public hasAccess; //Mapping to track users who paid for access

    uint public videoCount; //Total video count 

    event VideoUploaded(
        uint id, 
        string title,
        string description,
        address uploader,
        uint uploadDate,
        string arweaveTxId,
        string thumbnailUrl,
        uint duration
    ); //Maintaining logs for video upload 

    event VideoLiked(uint videoId, address liker); //Maintaining logs for video likes
    event VideoUnliked(uint videoId, address unliker); //Maintaining logs for video unlikes
    event CommentAdded(uint videoId, uint commentId, address commenter); //Maintaining logs for new comments on the video
    event VideoAccessGranted(uint videoId, address viewer); //Maintaining logs for granting access to videos

    constructor(address _tokenAddress){
        token = IERC20(_tokenAddress); //Initialising token address for payments
    }

    //Upload video directly to Arweave using WeaveVM's precompile (0x17)
    function uploadVideo(
        string memory _title, //Video title
        string memory _description, //Video Description
        bytes memory _videoData, //Binary file for video Data
        string[] memory _tags, //Tags for video
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
            tags: _tags,
            thumbnailUrl: _thumbnailUrl,
            duration: _videoLength,
            accessFee: _accessFee
        }); 

        emit VideoUploaded(videoCount, _title, _description, msg.sender, block.timestamp, arweaveTxId, _thumbnailUrl, _videoLength); //Event for notifying offchain apps/clients that video has been uploaded
    }

    function likeVideo(uint _videoId) public {
        require(hasAccess[_videoId][msg.sender], "Access denied");
        require(!videoLikes[_videoId][msg.sender], "You have already liked this video!!!"); //condition to check whether the current user has already liked the video or not
        videoLikes[_videoId][msg.sender] = true; //setting video liked to true
        videos[_videoId].likesCount++; //incrementing likes count for a video

        emit VideoLiked(_videoId, msg.sender); //Event for notifying offchain apps/clients that video has been liked
    }

    function addComment(uint _videoId, string memory _text) public {
        require(hasAccess[_videoId][msg.sender], "Access denied");
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
        require(hasAccess[_videoId][msg.sender] || msg.sender == videos[_videoId].uploader, "Access denied");
        
        string memory arweaveTxId = videos[_videoId].arweaveTxId; //Getting arweave tx id for a video using video id 

        (bool success, bytes memory data) = WeaveVmReadPrecompile.staticcall(
            abi.encodeWithSignature("fetchData(string)", arweaveTxId)
        ); //Utilising read precompile for reading data off of arweave 

        require(success, "Error fetching data"); //Checking for if the read was a success or not 
        
        return string(data); //Returning data after fetching 
    }   

    function payForAccess(uint _videoId) external nonReentrant {
        require(_videoId > 0 && _videoId <= videoCount, "Invalid Video Id");
        require(!hasAccess[_videoId][msg.sender], "Access already granted");

        uint fee = videos[_videoId].accessFee;
        require(token.transferFrom(msg.sender, videos[_videoId].uploader, fee), "Payment failed");

        hasAccess[_videoId][msg.sender] = true; //Grant access to user
        emit VideoAccessGranted(_videoId, msg.sender);
    }
}