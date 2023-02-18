//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721URIStorage {
    // tokenid para asociar a cada usuario que tenga el nft 
    uint private _tokenIds;
    address payable owner;
    uint price;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can authorize users");
        _;
    }

    // se pasa el nombre del token y simbolo
    constructor(uint _price) ERC721("MyNFT", "NFT") {
        owner = payable(msg.sender);
        price = _price;
    }

    // para permitir asignar nft a otro usuario dentro de la blockchain
    function mintNFT(string memory tokenURI)
        public onlyOwner
        payable
        returns (uint256)
    {
        require(msg.value >= price, "You don't have enough funds");
        owner.transfer(msg.value);
        _tokenIds = _tokenIds + 1;
        // funcion que añade al balance de la cuenta el token que se está generando
        _mint(msg.sender, _tokenIds);
        // funciona que relaciona el tokenId con el tokenURI
        _setTokenURI(_tokenIds, tokenURI);

        return _tokenIds;
    }
}
