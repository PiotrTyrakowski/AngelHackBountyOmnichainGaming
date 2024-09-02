require('dotenv').config();
const ethers = require('ethers');
const fs = require('fs');

const mintNFT = async (contractAddress, metadataPath) => {
    if (!contractAddress) {
        console.log('Contract address not found');
        return;
    }
    if (!metadataPath) {
        console.log('Metadata path not found');
        return;
    }
    const contract = require("../contract_abi/GamingNFT.json");
    if (!contract) {
        console.log('Contract ABI not found');
        return;
    }

    // Create a signer
    const provider = new ethers.providers.JsonRpcProvider(process.env.API_URL);
    const privateKey = process.env.PRIVATE_KEY
    if (!privateKey) {
        console.log('Private key not found in .env file');
        return;
    }
    const signer = new ethers.Wallet(privateKey, provider)
    // Get contract ABI and address
    const abi = contract

    // Create a contract instance
    const gamingNftContract = new ethers.Contract(contractAddress, abi, signer)

    const metadataContent = fs.readFileSync(metadataPath, { encoding: 'utf8' });
    if (!metadataContent) {
        console.log('Metadata content not found');
        return;
    }
    const metadataJson = JSON.parse(metadataContent);
    if (!metadataJson) {
        console.log('Could not parse metadata JSON');
        return;
    }

    const jsonURI = JSON.stringify(metadataJson);

    // Mint the NFT
    const nftTxn = await gamingNftContract.mintNFT(signer.address, jsonURI);
    await nftTxn.wait();
    console.log(`NFT Minted! Check it out at: https://athens.explorer.zetachain.com/evm/tx/${nftTxn.hash}`);
    console.log('NFT Metadata:', metadataJson);
    console.log('NFT tx:', nftTxn.hash);
}

module.exports = mintNFT;