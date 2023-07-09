// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract Hello {
    string public message = "Hello -.-";
    address public owner;

    constructor(){
        owner = msg.sender;
        console.log("Owner address -->", owner);
    }

    function getMessage() public view returns (string memory) {
        return message;
    }
}
