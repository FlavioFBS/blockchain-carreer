// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract ethSend {
    // para indicar que el contract hará transacciones de eth
    constructor() payable {}

    // funcion para guardar o recibir -> ejm realizacion de pago
    receive() external payable {}

    // eventos
    event sendStatus(bool);
    event callStatus(bool, bytes);

    // formas de hacer envio:
    // transfer --> envía 2300 unidade de gas al receptor (al receive)
    // payable en parametro para indicar que la direccion recibirá
    function sendViaTransfer(address payable _to) public payable {
        // para que desde el msg.sender se envía a "_to"
        _to.transfer(1 ether); // poner solo 1 es para enviar gas
    }

    // send --> envía 2300 unidade de gas al receptor (al receive)
    function sendViaSend(address payable _to) public payable {
        // se diferencia en que la funcion send indica el estado de la transferencia
        bool sentSuccessfully = _to.send(1 ether);
        emit sendStatus(sentSuccessfully);
        require(sentSuccessfully == true, "El envio ha fallado ._.");
    }

    // call --> envía todo el gas al receptor (al receive)
    function sendViaCAll(address payable _to) public payable {
        (bool success, bytes memory data) = _to.call{value: 1 ether}("");
        emit callStatus(success, data);
        require(success == true, "El envio por call a fallado");
    }
}


contract ethReceiver {
    event log(uint amount, uint gas);

    receive() external payable {
        emit log(address(this).balance, gasleft());
    }
}
