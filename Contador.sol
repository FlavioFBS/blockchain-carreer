// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Contador {
    uint256 countNumber;
    
    // init state
    constructor(uint256 _count) {
        countNumber = _count;
    }
    
    function setCount(uint256 _count) public {
        countNumber = _count;
    }
    
    function incrementCount() public {
        countNumber += 1;
    }
    
    // view: indica que no cambia el estado del contrato y que solo es lectura
    function getCount() public view returns (uint256) {
        return countNumber;
    }
    
    // pure: indica que la funcion es pura, es decir ni escribe ni lee 
    // ninguna variable del estado del contrato
    function getNumber() public pure returns(uint256){
        return 34;
    }
    
    
    // NOTA: funciones view y pure no consumen gas
}
