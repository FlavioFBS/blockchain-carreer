// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*Galeria de arte con Tokens NFT:
- creacion de obras de arte digitales
- uso de tokens nft en las obras de arte
- extracción de beneficios económicos por cada nft generado
- token nft con propiedades
- incremento de las propiedades del token NFT
- envío de los fondos del smart contract al propietario del proyecto

Requisitos:
- compilador 0.8.0
- uso de tokens nft de open zeppelin  4.4.2
- codigo en english -.-

*/

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ArtToken is ERC721, Ownable {
    
    // initial statements

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    // NFT token counter
    uint256 COUNTER;

    // Pricing of NFT Tokens (price of the artwork)
    uint256 public fee = 5 ether;

    // Data structure with the properties of the artwork
    struct Art {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }

    // Storage strcuture for keeping artworks
    Art [] public art_works;

    // Declaration of an event
    event NewArtWork (address indexed owner, uint256 id, uint256 dna);

    // Help fuinctions:

    // Creation of Random number (require for NFT token propeties => internal)
    function _createRandom(uint256 _mod) internal view returns (uint256) {
        // _mod será potencia de 10
        bytes32 hash_randomNum = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        uint256 randomNum = uint256(hash_randomNum);
        return randomNum % _mod;
    }

    // NFT token creation (ArtWork)
    function _createArtWork(string memory _name) internal {
        uint8 randRarity = uint8(_createRandom(1000));
        uint256 randDna = _createRandom(10**16);
        Art memory newArtWork = Art(_name, COUNTER, randDna, 1, randRarity);
        art_works.push(newArtWork);
        // hacer minteo (esto se hace por cada generacion de token)
        _safeMint(msg.sender, COUNTER);

        emit NewArtWork(msg.sender, COUNTER, randDna);
        COUNTER++;
    }

    // NFT Token price update
    function updateFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    // Visualize Smart contract balance (ethers)
    function infoSmartContract() public view returns (address, uint256) {
        address smartContractAddress = address(this);
        uint256 smartContractMoney = address(this).balance / 10**18;
        return (smartContractAddress, smartContractMoney);
    }

    // Get al NFT created
    function getArtWorks() public view returns(Art [] memory) {
        return art_works;
    }

    // Get NFT tokens by user
    function getOwnerArtWork(address _owner) public view returns(Art [] memory) {
        Art [] memory result = new Art[](balanceOf(_owner));
        uint256 counter_owner = 0;

        for (uint256 i = 0; i<art_works.length; i++) {
            if (ownerOf(i) == _owner) {
                result[counter_owner] = art_works[i];
                counter_owner++;
            }
        }
        return result;
    }

    // NFT Token Development
    function createRandomArtWork(string memory _name) public payable {
        require(msg.value >= fee, "Value must to be major of fee (5ether)");
        _createArtWork(_name);
    }

    // pasar ethers de smart contract a owner (creador de artwork)
    // Extraction of ethers from the smart contract to the owner
    function withdraw() external payable onlyOwner{
        address payable _owner = payable (owner());
        // transferencia hacia el owner(creador de artwork)
        // con esto se le pasará todo lo que haya en balance del smart contract
        _owner.transfer(address(this).balance);
    }

    // Level up NFT tokens
    function levelUp(uint256 _artId) public {
        require(ownerOf(_artId) == msg.sender, "You dont be the artWork\'s owner");
        Art storage art = art_works[_artId];
        art.level++;
    }

}
