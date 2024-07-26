# DeRPS

## Overview

DeRPS is a prototype for a decentralized rock-paper-scissors application. This project leverages blockchain technology to create a fair and transparent multiplayer game environment.

## Technical Background

While single-player games against a computer simply require a source of randomness (such as Chainlink VRF), multiplayer games on blockchain present unique challenges:

- On standard EVM chains, player moves are visible when transactions are submitted to the mempool.
- This visibility makes the game susceptible to frontrunning, especially when funds are bet on the game's outcome.

## Solution: Oasis Network's Sapphire ParaTime

To address these challenges, DeRPS utilizes the Oasis Network's Sapphire ParaTime, which offers:

1. An encrypted mempool
2. Native support for randomness

Oasis Sapphire is the first and only confidential EVM, making it an ideal platform for games requiring both privacy and randomness, like DeRPS.

## Development Approach

This project demonstrates that with the right infrastructure, development of privacy-preserving games can be straightforward. DeRPS requires no additional dependencies beyond the Sapphire runtime.

## Disclaimer

**Important**: This is my first Solidity project. While best practices for secure code have been followed to the best of my ability, it should be assumed that the DeRPS contracts contain numerous bugs and security vulnerabilities. Use at your own risk.