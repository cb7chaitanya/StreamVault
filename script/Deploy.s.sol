// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Video.sol"; // Adjust path if necessary

contract Deploy is Script {
    function run() external {
        // Start broadcasting for actual deployment
        vm.startBroadcast();

        // Replace with actual addresses if needed
        address mockTokenAddress = 0xa74945f17a8777802C58933eeaFD9d919020Ed29; // Address of the MockToken or any ERC20 token you want to use
        address platformAddress = 0x0226738f99F028662E9B88D94C867a5f4B8560Ca;   // Address to receive platform fees
        
        // Deploy the contract
        VideoSharing videoSharing = new VideoSharing(mockTokenAddress, platformAddress);

        // Stop broadcasting after deployment
        vm.stopBroadcast();

        // Optionally log the address
        console.log("VideoSharing deployed to:", address(videoSharing));
    }
}
