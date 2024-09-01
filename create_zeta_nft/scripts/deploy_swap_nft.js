async function main() {
   const [deployer] = await ethers.getSigners();

   console.log("Deploying contracts with the account:", deployer.address);
   
   // Grab the contract factory 
   const SwapNFT = await ethers.getContractFactory("swapNFT");

   // Start deployment, returning a promise that resolves to a contract object
   const swapNFT = await SwapNFT.deploy(); // Pass the deployer's address as the initial owner
   
   await swapNFT.deployed();
   console.log("Contract deployed to address:", swapNFT.address);

   const fs = require('fs');
   const contract = require("../artifacts/contracts/swapNFT.sol/swapNFT.json");
   fs.writeFileSync('./contract_abi/swapNFT.json', JSON.stringify(contract.abi)); // u łukasza jest inaczej xd sprawdzcie
   console.log("Contract ABI written");

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });