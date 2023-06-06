// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// smart contract que gestiona los nft
contract mainChisiERC721 is ERC721 {
    address public direccionLoteria;
    constructor() ERC721("Loteria", "LOT") {
        // este contrato se inicia desde el constructor del contract Loteria
        // entonces el msg.sender será la dirección del contract Loteria
        direccionLoteria = msg.sender;
    }

    // creacion de NFTs
    function safeMint(address _propietario, uint256 _numBoleto) public {
        // filtrar para que la funcion solo se pueda ejecutar por el smart contract de boletosNFT
        require(msg.sender == Loteria(direccionLoteria).usersInfo(_propietario), "No tienes permiso para ejecutar esta funcion");
        _safeMint(_propietario, _numBoleto);
    }
}

contract boletosNFT {
    // datos del propietario
    struct Owner {
        address direccionPropietario;
        address contratoPadre;
        address contratoNFT;
        address contatoUsuario;
    }

    Owner public propietario;

    constructor(address _propietario, address _contractPadre, address _contractNFT) {
        propietario = Owner(_propietario, _contractPadre, _contractNFT, address(this));
    }

    // conversion de números de boletos de loteria (num -> nft)
    function mintBoleto(address _propietario, uint _boleto) public {
        // filtar para que solo se pueda ejecutar por el contract Loteria
        require(msg.sender == propietario.contratoPadre, "No tienes permisos para ejecutar esta funcion");
        mainChisiERC721(propietario.contratoNFT).safeMint(_propietario, _boleto);
    }

}

contract Loteria is ERC20, Ownable {
    // -----Gestion de tokens-----

    // Direccón del contrato NFT del proyecto
    address public nft_loteria_contract;

    constructor() ERC20("ChisiTinka", "CHT") {
        // se crearan tokens y se enviará a este mismo contrato para mayor seguridad
        _mint(address(this), 1000);
        nft_loteria_contract = address(new mainChisiERC721());
    }

    // ganador del premio:
    address public ganador;

    // registro de usuarios
    // enlace de direccion de usuario con su smart contract que él mismo podrá controlar
    mapping (address => address) public usuario_contract;

    // precio de los tokens:
    function precioTokens(uint256 _numTokens) internal pure returns(uint256) {
        // cada boleto costará 1 ether
        return _numTokens * (1 ether);
    }

    // visualización de balance de tokens erc-20 de usuario
    function balanceTokensERC20(address _account) public view returns(uint256) {
        return balanceOf(_account);
    }

    // obtener los tokens del smart contact
    function balanceTokensSC() public view returns (uint256) {
        return balanceOf(address(this));
    }

    // visualizar el balance de ethers del smart contract
    function balanceEthersSC() public view returns (uint256) {
        return address(this).balance / 10**18; // el balance retorna en wei, entonces se divide para convertir a ethers
    }

    // generar más tokens ERC-20
    function mint(uint256 _amount) public onlyOwner {
        _mint(address(this), _amount);
    }

    // registro de usuarios
    function registrar() internal {
        // TODO ¿se tendrá que validar que 1 usurio solo pueda tener un boleto?
        address addr_personal_contract = address(new boletosNFT(msg.sender, address(this), nft_loteria_contract));
        usuario_contract[msg.sender] = addr_personal_contract;
    }

    // informacion de un usuario
    function usersInfo(address _account) public view returns(address) {
        return usuario_contract[_account];
    }

    // compra de tokens ERC-20
    function compraTokens(uint256 _numTokens) public payable {
        if (usuario_contract[msg.sender] == address(0)) {
            // si no se creó su boletoNFT para el usuario, significa que aún no se ha registrado
            registrar();
        }
        // establecimiento del costo de los tokens a comprar
        uint256 coste = precioTokens(_numTokens);
        
        // evaluación del dinero que el cliente quiere pagar por el token
        require(msg.value >= coste, "Compra menos tokens o paga mas ethers");
        
        // obtencion de numero de tokens ERC-20 disponibles
        uint256 balance = balanceTokensSC();

        require(_numTokens <= balance, "No hay stock suficiente, compre menos tokens");
       
        // devolución del dinero sobrante
        uint256 returnValue = msg.value - coste;
        
        // el smart contract devuelve la cantidad restante
        payable(msg.sender).transfer(returnValue);
        
        // envio de tokens al cliente/usuario
        _transfer(address(this), msg.sender, _numTokens);
    }

    // devolucion de tokens al smart contract
    function devolverTokens(uint _numTokens) public payable {
        // el numero de tokens debe ser mayor a cero
        require(_numTokens > 0, "Necesitas devolver un numero de tokens mayor a cero");
        // el usuario debe acreditar tener los tokens que quiere devolver:
        require(_numTokens <= balanceTokensERC20(msg.sender), "No tienes los tokens que deseas devolver");
        // el usuario transfiere los tokens al smart contract
        _transfer(msg.sender, address(this), _numTokens);
        // el smart contract envía los ethers al usuario
        payable(msg.sender).transfer(precioTokens(_numTokens));
    }

    // ===============================
    // -----Gestion de tokens-----
    // precio del boleto de loteria (en tokens ERC-20)
    uint public precioBoleto = 5; // cantidad de tokens
    // relacion: persona que compra los boletos -> el número de boletos
    mapping (address => uint[]) idPersona_boletos;

    // relacion: boleto -> ganador
    mapping (uint => address) ADNBoleto;

    // numero aleatorio:
    uint randNonce = 0;

    // boletos de lotería generados
    uint [] boletosComprados;

    // compra de boletos de loteria
    function compraBoleto(uint _numBoletos) public {
        // precio total de boletos a comprar
        uint precioTotal = _numBoletos * precioBoleto;

        // verificacion de los tokens del usuario:
        require(precioTotal <= balanceTokensERC20(msg.sender), 
        "No tienes suficientes tokens");

        // transferencia de tokens del usuario al Smart contract
        _transfer(msg.sender, address(this), precioTotal);
    
        for (uint i = 0; i < _numBoletos; i++) {
            // al usar el modulo 10**n, se generará un número en el rango de 0-(10**n -1)
            uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 10000;
            randNonce++;

            // almacenamiento de los datos del boleto enlazaos al usuario
            idPersona_boletos[msg.sender].push(random);

            // almacenamiento de los datos de los boletos
            boletosComprados.push(random);

            // asignacion del ADN del boleto para lageneracion de un ganador
            ADNBoleto[random] = msg.sender;

            // creacion de un nuevo NFT para el número del boleto
            boletosNFT(usuario_contract[msg.sender]).mintBoleto(msg.sender, random /* numero de loteria*/);
        }
    }

    // visualizacion de los boletos del usuario
    function tusBoletos(address _propietario) public view returns(uint [] memory) {
        return idPersona_boletos[_propietario];
    }

    // Generacion del ganador de la loteria
    function generarGanador() public onlyOwner {
        // declaracion de la longitud del array
        uint longitud = boletosComprados.length;

        // verificación de la compra de más de 1 boleto
        require(longitud > 1, "Solo hay 1 boleto comprado, deben de comprarse mas boletos");

        // eleccion aleatoria de un numero entre [0-longitud]
        uint random = uint(uint(keccak256(abi.encodePacked(block.timestamp))) % longitud);
    
        // seleccion del numero aleatorio
        uint eleccion = boletosComprados[random];

        // direccion de ganador de la loteria
        ganador = ADNBoleto[eleccion];

        // enviar el 95% del premio de loteria al ganador
        payable(ganador).transfer(address(this).balance * 95/100);

        // envio del 5% del premio al owner:
        payable(owner()).transfer(address(this).balance * 5/100);

    }
}

/* Cómo se usa:
- se despliega
- usuarios diferentes al owner para participar, primero deben de comprar tokens (cada uno vale 1ether)
- luego que tienen los tokens, puede elegir la cantidad de boletos que quieran adquirir (cada uno vale 5 tokens)
-- OBS: en la prueba, el primer usuario compró 20 tokens, pero solo canjeó 3 boletos, quedándole 5, entonces si
    decide devolver los tokens que le sobran, solo debería devolver 5, pero devolvió 20 .-.

- se ejecuta la funcion nft_loteria_contract, la cual entrega el address, y se usa para desplegar el contract de
    mainChisiERC721 con la opcion "At address"
- con el usuario Owner, se ejecuta la funcion generarGanador y ya se habrá completado la loteria

-- OBS: puntos de mejora, modificar para que permita sorteos, sin tener de resetear los datos, para tener
    un histórico,
    - hacer que sea como la tinka
        - Que se genere cada número aleatoriamente
        - Que el usuario elija sus números
        - Agregar más premios, según cantidad de números asertados
        - Luego del sorteo, un usuario puede validar si ganó
    
    - modificar para que hayan más premios

*/ 