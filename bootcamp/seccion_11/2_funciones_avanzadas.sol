// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Food {
    
    // 
    struct dinnerPlate {
        string name;
        string ingredientes;
    }

    // menu del dia
    dinnerPlate [] menu;

    // crear nuevo menu
    function newMenu(string memory _name, string memory _ingredientes) internal  {
        menu.push(dinnerPlate(_name, _ingredientes));
    }
}


contract Hamburguesa is Food {
    address public owner;

    constructor () {
        owner = msg.sender;
    }

    // cocinar hamburguesa desde el smart contract principal
    function doHamberguesa(string memory _ingredientes, uint _units) external {
        require(_units <=5, "Ups, no puedes pedir tantas hamburguesas -.-");
        newMenu("Hamburguer", _ingredientes);
    }

    // modifier para permitir que solo el owner
    modifier onlyOwner() {
        require(owner == msg.sender, "No estas autorizado ._.");
        _;
    }

    function hashPrivateNumber (uint _number) public view onlyOwner returns (bytes32) {
        return keccak256(abi.encodePacked(_number));
    }
}
