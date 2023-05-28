// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

// 1: owner
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

// 2: receptor
// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

// 3: operator
// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

contract myerc1155 is ERC1155 {
    // variables:
    uint256 public constant GOLD = 0;
    uint256 public constant SILVER = 1;
    uint256 public constant THORS_HAMMER = 2;
    uint256 public constant SWORD = 3;
    uint256 public constant SHIELD = 4;

    constructor() ERC1155("https://game.tokens/item/{id}.json") {
        _mint(msg.sender, GOLD, 10**18, "");
        _mint(msg.sender, SILVER, 10**27, "");
        _mint(msg.sender, THORS_HAMMER, 1, "");
        _mint(msg.sender, SWORD, 10**9, "");
        _mint(msg.sender, SHIELD, 10**8, "");
    }
}
