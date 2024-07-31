// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./SharedTypes.sol";
import "./GameLogicLib.sol";
import "./AdminControls.sol";

contract SingleRPS is AdminControls {
    
    constructor() payable {
        adminPool = msg.value;
    }

    // Events emitted when a game is played, a bet is placed, or a user withdraws winnings
    event GamePlayed(address player, SharedTypes.Move playerMove, SharedTypes.Move opponentMove, SharedTypes.Outcome outcome, uint256 bet, uint256 winnings);
    event BetPlaced(address player, uint256 bet);
    event Withdrawal(address player, uint256 amount);

    // The maximum bet size and fee charged on each bet
    uint256 public constant MAX_BET = 1 ether;
    uint256 public constant FEE_PERCENTAGE = 1;

    // Function to place a bet
    function placeBet(address _player, uint256 _bet) internal {
        require(_bet > 0, "Bet amount must be greater than zero");
        require(_bet <= MAX_BET, "Bet size exceeds maximum allowed");
        require(_bet <= adminPool, "Bet size exceeds maximum allowed");
        require(_player != address(0), "Invalid player address");
        emit BetPlaced(_player, _bet);
    }

    // Function to play a game
    function playGame(SharedTypes.Move _move) public payable {
        require(msg.value <= MAX_BET, "Bet size exceeds maximum allowed");
        require(uint256(_move) >= 0 && uint256(_move) <= 2, "Invalid move");

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
        uint256 winnings;
        if (outcome == SharedTypes.Outcome.Win) {
            winnings = msg.value * 2; // double the bet for a win
        } else if (outcome == SharedTypes.Outcome.Lose) {
            winnings = 0;
        } else {
            winnings = msg.value; // refund the bet for a tie
        }

        // Charge a fee on the bet
        uint256 fee = uint256((winnings * FEE_PERCENTAGE) / 100);
        adminPool += fee;

        // Pay out the remainder
        (bool success, ) = payable(msg.sender).call{value: winnings - fee}("");
        require(success, "Transfer failed");

        // Emit an event with the game details
        emit GamePlayed(msg.sender, _move, opponentMove, outcome, msg.value, winnings);
    }


    // Tests    
    function testGenerateRandom() public view returns(uint256 randomBig) {
        randomBig = GameLogicLib.generateRandom();
    }
    function testRandomModulo() public view returns(uint256 randomMod) {
        randomMod = GameLogicLib.generateRandom() % 3;
        
    }

}