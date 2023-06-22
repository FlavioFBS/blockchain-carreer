// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC20.sol";

contract customERC20 is my_ERC20 {

    constructor(string memory _name, string memory _symbol) my_ERC20(_name, _symbol) {}

    // para crear nuevos tokens y asignarle a quien ejecute la funcion:
    function createTokens() public {
        _mint(msg.sender, 1000);
    }

    // destruir tokens
    function destruirTokens(address _account, uint amount) public {
        _burn(_account, amount);
    }

}
