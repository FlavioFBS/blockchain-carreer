const contractCustomERC20 = artifacts.require("customERC20");

// el contractCustomERC20 hereda de ERC20, pero solo es necesario desplegar el contractCustomERC20
// ya por detrás despliega el contrato de que hereda

const tokenName = "Chisi";
const tokenSymbol = "CH";

module.exports = function (deployer) {
    // así está el constructor del contrato customERC20:
    // constructor(string memory _name, string memory _symbol) my_ERC20(_name, _symbol) {}
    
    // al desplegar: pasar los parámetros del contructor en orden, luego de la variable del contrato
    deployer.deploy(contractCustomERC20, tokenName, tokenSymbol);
}
