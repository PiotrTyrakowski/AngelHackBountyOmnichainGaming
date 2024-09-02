async function main() {
  const [deployer] = await ethers.getSigners();

  // Grab the contract factory 
  const gamingNftFactory = await ethers.getContractFactory("GamingNFT");

  // Start deployment, returning a promise that resolves to a contract object
  const gamingNft = await gamingNftFactory.deploy(deployer.address); // Pass the deployer's address as the initial owner

  await gamingNft.deployed();
  console.log("Contract deployed to address:", gamingNft.address);

  const fs = require('fs');
  fs.appendFileSync('.env', `GAMING_NFT_ADDRESS_2=${gamingNft.address}\n`);
  console.log("Contract address written to .env");


  const contract = require("../artifacts/contracts/GamingNft.sol/GamingNft.json");
  fs.writeFileSync('../contract_abi/GamingNft.json', JSON.stringify(contract.abi));
  console.log("Contract ABI written");

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
