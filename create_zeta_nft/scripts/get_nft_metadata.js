
require('dotenv').config();
const ethers = require('ethers');
const fs = require('fs');

const getNFTMetadata = async () => {
    const contract = require("../contract_abi/GamingNFT.json");
    if (!contract) {
        console.log('Contract ABI not found');
        return;
    }

    // Create a signer
    const provider = new ethers.providers.JsonRpcProvider(process.env.API_URL);
    const privateKey = process.env.PRIVATE_KEY
    const signer = new ethers.Wallet(privateKey, provider)

    // Get contract ABI and address
    const abi = contract
    const contractAddress = process.env.GAMING_NFT_ADDRESS_1

    const gamingNftContract = new ethers.Contract(contractAddress, abi, signer)

    // Define the token ID for which you want to retrieve metadata
    const tokenId = 1;

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
