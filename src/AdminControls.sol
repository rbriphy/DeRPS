// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./SharedTypes.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

contract AdminControls is Ownable(msg.sender), ReentrancyGuard {
    uint256 internal adminPool;
    uint256 private constant FEE_PERCENTAGE = 1;

    //////////
    //ERRORS//
    //////////

    error WithdrawalExceedsAdminPool();
    error TransferFailed();

    /////////////////////////////////////////////////////////////////

    function withdrawFunds(uint256 amount) public onlyOwner {
        if (amount > adminPool) {
            revert WithdrawalExceedsAdminPool();
        }        

        adminPool -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) {
            revert TransferFailed();
        }
        require(success, "Transfer failed");
    }
    
    // Getters/views

     function getAdminPoolBalance() public view returns (uint256) {
        return adminPool;
    }

    function getFEE_PERCENTAGE() public pure returns (uint256) {
        return FEE_PERCENTAGE;
    }
}