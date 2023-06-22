const customERC20 = artifacts.require("customERC20");

contract("customERC20", accounts => {
    console.log({accounts})

    it("name", async () => {
        let instance = await customERC20.deployed();
        let _name = await instance.name.call();
        assert.equal(_name, "Chisi");
    })

    it("symbol", async () => {
        let instance = await customERC20.deployed();
        let _symbol = await instance.symbol.call();
        assert.equal(_symbol, "CH");
    })

    it("decimal", async () => {
        let instance = await customERC20.deployed();
        let decimals = await instance.decimals.call();
        assert.equal(decimals, 18);
    })

    it("createTokens", async () => {
        let instance = await customERC20.deployed();
        const _initialSupply = await instance.totalSupply.call();
        assert.equal(_initialSupply, 0);
        await instance.createTokens();

        const _newSupply = await instance.totalSupply.call();
        assert.equal(_newSupply, 1000);

        let _balance = await instance.balanceOf.call(accounts[0]);
        assert.equal(_balance, 1000, "Verificacion de balance");
    });

    it("transfer", async () => {
        let instance = await customERC20.deployed();
        const amount = 10
        const accountFrom = accounts[0];
        const accountTo = accounts[1];

        await instance.transfer(accountTo, amount, { from: accountFrom});
        
        let _balance0 = await instance.balanceOf.call(accountFrom);
        assert.equal(_balance0, 1000-amount);
        let _balance1 = await instance.balanceOf.call(accountTo);
        assert.equal(_balance1, amount);
    });

    it("approve, allowance & transferFrom", async () => {
        let instance = await customERC20.deployed();
        const accountOwnerTokens = accounts[0];
        const accountSpenderTokens = accounts[1];

        let _initialAllowance = await instance.allowance.call(accountOwnerTokens, accountSpenderTokens);
        console.log({_initialAllowance});
        assert.equal(_initialAllowance, 0);

        // hacer aprobacion para gestionar token:
        const amountTokensToSpend = 100;
        await instance.approve(accountSpenderTokens, amountTokensToSpend, { from: accountOwnerTokens});
        let _currentAllowance = await instance.allowance.call(accountOwnerTokens, accountSpenderTokens);
        assert.equal(_currentAllowance, amountTokensToSpend);
        
        let _balanceSpender = await instance.balanceOf.call(accountSpenderTokens);
        assert.equal(_balanceSpender, 10);
        
        // transfering tokens
        const accountRecieverTokens = accounts[2];
        await instance.transferFrom(accountOwnerTokens, accountRecieverTokens, 100, {from: accountSpenderTokens});
        
        let _allowanceAfterTranfer = await instance.allowance.call(accountOwnerTokens, accountSpenderTokens);
        assert.equal(_allowanceAfterTranfer, 0);

        let _balanceReciever = await instance.balanceOf.call(accountRecieverTokens);
        assert.equal(_balanceReciever, 100);
    });

    it("increaseAllowance & decreaseAllowance", async () => {
        let instance = await customERC20.deployed();
        const accountOwnerTokens = accounts[0];
        const accountSpenderTokens = accounts[4];
        const accountRecieverTokens = accounts[2];

        const amountTokensToSpend = 150;
        await instance.approve(accountSpenderTokens, amountTokensToSpend, { from: accountOwnerTokens});
        let _allowanceSpender = await instance.allowance.call(accountOwnerTokens, accountSpenderTokens);
        assert.equal(_allowanceSpender, amountTokensToSpend);

        await instance.increaseAllowance(accountSpenderTokens, 200);
        let _allowanceSpenderAdded200 = await instance.allowance.call(accountOwnerTokens, accountSpenderTokens);
        assert.equal(_allowanceSpenderAdded200, amountTokensToSpend + 200);


        await instance.decreaseAllowance(accountSpenderTokens, 50);
        let _allowanceSpenderLess50 = await instance.allowance.call(accountOwnerTokens, accountSpenderTokens);
        assert.equal(_allowanceSpenderLess50, _allowanceSpenderAdded200 - 50);
    });

    it("burn", async () => {
        let instance = await customERC20.deployed();

        let _totalBalance = await instance.balanceOf.call(accounts[0]);

        await instance.destruirTokens(accounts[0], _totalBalance);
        let _totalBalance2 = await instance.balanceOf.call(accounts[0]);
        assert.equal(_totalBalance2, 0);
    })

})

