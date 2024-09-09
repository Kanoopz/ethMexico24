// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const {ethers} = require("hardhat");

async function main() 
{
  // const contractFactory = await ethers.getContractFactory("mpVault");
  //  const contractFactory = await ethers.getContractFactory("ethereum");astarL2ZkEvmMpUsd
  //  const contractFactory = await ethers.getContractFactory("astarZkEvm");
  //  const contractFactory = await ethers.getContractFactory("astarVault");
  const contractFactory = await ethers.getContractFactory("numberSc");
   const contractInstance = await contractFactory.deploy();
   await contractInstance.waitForDeployment();

   console.log("Contract deploy at address:", await contractInstance.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
