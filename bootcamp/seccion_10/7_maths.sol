// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract maths {
    function suma(uint a, uint b) public pure returns (uint) {
        return a+b;
    }

    function resta(uint a, uint b) public pure returns (uint) {
        return a-b;
    }

    function product(uint a, uint b) public pure returns (uint) {
        return a*b;
    }

    function fracion(uint a, uint b) public pure returns (uint) {
        require(b > 0, "No se puede dividir por cero");
        return a/b;
    }

    function expon(uint a, uint b) public pure returns (uint) {
        return a**b;
    }

    function modulo(uint a, uint b) public pure returns (uint) {
        require(b > 0, "No se puede dividir por cero");
        return a%b;
    }

    // modulo de una suma  (x+y)%k
    function _addmod(uint x, uint y, uint k) public pure returns(uint, uint) {
        return (addmod(x, y, k), (x+y)%k);
    }

    // modulo de un producto  (x*y)%k
    function _mulmod(uint x, uint y, uint k) public pure returns(uint, uint) {
        return (mulmod(x, y, k), (x*y)%k);
    }
}
