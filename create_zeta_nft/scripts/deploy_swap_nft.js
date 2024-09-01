async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Grab the contract factory 
  const SwapNftFactory = await ethers.getContractFactory("swapNFT");

  // Start deployment, returning a promise that resolves to a contract object
  const swapNft = await SwapNftFactory.deploy(); // Pass the deployer's address as the initial owner

  await swapNft.deployed();
  console.log("Contract deployed to address:", swapNft.address);


  const fs = require('fs');
  // Append the contract address to .env
  fs.appendFileSync('.env', `SWAP_NFT_ADDRESS=${swapNft.address}\n`);
  console.log("Contract address written to .env");

  // Write the contract ABI to a file
  const contract = require("../artifacts/contracts/swapNFT.sol/swapNFT.json");
  fs.writeFileSync('./contract_abi/swapNFT.json', JSON.stringify(contract.abi));
  console.log("Contract ABI written");

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
