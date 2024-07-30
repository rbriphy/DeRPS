// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../lib/forge-std/src/Test.sol";
import {SingleRPS} from"../src/SingleRPS.sol";
import "../src/GameLogicLib.sol";
import "../node_modules/@oasisprotocol/sapphire-contracts/contracts/Sapphire.sol";



contract SingleRPSTest is Test, SingleRPS {

    function testGenerateRandom() public view {
        uint256 randomNumber = GameLogicLib.generateRandom();
        console.log(randomNumber);
    }


}