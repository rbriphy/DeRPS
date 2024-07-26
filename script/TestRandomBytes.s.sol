
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

        uint256[3] memory moveCounts;
        
         for (uint i = 0; i < 10; i++) {
            SharedTypes.Move playerMove = SharedTypes.Move.Rock;
            
            // Capture the transaction data
            bytes memory txData = abi.encodeWithSelector(
                singleRPS.playGame.selector,
                playerMove
            );
            
            (bool success, bytes memory returnData) = address(singleRPS).call{value: 0.001 ether}(txData);
            require(success, "Transaction failed");
            
            // Parse the emitted event from the return data
            SharedTypes.Move opponentMove = parseOpponentMove(returnData);
            
            moveCounts[uint(opponentMove)]++;
            console.log("Game", i+1, "- Opponent's move:", uint(opponentMove));
        }

        console.log("Rock count:", moveCounts[0]);
        console.log("Paper count:", moveCounts[1]);
        console.log("Scissors count:", moveCounts[2]);

        vm.stopBroadcast();
    }


    }
}