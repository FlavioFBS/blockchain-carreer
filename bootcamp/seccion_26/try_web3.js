const Web3 = require('web3');

const cloud = {
    provider: '', // ejm:  infura project
    address: '0x6b94a5f5450ED93B1f4b6FeBCDC94743EcD88aE1'
}
const local = {
    provider: 'http://127.0.0.1:7545',
    address: '0xbB17c2Ac8142f274344b4bb91Cdb87D7f61eF190'
}
let web3 = new Web3.Web3(cloud.provider)

function startCheckBalance() {
    let balance = web3.eth.getBalance(cloud.address)
        .then(value => {
            console.log({ value });
            console.log(web3.utils.fromWei(value, "ether") + " ETH")
        })
        .catch(err => {
            console.log({ err: err.errors });
        })
    console.log({ balance });
}

async function connectSC() {
    const abi = [{ "inputs": [], "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [{ "indexed": true, "internalType": "address", "name": "owner", "type": "address" }, { "indexed": true, "internalType": "address", "name": "spender", "type": "address" }, { "indexed": false, "internalType": "uint256", "name": "value", "type": "uint256" }], "name": "Approval", "type": "event" }, { "anonymous": false, "inputs": [{ "indexed": false, "internalType": "uint256", "name": "_maxTxAmount", "type": "uint256" }], "name": "MaxTxAmountUpdated", "type": "event" }, { "anonymous": false, "inputs": [{ "indexed": true, "internalType": "address", "name": "previousOwner", "type": "address" }, { "indexed": true, "internalType": "address", "name": "newOwner", "type": "address" }], "name": "OwnershipTransferred", "type": "event" }, { "anonymous": false, "inputs": [{ "indexed": true, "internalType": "address", "name": "from", "type": "address" }, { "indexed": true, "internalType": "address", "name": "to", "type": "address" }, { "indexed": false, "internalType": "uint256", "name": "value", "type": "uint256" }], "name": "Transfer", "type": "event" }, { "inputs": [], "name": "_maxTaxSwap", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "_maxTxAmount", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "_maxWalletSize", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "_reduceBuyTaxAt", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "_reduceSellTaxAt", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "_taxSwapThreshold", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }], "stateMutability": "view", "type": "function" }, { "inputs": [{ "internalType": "address[]", "name": "bots_", "type": "address[]" }], "name": "addBots", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [{ "internalType": "address", "name": "owner", "type": "address" }, { "internalType": "address", "name": "spender", "type": "address" }], "name": "allowance", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }], "stateMutability": "view", "type": "function" }, { "inputs": [{ "internalType": "address", "name": "spender", "type": "address" }, { "internalType": "uint256", "name": "amount", "type": "uint256" }], "name": "approve", "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [{ "internalType": "address", "name": "account", "type": "address" }], "name": "balanceOf", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "decimals", "outputs": [{ "internalType": "uint8", "name": "", "type": "uint8" }], "stateMutability": "pure", "type": "function" }, { "inputs": [{ "internalType": "address[]", "name": "notbot", "type": "address[]" }], "name": "delBots", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "gottagofast", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [{ "internalType": "address", "name": "a", "type": "address" }], "name": "isBot", "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "manualSwap", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "name", "outputs": [{ "internalType": "string", "name": "", "type": "string" }], "stateMutability": "pure", "type": "function" }, { "inputs": [], "name": "owner", "outputs": [{ "internalType": "address", "name": "", "type": "address" }], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "removeLimits", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "renounceOwnership", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "symbol", "outputs": [{ "internalType": "string", "name": "", "type": "string" }], "stateMutability": "pure", "type": "function" }, { "inputs": [], "name": "totalSupply", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }], "stateMutability": "pure", "type": "function" }, { "inputs": [{ "internalType": "address", "name": "recipient", "type": "address" }, { "internalType": "uint256", "name": "amount", "type": "uint256" }], "name": "transfer", "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "transferDelayEnabled", "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }], "stateMutability": "view", "type": "function" }, { "inputs": [{ "internalType": "address", "name": "sender", "type": "address" }, { "internalType": "address", "name": "recipient", "type": "address" }, { "internalType": "uint256", "name": "amount", "type": "uint256" }], "name": "transferFrom", "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }], "stateMutability": "nonpayable", "type": "function" }, { "stateMutability": "payable", "type": "receive" }]
    // console.log({abi});

    const contract = new web3.eth.Contract(abi, cloud.address);
    console.log({ contract: contract.methods });

    const result = await contract.methods.name().call()
    // ((err, result) => {
    //     if (err) {
    //         console.log({error_totalSupply: err});
    //     }
    console.log({ result });
    // })
}

async function transfer() {
    web3 = new Web3.Web3(local.provider)

    const account1 = '0xbB17c2Ac8142f274344b4bb91Cdb87D7f61eF190';
    const account2 = '0x8b54831C1CFce9d386A897B366510Af19600b1B8';

    let balance1 = await web3.eth.getBalance(account1);
    let balance2 = await web3.eth.getBalance(account2);
    console.log('before', { balance1, balance2 });

    const result = await web3.eth.sendTransaction({
        from: account1,
        to: account2,
        value: web3.utils.toWei('1', 'ether')
    })
    console.log({ result });
    balance1 = await web3.eth.getBalance(account1);
    balance2 = await web3.eth.getBalance(account2);
    console.log('after', { balance1, balance2 });
}

async function utilidadesWeb3js() {
    const utils = web3.utils;
    const sha3 = utils.sha3('texto xddd');
    const keccak256 = utils.keccak256("texto xddd");
    const soliditySha3 = utils.soliditySha3("texto", " ","xddd");
    const soliditySha3_v2 = utils.soliditySha3(
        {type: 'string', value: 'texto'},
        {type: 'string', value: ' '},
        {type: 'string', value: 'xddd'},
    )
    const soliditySha3_v2_multiType = utils.soliditySha3(
        {type: 'string', value: 'xd'},
        {type: 'string', value: ' '},
        {type: 'uint16', value: 0x3031},
    )

    const lenthRandomHex = 4;
    const randomHexagesimal = utils.randomHex(lenthRandomHex);
    const isHex = utils.isHex(randomHexagesimal);
    const hexToNumber = utils.hexToNumber('0xea');
    const numberToHext = utils.numberToHex(243);
    const utf8ToHex = utils.utf8ToHex('texto de prueba -.-');
    const hexToUtf8 = utils.hexToUtf8(utf8ToHex);

    console.log({
        sha3,
        keccak256,
        soliditySha3,
        soliditySha3_v2,
        soliditySha3_v2_multiType,
        randomHexagesimal,
        isHex,
        hexToNumber,
        numberToHext,
        hexToUtf8,
        utf8ToHex
    });
}

(async () => {
    // await startCheckBalance()
    // await connectSC()
    // await transfer();
    await utilidadesWeb3js();
})()
