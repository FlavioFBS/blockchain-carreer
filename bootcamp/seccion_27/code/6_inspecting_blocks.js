const { ethers } = require('ethers');
const { INFURA_ID } = require('./constants');

const providerLink = `https://mainnet.infura.io/v3/${INFURA_ID}`;
const provider = new ethers.JsonRpcProvider(providerLink);

async function main() {
    const blockNumber = await provider.getBlockNumber();
    console.log({block: blockNumber});

    const blockInfo = await provider.getBlock(blockNumber);
    console.log({blockInfo});
}

main()
