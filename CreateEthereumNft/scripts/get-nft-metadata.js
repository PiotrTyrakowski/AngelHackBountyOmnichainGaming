
require('dotenv').config();
const ethers = require('ethers');
const fs = require('fs');

const getNFTMetadata = async () => {
    const contract = require("../artifacts/contracts/GamingNft.sol/GamingNFT.json");
    console.log(JSON.stringify(contract.abi));

    // Create a signer
    const provider = new ethers.providers.JsonRpcProvider(process.env.API_URL);
    const privateKey = process.env.PRIVATE_KEY
    const signer = new ethers.Wallet(privateKey, provider)

    // Get contract ABI and address
    const abi = contract.abi
    const contractAddress = '0x6479A92F15CC8558c823eaCd1013b047DA90BA8f'

    const gamingNftContract = new ethers.Contract(contractAddress, abi, signer)
    // Define the token ID for which you want to retrieve metadata
    const tokenId = 1; // Example token ID, adjust as necessary

    // Retrieve the metadata
    try {
        const metadata = await gamingNftContract.tokenURI(tokenId);
        console.log(`Metadata for Token ID ${tokenId}: ${metadata}`);
    } catch (error) {
        console.error("Error retrieving metadata:", error);
    }
};

getNFTMetadata()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });