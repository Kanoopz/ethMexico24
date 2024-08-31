require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: 
  {
    version: "0.8.24",
    settings: 
    {
      optimizer: 
      {
        enabled: true,
        runs: 200
      }
    }
  },
  networks:
  {
    hardhat:
    {},
    amoy:
    {
      url: "https://polygon-amoy.infura.io/v3/408559c55ba7479b9f3adee094af9d80",
      accounts: ["0xd046263c0533990c39363b2211811de7d563f9be0d61135fad86db497e2073d5"],
    },
    //Address: 0x1e2e64828Cb332cC41A972020e45249C3B252e9e
    //Private key: 057706fe20a0fef74c81bca939b6c8d0f7ac5cc3920c1e7d8615804a58f8d22b
    goerli:
    {
      url: "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
      accounts: ["0xd046263c0533990c39363b2211811de7d563f9be0d61135fad86db497e2073d5"]
    },
    opGoerli:
    {
      url: "https://proud-tiniest-research.optimism-goerli.discover.quiknode.pro/2e8d9e36f8615b34a5c2353c44ddf450267e86f1/",
      accounts: ["0xd046263c0533990c39363b2211811de7d563f9be0d61135fad86db497e2073d5"]
    },
    baseGoerli: 
    {
      url: "https://base-goerli.public.blastapi.io",
      accounts: ["0xd046263c0533990c39363b2211811de7d563f9be0d61135fad86db497e2073d5"]
    }, 
    sepolia:
    {
      url: "https://rpc.sepolia.org/",
      accounts: ["0xd046263c0533990c39363b2211811de7d563f9be0d61135fad86db497e2073d5"]
    },
    arbSepolia:
    {
      url: "https://arb-sepolia.g.alchemy.com/v2/offZMXvXMjPT3Umglb0CN3fuwSJDtZcB",
      accounts: ["0xd046263c0533990c39363b2211811de7d563f9be0d61135fad86db497e2073d5"]
    },
    fuji:
    {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      accounts: ["0xd046263c0533990c39363b2211811de7d563f9be0d61135fad86db497e2073d5"]
    },
    zkyoto:
    {
      url: "https://zkyoto.explorer.startale.com/",
      chainId: 6038361,
      accounts: ["0xd046263c0533990c39363b2211811de7d563f9be0d61135fad86db497e2073d5"]
    },
    shibuya:
    {
      url: "https://shibuya.blockscout.com",
      chainId: 81,
      accounts: ["0xd046263c0533990c39363b2211811de7d563f9be0d61135fad86db497e2073d5"]
    }
  },
  etherscan:
  {
    apiKey:
    {
      goerli: 'XK44A4C8275XQFE79DCJ5XF38JPUZQKJBU',
      polygonMumbai: '8QVTC5IT9JVB3S7HHNRIAHQNYW9WHHUH2X',
      polygonAmoy: '8QVTC5IT9JVB3S7HHNRIAHQNYW9WHHUH2X',
      optimisticGoerli: 'I9K6THC5PWY4W3AKXB6EM59I47FJ5RHMPU',
      baseGoerli: '1b743f33-a914-40b2-84e1-98983de0ec87',
      sepolia: 'XK44A4C8275XQFE79DCJ5XF38JPUZQKJBU',
      arbitrumSepolia: 'XH35E3UEWPKDWJZG8UW1Z9JQP88IPYZPCM',
      zkyoto: 'empty',
      shibuya: 'empty'
    }
  }
};