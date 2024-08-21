// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./SharedTypes.sol";
import "./GameLogicLib.sol";
import "./AdminControls.sol";

contract SingleRPS is AdminControls {

    /////////////////////////////////////////////////////////////////

    //////////
    //ERRORS//
    //////////

    error ContractCannotPayItself();
    
    
    error BetMustBeNonzero();
    error BetTooLarge();
    error BetExceedsAdminPool();
    error InvalidPlayerAddress();
    error InvalidMove();
    error WinningsTransferFailed();

    /////////////////////////////////////////////////////////////////

    //////////
    //EVENTS//
    //////////

    event GamePlayed(address player, SharedTypes.Move playerMove, SharedTypes.Move opponentMove, SharedTypes.Outcome outcome, uint256 bet, uint256 winnings);
    event BetPlaced(address player, uint256 bet);
    event Withdrawal(address player, uint256 amount);

    /////////////////////////////////////////////////////////////////

    uint256 private winnings;
    uint256 private constant MAX_BET = 1 ether;
    uint256 private fee;


    constructor() payable {
        adminPool = msg.value;
    }

    receive() external payable {
        if(msg.sender == address(this)) {
            revert ContractCannotPayItself();
        }
        adminPool += msg.value;
    }


    // Function to place a bet
    function placeBet(address _player, uint256 _bet) internal {
        if (_bet == 0) {
            revert BetMustBeNonzero();
        }
        if (_bet > MAX_BET) {
            revert BetTooLarge();
        }
        if (_bet > adminPool) {
            revert BetExceedsAdminPool();
        }
        if (_player == address(0)) {
            revert InvalidPlayerAddress();
        }
        emit BetPlaced(_player, _bet);
    }

    // Function to play a game
    function playGame(SharedTypes.Move _move) public payable {
        if (msg.value > MAX_BET) {
            revert BetTooLarge();
        }
        if (uint256(_move) > 2)  {
            revert InvalidMove();
        }

        // Place the bet
        if (msg.value > 0) {
            placeBet(msg.sender, msg.value);
        }

        // Generate a random number between 1 and 3 and convert to the opponent's move
        uint256 randomNumber = (GameLogicLib.generateRandom() % 3);
        SharedTypes.Move opponentMove = SharedTypes.Move(randomNumber);

        // Determine the outcome of the game
        SharedTypes.Outcome outcome = GameLogicLib.determineOutcome(_move, opponentMove);

        
        // Calculate the winnings
        if (outcome == SharedTypes.Outcome.Win) {
            winnings = msg.value * 2; // double the bet for a win
        } else if (outcome == SharedTypes.Outcome.Lose) {
            winnings = 0;
        } else {
            winnings = msg.value; // refund the bet for a tie
        }

        // Charge a fee on the bet
        fee = uint256((winnings * getFEE_PERCENTAGE()) / 100);
        adminPool += fee;

        // Pay out the remainder
        (bool success, ) = payable(msg.sender).call{value: winnings - fee}("");
        if (!success) {
            revert WinningsTransferFailed();
        }

        // Emit an event with the game details
        emit GamePlayed(msg.sender, _move, opponentMove, outcome, msg.value, winnings);
    }


}



