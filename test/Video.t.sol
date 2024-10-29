// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../src/Video.sol";

contract MockToken is ERC20 {
    constructor() ERC20("Mock Token", "MTK") {
        _mint(msg.sender, 100 ether);
    }
}

contract VideoSharingTest is Test {
    VideoSharing public videoSharing;
    MockToken public token;
    address public uploader = address(0x1);
    address public viewer = address(0x2);
    address public platform = address(0x3);

    function setUp() public {
        token = new MockToken();
        videoSharing = new VideoSharing(address(token), platform);
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
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
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
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
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
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
        vm.stopPrank();

        vm.startPrank(viewer);
        token.approve(address(videoSharing), 10 ether);
        videoSharing.payForAccess(1);
        bool accessGranted = videoSharing.hasAccess(1, viewer);
        assertTrue(accessGranted, "Viewer should have access to the video!");
        vm.stopPrank();
    }

    function testLikeWithoutAccess() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
        vm.stopPrank();    
        
        vm.startPrank(viewer);
        vm.expectRevert("Access Denied");
        videoSharing.likeVideo(1);
        vm.stopPrank();
    }

    function testWithdrawFunds() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
        vm.stopPrank();

        // Simulate viewer paying for access
        vm.startPrank(viewer);
        token.approve(address(videoSharing), 10 ether);
        videoSharing.payForAccess(1);
        vm.stopPrank();

        // Uploader withdraws funds
        vm.startPrank(uploader);
        uint256 initialBalance = token.balanceOf(uploader);
        videoSharing.withdrawFunds();
        uint256 finalBalance = token.balanceOf(uploader);
        assertTrue(finalBalance > initialBalance, "Uploader should have withdrawn funds");
        vm.stopPrank();
    }

    function testPlatformFeeOnAccessPayment() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
        vm.stopPrank();

        uint256 platformInitialBalance = token.balanceOf(platform);

        // Simulate viewer paying for access
        vm.startPrank(viewer);
        token.approve(address(videoSharing), 10 ether);
        videoSharing.payForAccess(1);
        vm.stopPrank();

        uint256 platformFinalBalance = token.balanceOf(platform);
        uint256 expectedFee = (10 ether * 100) / 10000; // 1% fee
        assertEq(platformFinalBalance - platformInitialBalance, expectedFee, "Platform should receive a 1% fee from the transaction");
    }

    function testTipUploader() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
        vm.stopPrank();

        // Simulate viewer tipping the uploader
        vm.startPrank(viewer);
        token.approve(address(videoSharing), 1 ether);
        videoSharing.tipUploader(1, 1 ether);
        vm.stopPrank();

        // Check uploader's balance after tip
        vm.startPrank(uploader);
        uint256 initialBalance = token.balanceOf(uploader);
        videoSharing.withdrawFunds();
        uint256 finalBalance = token.balanceOf(uploader);
        assertTrue(finalBalance > initialBalance, "Uploader should have received tips");
        vm.stopPrank();
    }

    // New test functions

    function testVideoRetrieval() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
        vm.stopPrank();

        (string memory title, string memory description, , , , , , , , ) = videoSharing.videos(1);
        assertEq(title, "Test Video");
        assertEq(description, "Description");
    }

    function testMultipleViews() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
        vm.stopPrank();

        // First viewer
        vm.startPrank(viewer);
        token.approve(address(videoSharing), 10 ether);
        videoSharing.payForAccess(1);
        vm.stopPrank();

        // Second viewer
        vm.startPrank(address(0x4));
        token.transfer(address(0x4), 100 ether);
        token.approve(address(videoSharing), 10 ether);
        videoSharing.payForAccess(1);
        vm.stopPrank();

        // Check access for both viewers
        assertTrue(videoSharing.hasAccess(1, viewer), "First viewer should have access");
        assertTrue(videoSharing.hasAccess(1, address(0x4)), "Second viewer should have access");
    }

    function testInvalidVideoId() public {
        vm.startPrank(viewer);
        vm.expectRevert("Video does not exist");
        videoSharing.likeVideo(999); // Assuming 999 is an invalid ID
        vm.stopPrank();
    }

    function testCommentAccessWithoutPayment() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
        vm.stopPrank();

        vm.startPrank(viewer);
        vm.expectRevert("Access Denied");
        videoSharing.addComment(1, "Nice video!");
        vm.stopPrank();
    }

    function testTipWithInsufficientBalance() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
        vm.stopPrank();

        vm.startPrank(viewer);
        token.approve(address(videoSharing), 1 ether); // Assuming viewer has insufficient balance
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        videoSharing.tipUploader(1, 10 ether); // Trying to tip more than the balance
        vm.stopPrank();
    }

    function testLikeVideoMultipleTimes() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
        vm.stopPrank();

        vm.startPrank(viewer);
        token.approve(address(videoSharing), 10 ether);
        videoSharing.payForAccess(1);
        videoSharing.likeVideo(1);
        videoSharing.likeVideo(1); // Liking again
        (, , , , , , , , uint likesCount, ) = videoSharing.videos(1);
        assertEq(likesCount, 1, "Like Count should be 1; should not increment for duplicate likes");
        vm.stopPrank();
    }

    function testInvalidPaymentAmount() public {
        vm.startPrank(uploader);
        videoSharing.uploadVideo("Test Video", "Description", hex"1234", new string, "thumbnail.jpg", 120, 10 ether);
        vm.stopPrank();

        vm.startPrank(viewer);
        token.approve(address(videoSharing), 1 ether); // Approving less than the required amount
        vm.expectRevert("Insufficient funds");
        videoSharing.payForAccess(1);
        vm.stopPrank();
    }
}
