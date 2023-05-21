// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// para generar un número que represente a cada token
import "@openzeppelin/contracts/utils/Counters.sol";

// DEFI: fichirance

contract Chisiripisirifachere is ERC721  {
    // symbol: CPF

    // contadores para los ID's de los NFT's
    using Counters for Counters.Counter;
    Counters.Counter private _tokensIds;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    // envío de nft's
    function sendNFT(address _account) public {
        _tokensIds.increment(); // +1 al valor
        uint256 newItemId = _tokensIds.current(); // actual valor del contador
        _safeMint(_account, newItemId);
        
    }

}
