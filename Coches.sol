// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Coches {
    address owner;
    uint256 precio;
    // lista de coches:
    uint256[] identificadores;

    // mapa: es como diccionario clave-valor
    mapping(address => Coche) coches;

    struct Coche {
        uint256 identificador;
        string marca;
        uint32 caballos;
        uint32 kilometros;
    }

    modifier precioFiltro(uint256 _precio) {
        require(_precio == precio);
        _;
    }

    constructor(uint256 _precio) {
        owner = msg.sender;
        precio = _precio;
    }

    function addCoche(uint256 _id, string memory _marca, uint32 _caballos, uint32 _kilometros) external precioFiltro(msg.value) payable {
        identificadores.push(_id);
        coches[msg.sender].identificador = _id;
        coches[msg.sender].marca = _marca;
        coches[msg.sender].caballos = _caballos;
        coches[msg.sender].kilometros = _kilometros;
    }

    function cantidadCoches() external view returns (uint256) {
        return identificadores.length;
    }

    function getInfoCoche() external view returns(string memory marca, uint32 caballos, uint32 kilometros) {
        marca = coches[msg.sender].marca;
        caballos = coches[msg.sender].caballos;
        kilometros = coches[msg.sender].kilometros;
        return (marca,caballos,kilometros);
    }
}
