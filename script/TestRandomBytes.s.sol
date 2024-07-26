
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {SingleRPS} from "../src/SingleRPS.sol";
import "../src/SharedTypes.sol";
import "../src/GameLogicLib.sol";

contract TestRandomBytesScript is Script {
    
    address player;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("SAPPHIRE_PRIVATE_KEY");
        player = vm.addr(deployerPrivateKey);
        
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the contract
        SingleRPS singleRPS = new SingleRPS{value: 0.01 ether}();
        console.log("SingleRPS deployed to:", address(singleRPS));

       


        vm.stopBroadcast();
    }


    }
