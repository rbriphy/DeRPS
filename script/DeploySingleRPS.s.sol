// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {SingleRPS as ImportedSingleRPS} from "../src/SingleRPS.sol";
import "../src/SharedTypes.sol";
import "../src/GameLogicLib.sol";

contract DeploySingleRPSScript is Script {
    
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("SAPPHIRE_PRIVATE_KEY");
                
        vm.startBroadcast(deployerPrivateKey);
        
        ImportedSingleRPS singleRPS = new ImportedSingleRPS{value: 0.01 ether}();
        console.log("SingleRPS deployed to:", address(singleRPS));

        vm.stopBroadcast();
    }
}

