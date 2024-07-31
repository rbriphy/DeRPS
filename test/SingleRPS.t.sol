// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {SingleRPS} from "../src/SingleRPS.sol";
import "../src/GameLogicLib.sol";

contract SingleRPSTest {
    SingleRPS public singleRPS;
    address public owner;
    
    event RandomNumberGenerated(uint256 number);

    constructor(address payable _singleRPSAddress) payable {
        owner = msg.sender;
        singleRPS = SingleRPS(_singleRPSAddress);
    }

    function testGenerateRandom() public view returns(uint256 randomNumber) {
        randomNumber = GameLogicLib.generateRandom();
        
    }


}