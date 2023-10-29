const { ethers } = require('ethers');
const { INFURA_ID } = require('./constants');
const providerLink = `https://mainnet.infura.io/v3/${INFURA_ID}`;

const provider = new ethers.JsonRpcProvider(providerLink);
const address = '0xBE0eB53F46cd790Cd13851d5EFf43D12404d33E8';

const contractAddress = '0x6b94a5f5450ED93B1f4b6FeBCDC94743EcD88aE1';

const ERC20_ABI = [
    "function name() view returns (string)",
    "function symbol() view returns (string)",
    "function totalSupply() view returns (uint256)",
    "function balanceOf(address) view returns (uint256)",
    "event Transfer(address indexed from, address indexed to, uint amount)",
]

const contract = new ethers.Contract(address, ERC20_ABI. provider);

async function main() {
    const block = await provider.getBlockNumber();

    // emitir evento entre bloques:
    const transferEvents = await contract.queryFilter('Transfer', block - 1, block);

    console.log({transferEvents});
}

