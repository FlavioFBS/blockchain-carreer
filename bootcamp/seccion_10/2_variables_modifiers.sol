
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract variable_modifiers {
    // entero sin signo
    uint a; // uint == uint256, modificador por default-> internal
    uint8 public b = 3;

    // enteros con signo
    int256 c;
    int8 public d = -32;
    int e = 65;

    // strings:
    string str = "test";

    // byte
    bytes32 firt_byte;
    bytes4 second_bytes;
    // byte byte_1;   decrepcated
    bytes1 test;

    // algoritmo de hash
    bytes32 public hashing = keccak256(abi.encode("hola -.-", "._."));

    // address
    address myAddress;
    address public address_1 = 0x1aE0EA34a72D944a8C7603FfB3eC30a6669E454C;
    address public address_2 = msg.sender; // direccion de quien consulta al contrato

    // variable de enumeracion enums
    enum options {ON, OFF}  // no se le pone ";"
    options state; // valor por defecto es el primero del enum -> 0 que representa al "ON"
    options constant defaultChoice = options.OFF;

    function turnOn() public {
        state = options.ON;
    }

    function turnOf() public {
        state = options.OFF;
    }

    function display() public view returns (options) {
        return state;
    }

     // 70. Hashing al detalle:
    bytes32 public hashing_keccak256 = keccak256(abi.encode("hola -.-", -10, msg.sender));
    bytes32 public hashing_sha256 = sha256(abi.encode("hola -.-"));
    bytes20 public rimped160 = ripemd160(abi.encode("hola -.-"));
    // si se pone más de 20, aparecen 2 ceros por cada incremento, por ejm en byte23 al final habrán 6 ceros
    bytes23 public rimped160_demas = ripemd160(abi.encode("hola -.-"));
/* 
0x5B38Da6a701c568545dCfcB03FcB875f56beddC4


 */

}

