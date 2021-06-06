const DbiliaToken = artifacts.require("./DbiliaToken.sol");

module.exports = function(deployer) {
  deployer.deploy(DbiliaToken);
};