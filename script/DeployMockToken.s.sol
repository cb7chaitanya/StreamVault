// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/MockToken.sol";

contract DeployMockToken is Script {
    function run() external {
        vm.startBroadcast(); // Start broadcasting the transaction

        MockTokenWithFaucet mockToken = new MockTokenWithFaucet(); // Deploy the contract

        vm.stopBroadcast(); // Stop broadcasting the transaction
    }
}
