// lotteries.service.js

const config = require('../../config/config');

const Web3 = require('web3');
const ethereumUrl = `http://${config.eth.nodeUrl}:${config.eth.nodePort}`;
const web3 = new Web3(ethereumUrl);

/**
 * Return a list of registered lotteries.
 */
async function getLotteries() {
  // Ethereum config
  const ethereumUrl = `http://${config.eth.nodeUrl}:${config.eth.nodePort}`;
  const gasLimit = config.eth.transactionOptions.gas;
  const gasPrice = config.eth.transactionOptions.gasPrice;
  // Lottery contract specs
  const LotteryContractName = config.contracts.Lottery.contractName;
  const LotteryContractAddress = config.contracts.Lottery.contractAddress;
  const LotteryContractAbi = config.contracts.Lottery.contractAbi;
  // TODO
  return { message: 'Ok' };
}

/**
 * Return all the information of the lottery corresponding to the given address.
 * @param {string} lotteryAddress address of the lottery
 */
async function getLottery(lotteryAddress) {
  
  //Inicializar wrapper de web3 del contrato (en este caso del contrato Storage)
  const contractABI = JSON.parse(config.contracts.Lottery.contractAbi);
  const contract = new web3.eth.Contract(contractABI, 
    config.contracts.Lottery.contractAddress);
  
  var lotteryInfo;
  //Llamada al método del contrato para leer la info de la loteria
  contract.methods.store(21).send({from: config.eth.nodeACC}).then((response) => {
    lotteryInfo = response;
    console.log(response);
  }).catch((error) => {
    console.log(error);
  });

  return lotteryInfo;
}

/**
 * Create a new lottery in the system. It returns the transactionHash,
 * address of the created lottery and address of the creator.
 * @param {string} privateKey private key of the operator (tx sender)
 * @param {object} lotteryData object with lottery parameters
 */
async function createLottery(privateKey, lotteryData) {
  // Lottery data
  const {
    maxNumberParticipants,
    participationPrice,
    participationPot,
    prize,
  } = lotteryData;


  return { message: 'Ok' };
}

/**
 * Return a list of lottery's participants.
 * @param {string} lotteryAddress address of the lottery
 */
async function getParticipants(lotteryAddress) {
   //Inicializar wrapper de web3 del contrato (en este caso del contrato Storage)
   const contractABI = JSON.parse(config.contracts.Lottery.contractAbi);
   const contract = new web3.eth.Contract(contractABI, 
     config.contracts.Lottery.contractAddress);

   //Llamada al método del contrato para leer la info de la loteria
   const lotteryInfo = await contract.methods.retrieve().call({from: config.eth.nodeACC});
   console.log(lotteryInfo);
}

/**
 * Allow to participate in a lottery. It returns the transactionHash,
 * address of the lottery and address of the participant.
 * @param {string} privateKey private key of the operator (tx sender)
 * @param {string} lotteryAddress address of the lottery
 */
async function addParticipant(privateKey, lotteryAddress) {
  // TODO
  return { message: 'Ok' };
}

/**
 * Allow a participant to withdraw its participation, ang get a refund.
 * It returns the transactionHash, address of the lottery and address
 * of the participant.
 * @param {string} privateKey private key of the operator (tx sender)
 * @param {string} lotteryAddress address of the lottery
 */
async function withdrawParticipation(privateKey, lotteryAddress) {
  // TODO
  return { message: 'Ok' };
}

/**
 * Allow the creator of a lottery to raffle the prize between its
 * participants. It returns the transactionHash, address of the
 * lottery and the address of the winner.
 * @param {string} privateKey private key of the operator (tx sender)
 * @param {string} lotteryAddress address of the lottery
 */
async function raffle(privateKey, lotteryAddress) {
  // TODO
  return { message: 'Ok' };
}


module.exports = {
  getLotteries,
  getLottery,
  createLottery,
  getParticipants,
  addParticipant,
  withdrawParticipation,
  raffle,
};
