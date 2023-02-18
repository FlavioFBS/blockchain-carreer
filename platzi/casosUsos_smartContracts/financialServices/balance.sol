// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract TokenBasic {
    string public constant name = "MyCoin";
    string public constant symbol = "YOZ";
    uint8 public constant decimals = 18;

    uint256 _totalSupply;

    mapping(address => uint256) balances;
    // para indicar que una wallet-A autoriza a otra wallet-B a que pueda usar cierta cantidad de tokens
    mapping(address => mapping(address => uint256)) allowed;

    // caso de hacer transferencia
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    // caso de permitir a otra wallet que pueda gestionar sus tokens
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    constructor(uint256 total) {
        // _totalSupply = total;
        // uno comenta que el totalSupply debe ser multiplicado por 10^(decimals)
        // pero en el curso el profe considera el totalSupply como la cantidad de tokens en el contrato
        _totalSupply = total;
        balances[msg.sender] = total;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(
            _value <= balances[msg.sender],
            "There are not enough funds to do the transfer"
        );
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        emit Transfer(msg.sender, _to, _value);
        success = true;
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        success = true;
    }

    // para consultar cantidad de tokens que puede gestionar la wallet-B, luego que la wallet-A le autorizó
    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 remaining)
    {
        remaining = allowed[_owner][_spender];
    }

    // para permitir transferir tokens de una cuenta a otra
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        /* 
        ejemplo: tenemos 3 cuentas:  A B C. Suponiendo que A tiene 100 tokens
        Considerando de A le autoriza a B a gestionar hasta 60 tokens.
         */

        // se valida si la cuenta A tiene suficientes tokens de los indicados a transferir 
        require(
            _value <= balances[_from],
            "There are not enough funds to do the transfer"
        );
        // se valida que la cantidad a transferir no se mayor a los que B está autorizado a gestionar
        require(_value <= allowed[_from][msg.sender], "Sender not allowed");

        // se resta la cantidad de origen, en este caso de A.
        balances[_from] = balances[_from] - _value;
        // se resta la cantidad de tokens autorizados a B por parte de A
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        // se le añade a C los tokens que se le transferirá
        balances[_to] = balances[_to] + _value;
        // evento de transferencia.
        emit Transfer(_from, _to, _value);
        success = true;
    }
}
