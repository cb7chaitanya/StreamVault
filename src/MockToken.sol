// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract MockTokenWithFaucet is ERC20, Ownable {
    uint256 public faucetAmount = 0.01 ether; // Amount given per request
    mapping(address => uint256) public lastRequest;
    uint256 public interval = 24 hours; // Cooldown period between requests

    constructor() ERC20("Mock Token", "MTK") Ownable(msg.sender) {
        _mint(msg.sender, 1000 ether); // Initial supply for the contract owner
    }

    function requestTokens() external {
        require(block.timestamp >= lastRequest[msg.sender] + interval, "Please wait before requesting again");

        lastRequest[msg.sender] = block.timestamp;

        _mint(msg.sender, faucetAmount);
    }

    function setFaucetAmount(uint256 _faucetAmount) external onlyOwner {
        faucetAmount = _faucetAmount;
    }

    function setInterval(uint256 _interval) external onlyOwner {
        interval = _interval;
    }
}
