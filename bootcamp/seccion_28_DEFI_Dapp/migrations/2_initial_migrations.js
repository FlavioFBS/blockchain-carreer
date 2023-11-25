const JamToken = artifacts.require("JamToken");
const ChisiDefiToken = artifacts.require("ChisiDefiToken");
const TokenFarm = artifacts.require("TokenFarm");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(JamToken);
  const jamtoken = await JamToken.deployed();

  await deployer.deploy(ChisiDefiToken);
  const chisiDefiToken = await ChisiDefiToken.deployed();

  await deployer.deploy(TokenFarm, chisiDefiToken.address, jamtoken.address);
  const tokenFarm = await TokenFarm.deployed();

  // transferir tokens de recompensa a TokenFarm (1millon -> el totalSupply de chisidefi):
  await chisiDefiToken.transfer(tokenFarm.address, '1000000000000000000000000');

  // transferencia de tokens para staking
  await jamtoken.transfer(accounts[1], '100000000000000000000');
}
