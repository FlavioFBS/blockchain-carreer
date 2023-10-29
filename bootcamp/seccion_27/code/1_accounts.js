const { ethers } = require('ethers');
const { INFURA_ID } = require('./constants');
const providerLink = `https://mainnet.infura.io/v3/${INFURA_ID}`;

const provider = new ethers.JsonRpcProvider(providerLink);
const address = '0xBE0eB53F46cd790Cd13851d5EFf43D12404d33E8';

async function main() {
    const balance = await provider.getBalance(address);
    
    console.log({balance_ETH: ethers.formatEther(balance)});
}

await main();
