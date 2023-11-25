const TokenFarm = artifacts.require("TokenFarm");

// desde truffle se puede ejecutar el archivo:    truffle exec /ruta/archivo.js
module.exports = async function (callback) {
  let tokenFarm = await TokenFarm.deployed();
  await tokenFarm.issueTokens();

  console.log('Tokens emitidos');
  callback();
}
