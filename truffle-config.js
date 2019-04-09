module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      // port: 8545,
      network_id: '*', // Any network (default: none)
      gas: 6000000,
      // gasPrice: 20000000000,  // 20 gwei (in wei) (default: 100 gwei)
      // from: <address>,        // Account to send txs from (default: accounts[0])
      port: 8546,
      websockets: true,
    },
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: '0.5.7',
    },
  },
};
