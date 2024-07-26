// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./SharedTypes.sol";
import "./GameLogicLib.sol";
import "./AdminControls.sol";
import "../node_modules/@oasisprotocol/sapphire-contracts/contracts/Sapphire.sol";

contract SingleRPS is AdminControls {
    
    constructor() payable {
        adminPool = msg.value;
    }

    // Struct to track player scores
    struct Score {
        uint256 wins;
        uint256 losses;
        uint256 ties;
    }
    

    // Mappings to track player scores and bets
    mapping(address => Score) public playerScores;
    mapping(address => uint256) public playerBets;

    // Events emitted when a game is played, a bet is placed, or a user withdraws winnings
    event GamePlayed(address player, SharedTypes.Move playerMove, SharedTypes.Move opponentMove, SharedTypes.Outcome outcome, uint256 bet, uint256 winnings);
    event BetPlaced(address player, uint256 bet);
    event Withdrawal(address player, uint256 amount);

    // The maximum bet size and fee charged on each bet
    uint256 public constant MAX_BET = 0.001 ether;
    uint256 public constant FEE_PERCENTAGE = 1;

    // Function to generate a random number (CHANGE FOR SAPPHIRE)
    function generateRandom() internal view returns (uint) {
        return uint(bytes32(Sapphire.randomBytes(32, "")));
  }

    

    // Function to play a game
    function playGame(SharedTypes.Move _move) public payable {
        require(msg.value > 0, "Bet amount must be greater than zero");
        require(msg.value <= MAX_BET, "Bet size exceeds maximum allowed");
        require(uint256(_move) >= 0 && uint256(_move) <= 2, "Invalid move");


        // Place the bet
        placeBet(msg.sender, msg.value);

        // Generate a random number between 1 and 3
        uint256 randomNumber = (generateRandom() % 3);

        // Determine the opponent's move based on the random number
        SharedTypes.Move opponentMove;
        if (randomNumber == 0) {
            opponentMove = SharedTypes.Move.Rock;
        } else if (randomNumber == 1) {
            opponentMove = SharedTypes.Move.Paper;
        } else {
            opponentMove = SharedTypes.Move.Scissors;
        }

        // Determine the outcome of the game
        SharedTypes.Outcome outcome = GameLogicLib.determineOutcome(_move, opponentMove);

        // Update the player's score
        if (outcome == SharedTypes.Outcome.Win) {
            playerScores[msg.sender].wins++;
        } else if (outcome == SharedTypes.Outcome.Lose) {
            playerScores[msg.sender].losses++;
        } else {
            playerScores[msg.sender].ties++;
        }

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
        uint256 fee = (winnings * FEE_PERCENTAGE) / 100;
        adminPool += fee;

        // Pay out the winnings
        (bool success, ) = payable(msg.sender).call{value: winnings - fee}("");
        require(success, "Transfer failed");

        // Emit an event with the game details
        emit GamePlayed(msg.sender, _move, opponentMove, outcome, msg.value, winnings);
    }

    // Function to place a bet
    function placeBet(address player, uint256 bet) internal {
        require(bet > 0, "Bet amount must be greater than zero");
        require(bet <= MAX_BET, "Bet size exceeds maximum allowed");
        require(player != address(0), "Invalid player address");
        playerBets[player] = bet;
        emit BetPlaced(player, bet);
    }


}