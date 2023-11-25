// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// contrato para emitir tokens y hacer staking
contract JamToken {
    // declaraciones
    string public name = "JAM Token";
    string public symbol = "JAM";
    uint256 public totalSupply = 10**24;
    uint8 public decimals = 18;
    // 1 millon de tokens: 24 del totalSupply - 18 de decimals

    // Evento para la transferencia de tokens de un usuario
    event Transfer (
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    // Evento para la aprobación de un operador
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    // Estructura de datos
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    // Transferencia de tokens de un usuario
    function transfer(address _to, uint256 _value) public returns(bool) {
        require(balanceOf[msg.sender] >= _value, "Error JAM.token: Sender doesn\'t have money");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Aprobación de una cantidad para se gastada por un operador (como prestamo)
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Transferencia de tokens especificando el emisor
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_value <= balanceOf[_from], "Error JAM.token: Sender doesn\'t have money");
        // verificar si de la cantidad que tiene asignada el spender alcanza para la transferencia solicitada
        require(_value <= allowance[_from][msg.sender], "Error JAM.token: The spender doesn\'t have enought allowance");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
