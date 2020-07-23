// 2_deploy_lottery.js

// TODO
const Lottery = artifacts.require('Lottery');

module.exports = async (deployer) => {
  await deployer.deploy(Lottery);
};
