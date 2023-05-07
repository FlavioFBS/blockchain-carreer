// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract padre {

    // almacenamiento de informacion del factory
    // tener informacion de la persona que genere un contrato hijo
    mapping (address => address) public personal_contract;

    // emitir nuevo smart contract
    function Factory () public {
        address addr_personal_contract = address(new hijo(msg.sender, address(this)));
        personal_contract[msg.sender] = addr_personal_contract;
    }
}


contract hijo {

    // datos del propietario
    Owner public propietario;
    struct Owner {
        address _owner;
        address _smartContractPadre;
    }

    // datos recibidos al nuevo smart contract
    constructor(address _account, address _accountSmartContract_padre) {
        propietario._owner = _account;
        propietario._smartContractPadre = _accountSmartContract_padre;
    }
}
/*
al probar desde remix:
-desplegar el contrato padre
-usar la funcion factory, entregará el address del contrato hijo
-para revisar el contrato hijo, seleccionar el contrato hijo y usar la funcion de
"At address" de la seccion de deploy y con eso aparecerá en la lita de contrato que se 
pueden usar
*/
