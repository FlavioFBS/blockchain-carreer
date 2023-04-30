// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract loops_conditionals {

    // suma de 10 primeros numeros
    function sum_for(uint _number) public pure returns(uint) {
        uint aux_sum=0;
        for (uint i = _number; i<(10 + _number); i++){
            aux_sum = aux_sum + i;
        }
        return aux_sum;
    }

    // suma de 10 primeros numeros
    function sum_while(uint _number) public pure returns(uint) {
        uint aux_sum=0;
        uint i = _number;
        while (i<(10 + _number)) {
            aux_sum = aux_sum + i;   
        }
        return aux_sum;
    }

    // suma de 10 primeros numeros
    function sum_dowhile(uint _number) public pure returns(uint) {
        uint aux_sum=0;
        uint i = _number;
        do {
            aux_sum = aux_sum + i;
        } 
        while (i< (10 + _number));

        return aux_sum;
    }

    function sum_rest(string memory operation, uint a, uint b) public pure returns(uint) {
        // comparacion de strings:  operation == "sum"
        bytes32 hash_operation = keccak256(abi.encodePacked(operation));
        if (hash_operation == keccak256(abi.encodePacked("+"))) {
            return a+b;
        } else if (hash_operation == keccak256(abi.encodePacked("-"))) {
            return a-b;
        } else if (hash_operation == keccak256(abi.encodePacked("/"))) {
            require(b != 0, "No se puede dividir por cero");
            return a/b;
        } else if (hash_operation == keccak256(abi.encodePacked("*"))) {
            return a*b;
        } else {
            return 0;
        }
    }
}
