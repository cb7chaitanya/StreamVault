// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../src/Video.sol";

contract MockToken is ERC20{
    constructor() ERC20("Mock Token", "MTK"){
        _mint(msg.sender, 100 ether);
    }
}

contract VideoSharingTest is Test {
    VideoSharing public videoSharing;
    MockToken public token;
    address public uploader = address(0x1);
    address public viewer = address(0x2);

    function setUp() public {
        token = new MockToken();
        videoSharing = new VideoSharing(address(token));
        token.transfer(viewer, 100 ether);
    }

    function testUploadVideo() public {
        vm.startPrank(uploader);

        videoSharing.uploadVideo("Test Video", "A test video description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);

        (string memory title, string memory description, , , , , , , , ) = videoSharing.videos(1);
        assertEq(title, "Test Video");
        assertEq(description, "A test video description");

        vm.stopPrank();
    }

    function testLikeVideo() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "nail.jpg", 120, 10 ether);
        vm.stopPrank();

        vm.startPrank(viewer);
        token.approve(address(videoSharing), 10 ether);
        videoSharing.payForAccess(1);

        videoSharing.likeVideo(1);
        (, , , , , , , , uint likesCount, ) = videoSharing.videos(1);
        assertEq(likesCount, 1, "Like Count should be 1");
        vm.stopPrank();
    }

    function testAddComment() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thum.jpg", 120, 10 ether);
        vm.stopPrank();

        vm.startPrank(viewer);
        token.approve(address(videoSharing), 10 ether);
        videoSharing.payForAccess(1);

        videoSharing.addComment(1, "Great Video!");
        (, , , , , , , , , uint commentsCount) = videoSharing.videos(1);

        assertEq(commentsCount, 1, "Comments count should be 1");
        vm.stopPrank();
    }

    function testAccessPayment() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string , "thumbnai", 120, 10 ether);
        vm.stopPrank();

        vm.startPrank(viewer);
        token.approve(address(VideoSharing), 10 ether);

        videoSharing.payForAccess(1);
        bool accessGranted = videoSharing.hasAccess(1, viewer);

        assertTrue(accessGranted, "Viewer should have access to the video!");
        vm.stopPrank();
    }

}