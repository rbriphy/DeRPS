// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {SingleRPS} from "../src/SingleRPS.sol";
import "../src/GameLogicLib.sol";
import {Test} from "../lib/forge-std/src/Test.sol";
import "../script/DeploySingleRPS.s.sol";

contract SingleRPSTest is Test {
    DeploySingleRPS deployScript;
    SingleRPS singleRPS;


    function setUp() external {
               
        deployScript = new DeploySingleRPS();
        vm.deal(address(this), 1 ether);
        singleRPS = deployScript.run();
        assertTrue(address(singleRPS) != address(0), "SingleRPS contract was not deployed");
    }


    
    function testGenerateRandom() public view {
        uint256 rand1 = GameLogicLib.generateRandom();
        uint256 rand2 = GameLogicLib.generateRandom();
        assertTrue(rand1!=rand2, "Random numbers should not be the same");
    }
    function testRandomModulo() public view  {
        uint256 randomMod = GameLogicLib.generateRandom() % 3;
        
    }
}