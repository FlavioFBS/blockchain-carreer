// const { tasks } = require("hardhat");

require("@nomicfoundation/hardhat-toolbox");

/**
 * tasks
 * https://hardhat.org/guides/create-task.html
 */
task("accounts", "prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
})

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  // personalizar ubicación de carpetas
  paths: {
    artifacts: "./artifacts",
    sources: "./contracts",
    cache: "./cache",
    tests: "./test"
  },
  // selecciona de red por default:
  // defaultNetwork: 'ganache',

  // lista de redes
  networks: {
    ganache: {
      url: "http://127.0.0.1:8545",
    },
    // matic: {
    //   url: "link node de polygon",
    //   accounts: ["privateKey"]
    // }
  }
};
