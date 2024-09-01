const fs = require('fs');

async function main() {
  const [deployer] = await ethers.getSigners();

  // Grab the contract factory 
  const MyNFT = await ethers.getContractFactory("GamingNFT");

  // Start deployment, returning a promise that resolves to a contract object
  const myNFT = await MyNFT.deploy(deployer.address); // Pass the deployer's address as the initial owner

  await myNFT.deployed();
  console.log("Contract deployed to address:", myNFT.address);

  // Append the contract address to .env
  fs.appendFileSync('.env', `GAMING_NFT_ADDRESS=${myNFT.address}\n`);
  console.log("Contract address written to .env");

  // Write the contract ABI to a file
  const contract = require("../artifacts/contracts/GamingNft.sol/GamingNFT.json");
  fs.writeFileSync('../contract_abi/GamingNFT.json', JSON.stringify(contract.abi));
  console.log("Contract ABI written");

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });