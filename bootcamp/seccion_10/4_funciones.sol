// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract functions {

    // tipo pure
    function getName() public pure returns (string memory) {
        // requiere min 21064 de gas
        return "example-name";
    }

    // funcion view
    uint256 x= 100;
    function getNumber() public view returns (uint256) {
        // consulta el valor de la variable x (que forma parte del contract -> de la blockchain) y de paso lo multiplica
        return x * 2;
    }

}
