const { ethers } = require('ethers');

const providerLink = 'http://127.0.0.1:7545';
const provider = new ethers.JsonRpcProvider(providerLink);

const account1 = '0xbB17c2Ac8142f274344b4bb91Cdb87D7f61eF190';
const account2 = '0x8b54831C1CFce9d386A897B366510Af19600b1B8';

const privateKey1 = '0x59a4898fdcc17a91a7e4abcf985655ed1b6f5645f5592d3f132bee58444830a3';
// crear cartera
const wallet = new ethers.Wallet(privateKey1, provider);

async function main() {
    const senderBalance = await provider.getBalance(account1);
    console.log({senderBalance: ethers.formatEther(senderBalance)});

    const receiverBalanceBefore = await provider.getBalance(account2);
    console.log({receiverBalanceBefore: ethers.formatEther(receiverBalanceBefore)});

    const tx = await wallet.sendTransaction({
        to: account2,
        value: ethers.parseEther('0.25')
    })
    await tx.wait();
    console.log({tx});

    const senderBalanceAfter = await provider.getBalance(account1);
    console.log({senderBalanceAfter: ethers.formatEther(senderBalanceAfter)});

    const receiverBalanceAfter = await provider.getBalance(account2);
    console.log({receiverBalanceAfter: ethers.formatEther(receiverBalanceAfter)});

}

main();
