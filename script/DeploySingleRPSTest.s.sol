// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import "../test/SingleRPS.t.sol";
import "../src/SharedTypes.sol";
import "../src/GameLogicLib.sol";

contract DeploySingleRPSTestScript is Script {
    
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("SAPPHIRE_PRIVATE_KEY");
        address payable deployedContractAddress = payable(0x62894583eADbabeacAb516449c5ca9515a4F18f4);        
        vm.startBroadcast(deployerPrivateKey);
        
        SingleRPSTest singleRPS = new SingleRPSTest{value: 0.01 ether}(deployedContractAddress);
        console.log("SingleRPSTest deployed to:", address(singleRPS));

        vm.stopBroadcast();
    }
}

