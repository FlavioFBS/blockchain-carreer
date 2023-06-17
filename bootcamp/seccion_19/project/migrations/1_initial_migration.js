const ContractTestGanache = artifacts.require("TestGanache");

module.exports = function (deployer) {
  deployer.deploy(ContractTestGanache);
};
