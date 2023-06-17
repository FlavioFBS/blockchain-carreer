const ContractTestGanache = artifacts.require("TestGanache");

        // nombre de coontract
contract("TestGanache", accounts => {
    console.log({accounts});
    
    it('owner', async () => {
        let instance = await ContractTestGanache.deployed();
                            // se usa la variable owner que viene del contract
        const _owner = await instance.owner.call();
        assert.equal(_owner, accounts[0]);
    })

    it('getMessage', async () => {
        let instance = await ContractTestGanache.deployed();
        const _get = await instance.getMessage.call();
        assert.equal(_get, "");
    })

    it('setMessage & getMessage', async () => {
        let instance = await ContractTestGanache.deployed();
        const _setMessage = await instance.setMessage("Test1 -.-", {from: accounts[0]})
        console.log("_setMessage", _setMessage);

        const _get = await instance.getMessage.call();
        assert.equal("Test1 -.-", _get);
    })
})
