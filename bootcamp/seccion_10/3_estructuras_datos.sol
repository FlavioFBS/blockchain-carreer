// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


contract data_structures {

    struct Customer {
        uint128 id;
        string name;
        string email;
    }

    // variable de tipo cliente:
    Customer cliente1 = Customer(1, "pepe", "pepe@test.com");

    // array de longitud fija
    uint128 [5] public fixed_list_uints = [1,2,3,4,5];

    // array dinamico
    uint128 [] dynamic_list_uints;

    // array dinamico para clientes:
    Customer [] public customerList;

    // nuevos datos en array:
    function array_modification(uint128 _id, string memory _name, string memory _email) public  {
        customerList.push(Customer(_id, _name, _email));
    }

    // mapping
    mapping (address => uint256) public address_uint;
    // si una persona tiene varias cuentas:
    mapping (string => uint256[]) public string_listUints;
    mapping (address => Customer) public address_customer;

    // asignacion de valores en mapping:
    function assignNumber (uint256 _number) public {
        //              Key         value
        address_uint[msg.sender] = _number;
    }

    // asignacion varios numeros a una direccion
    function assignList(string memory _name, uint256 _number) public {
        string_listUints[_name].push(_number);
    }

    // asignacion de estructura a una direccion
    function assignCustomer(uint128 _id, string memory _name, string memory _email) public {
        address_customer[msg.sender] = Customer(_id, _name, _email);
    }

    function checkSender () public view returns(address) {
        return msg.sender;
    }

}
