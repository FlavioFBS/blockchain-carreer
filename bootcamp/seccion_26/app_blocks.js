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

async function checkBlocks() {
    // const lastBlock = await web3.eth.getBlock('latest')
    // const camposPorBlock = Object.keys(lastBlock)
    // console.log({lastBlock});
    // console.log({camposPorBlock});

    // consultar los últimos 10 blockes:
    web3.eth.getBlockNumber().then(latest => {
        for (let i = 0; i < 10; i++) {
            web3.eth.getBlock(parseInt(latest) - 1).then(block => {
                console.log({
                    [`Block - ${i}`]: {
                        hash: block.hash,
                        number: block.number,
                        nonce: block.nonce
                    }
                });
            })
        }
    });
}

(async () => {
    await checkBlocks()
})()

