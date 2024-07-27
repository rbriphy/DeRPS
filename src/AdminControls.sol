// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./SharedTypes.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

contract AdminControls is Ownable(msg.sender), ReentrancyGuard {
    uint256 internal adminPool;

    receive() external payable {
        require(msg.sender != address(this), "Cannot call receive from this contract");
        adminPool += msg.value;
    }

    function withdrawFunds(uint256 amount) public onlyOwner {
        require(amount <= adminPool, "Withdrawal amount exceeds available funds");
        adminPool -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }
    // Getters/views

     function getAdminPoolBalance() public view returns (uint256) {
        return adminPool;
    }


}