// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC20.sol";

contract customERC20 is my_ERC20 {

    constructor() my_ERC20("Chisi", "CH") {}

    // para crear nuevos tokens y asignarle a quien ejecute la funcion:
    function createTokens() public {
        _mint(msg.sender, 1000);
    }
}
