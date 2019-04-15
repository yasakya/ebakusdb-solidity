module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      network_id: '*', // Any network (default: none)
      gas: 6000000,
      port: 8546,
      websockets: true,
    },
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: '0.5.0',
    },
  },
};
