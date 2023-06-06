// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Marketplace is ReentrancyGuard {
    address payable public /*inmutable*/ feeAccount;

    // porcentage al pagar nft
    uint public /*inmutable*/ feePercent;
    // contador de items:
    uint public itemCount;

    struct Item {
        uint itemId;
        IERC721 nft;
        uint tokenId;
        uint price;
        address payable seller;
        bool sold;
    }

    // relacionar items
    mapping (uint => Item) public items;

    // evento por oferta de nft
    event Offered(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint price,
        address indexed seller
    );

    // evento por compra
    event Bought(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint price,
        address indexed seller,
        address indexed buyer
    );

    constructor(uint _feePercent) {
        feeAccount = payable(msg.sender);
        feePercent = _feePercent;
    }

    // creacion de items
    function makeItem(IERC721 _nft, uint _tokenId, uint _price) external nonReentrant {
        require(_price > 0, "Price must be a positive number");
        itemCount++;
        // enviar el token de la persona que lo ofrece al marketplace
        _nft.transferFrom(msg.sender, address(this), _tokenId);
        //          se usa payable para indicar que esa direccion podrá recibir pagos 
        items[itemCount] = Item(
            itemCount,
            _nft,
            _tokenId,
            _price,
            payable(msg.sender),
            false
        );
        emit Offered(
            itemCount,
            address(_nft),
            _tokenId,
            _price,
            msg.sender
        );
    }

    function purchaseItem(uint _itemId) external payable nonReentrant {
        uint _totalPrice = getTotalPrice(_itemId);
        Item storage item = items[_itemId];
        require(_itemId > 0 && _itemId <= itemCount, "itemID must to be positive number");
        require(msg.value >= _totalPrice, "Isn\'t enought pay for the item, pay more -.-");
        require(!item.sold, "The article is sold");

        // transferir precio al vendedor
        item.seller.transfer(item.price);
        // transferir la comision al dueño del contrato -.-
        feeAccount.transfer(_totalPrice - item.price);

        // actualizar datos
        item.sold = true;
        // enviar nft al comprador
        item.nft.transferFrom(address(this), msg.sender, item.tokenId);
        emit Bought(
            _itemId,
            address(item.nft),
            item.tokenId,
            item.price, 
            item.seller,
            msg.sender
        );
    }

    function getTotalPrice(uint _itemId) view public returns(uint) {
        return ((items[_itemId].price*(100 + feePercent))/100);
    }

}
