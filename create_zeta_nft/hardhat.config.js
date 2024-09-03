require("dotenv").config();
require("@nomiclabs/hardhat-ethers"); // Ensure this is the correct package
const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.24",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
          viaIR: true,
        },
      }
    ],
  },
  defaultNetwork: "zetachain",
  networks: {
    hardhat: {},
    zetachain: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
};