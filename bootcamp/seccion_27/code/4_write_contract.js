const { ethers } = require('ethers');

const providerLink = 'http://127.0.0.1:7545';
const provider = new ethers.JsonRpcProvider(providerLink);

const account1 = '0xbB17c2Ac8142f274344b4bb91Cdb87D7f61eF190';
const account2 = '0x8b54831C1CFce9d386A897B366510Af19600b1B8';

const privateKey1 = '0x59a4898fdcc17a91a7e4abcf985655ed1b6f5645f5592d3f132bee58444830a3';
const wallet = new ethers.Wallet(privateKey1, provider);

const ERC20_ABI = [
    "function decimals() view returns (uint)",
    "function balanceOf(address) view returns (uint256)",
    "function transfer(address to, uint amount) returns (bool)"
];

const address = 'direccion Smart contract';
const contract = new ethers.Contract(address, ERC20_ABI, provider);

async function main() {
    const balance = await contract.balanceOf(account1);
    // en este caso se puede usar formatEther porque el contrato tiene 18 decimales:
    console.log({ balance_tokens: ethers.formatEther(balance) });
    // pero de manera general sería usar la funcion decimals para saber cuantos decimales
    // tiene el contrato y luego dividir por (10**(cantidad de decimales)):
    const decimals = await contract.decimals();
    console.log({balance_tokens_refactor: balance/10**decimals});

    const contractWithWallet = contract.connect(wallet);
    const tx = await contractWithWallet.transfer(account2, balance);
    await tx.wait();

    console.log(tx);
    const balanceAfter = await contract.balanceOf(account1);
    console.log({balance_tokens_after: balance/10**decimals});

    const balanceAccount2 = await contract.balanceOf(account2);
    console.log({balance_tokens_Account2: balance/10**decimals});
}

main()
