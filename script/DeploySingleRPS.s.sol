// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {SingleRPS} from "../src/SingleRPS.sol";
import "../src/SharedTypes.sol";
import "../src/GameLogicLib.sol";

contract DeploySingleRPS is Script {


       function run() external returns(SingleRPS) {
        
        uint256 deployerPrivateKey;
        
        if (block.chainid == 23295) {
            deployerPrivateKey = vm.envUint("SAPPHIRE_PRIVATE_KEY");

        }
        else {
            deployerPrivateKey = vm.envUint("ANVIL_PRIVATE_KEY");
        }
        
        
        vm.startBroadcast(deployerPrivateKey);
        SingleRPS singleRPS = new SingleRPS();
        vm.deal(address(singleRPS), 1 ether);
        vm.stopBroadcast();
        
        console.log("singleRPS deployed to:", address(singleRPS));

        return (singleRPS);
    }
}

