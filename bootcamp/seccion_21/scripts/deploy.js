// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  await hre.run('compile') // para compilar antes de desplegar
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const unlockTime = currentTimestampInSeconds + 60;

  const lockedAmount = hre.ethers.parseEther("0.001");

  const lock = await hre.ethers.deployContract("Lock", [unlockTime], {
    value: lockedAmount,
  });

  await lock.waitForDeployment();

  // Otra forma de deploy:
  const helloContract = await hre.ethers.getContractFactory("Hello");
  const helloContractToDeploy = await helloContract.deploy();
  // await lockContractToDeploy.deployed(); // descontinuado

  console.log(
    `Lock with ${ethers.formatEther(
      lockedAmount
    )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.target}`
  );
  const helloContractAddress = await helloContractToDeploy.getAddress();
  console.log(
  `Hello contract deploy to ${helloContractAddress}, info contract:\ ${JSON.stringify(helloContract, null, 4)}}\n\n`,
    helloContractToDeploy
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
