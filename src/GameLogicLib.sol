// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./SharedTypes.sol";
import "../node_modules/@oasisprotocol/sapphire-contracts/contracts/Sapphire.sol";

library GameLogicLib {
    // Function to determine the outcome of the game
    function determineOutcome(SharedTypes.Move _playerMove, SharedTypes.Move _opponentMove) internal pure returns (SharedTypes.Outcome) {
        if (_playerMove == _opponentMove) {
            return SharedTypes.Outcome.Tie;
        } else if (
            (_playerMove == SharedTypes.Move.Rock && _opponentMove == SharedTypes.Move.Scissors) ||
            (_playerMove == SharedTypes.Move.Paper && _opponentMove == SharedTypes.Move.Rock) ||
            (_playerMove == SharedTypes.Move.Scissors && _opponentMove == SharedTypes.Move.Paper)
        ) {
            return SharedTypes.Outcome.Win;
        } else {
            return SharedTypes.Outcome.Lose;
        }
    }

    // Function to generate a random number
    function generateRandom() internal view returns (uint256) {
        return uint256(bytes32(Sapphire.randomBytes(32, "")));
  }

}