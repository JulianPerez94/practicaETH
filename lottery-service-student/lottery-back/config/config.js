// config.js

/* eslint-disable max-len */

// TODO: Make your own configuration
module.exports = {
  eth: {
    nodeUrl: 'localhost',
    nodePort: '20000',
    nodeACC: '0x5D0CDCF55da6b19950eE4E94779a97BEfDAF8862',
    transactionOptions: {
      gas: 6721975,
      gasPrice: 0,
    },
  },
  contracts: {
    Lottery: {
      contractName: 'Lottery',
      contractAddress: '0xCfEB869F69431e42cdB54A4F4f105C19C080A601',
      contractAbi: '[{"constant":true,"inputs":[],"name":"retreive","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"num","type":"uint256"}],"name":"store","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]',
      maxNumberOfParticipants: 5,
      participationPrice: 1,
      participationPot: 2,
      prize: 100
    },
    Migrations: {
      
    }
  },
};
