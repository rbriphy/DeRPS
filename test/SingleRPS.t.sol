// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../lib/forge-std/src/Test.sol";
import "../src/SingleRPS.sol";

contract SingleRPSTest is Test, SingleRPS {
    function testGenerateRandom() view public {
        uint256 randomNumber = this.exposedGenerateRandom();
        console.log(randomNumber);
    }

    function exposedGenerateRandom() public view returns (uint256) {
        return generateRandom();
    }
}