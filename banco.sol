// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Banco {
    
    // CLASE-3: https://www.youtube.com/watch?v=G9SgweZ1U9I&list=PL-jD2YjEmwDpkSGIJ9tF4R1CM2TadvCRc&index=3
    
    address owner; // variable de estado, es global
    
    // creando un modificador:
    modifier onlyOwner {
        // restringir para que solo el propietario pueda usarlo
        require(msg.sender == owner);
        _; // indica que si se cumple el require ya se puede ejecutar el siguiente código
    
        /* NOTA: viendo a los modificadores como middlewares de NodeJS, el "_;" sería como la funcion next()
        */
    }
    
    function newOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
    
    function getOwner() view public returns(address){
        return owner;
    }
    
    function getBalance() view public returns(uint256) {
        return address(this).balance;
    }
    
    
    // payable: para que la funcion reciba dinero
    constructor() payable {
        owner = msg.sender;
    }
    
    function incrementBalance (uint256 amount) payable public {
        // se condiciona para que quien ejecuta la funcion, realmente envíe el valor que indica 
        // ejm: si indico que enviaré 30 pero realmente envío un valor diferente, es un error y el estado del contrato no se actualiza
        require(msg.value == amount);
    }
    
    /* NOTA: El saldo que tenga el contrato es del contrato, no es del que lo
        creó o hizo el contrato 
        -Tiene un identidad autónoma en la blockchain
    */
    
    // agregando modificador a la funcion
    function withdrowBalance() public onlyOwner {
        // msg.sender: direccion de origen de quien llama a la funcion dentro del contrato

        // NOTA: mejor usar transfer que send, porque tiene unos problemas .-.
        
        // se le transferira Todo el balance del contrato a quien ejecuto el contrato
        payable(msg.sender).transfer(address(this).balance);
    }
    
    /* funcion anonima: evitar usarla (°-°)  para evitar perdidas de dinero a los usuarios
    function() payable public {
        
    }
    */
    
}
