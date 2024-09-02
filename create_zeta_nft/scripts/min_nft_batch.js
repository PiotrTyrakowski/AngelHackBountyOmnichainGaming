require('dotenv').config();
const ethers = require('ethers');
const fs = require('fs');

const mintNFT = async (contractAddress, metadataPath) => {
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

    // Create a contract instance
    const gamingNftContract = new ethers.Contract(contractAddress, abi, signer)

    const metadataContent = fs.readFileSync(metadataPath, { encoding: 'utf8' });
    const metadataJson = JSON.parse(metadataContent);

    const jsonURI = JSON.stringify(metadataJson);

    // Mint the NFT
    const nftTxn = await gamingNftContract.mintNFT(signer.address, jsonURI);
    await nftTxn.wait();
    console.log(`NFT Minted! Check it out at: https://athens.explorer.zetachain.com/evm/tx/${nftTxn.hash}`);

    console.log('NFT Metadata:', metadataJson);
    console.log('NFT tx:', nftTxn.hash);
}

const contractAddresses = [
    process.env.GAMING_NFT_ADDRESS_1,
    process.env.GAMING_NFT_ADDRESS_2
];
const nftMetadataPaths = [
    './nft-metadata/red-skin.json',
    './nft-metadata/blue-skin.json',
    './nft-metadata/green-skin.json',
    './nft-metadata/yellow-skin.json',
    './nft-metadata/purple-skin.json',
    './nft-metadata/orange-skin.json',
    './nft-metadata/pink-skin.json',
];

const mintNFTBatch = async (batch_size) => {
    const promises = [];
    for (let x = 0; x < parseInt(batch_size); x++) {
        for (let i = 0; i < contractAddresses.length; i++) {
            for (let j = 0; j < nftMetadataPaths.length; j++) {
                promises.push(mintNFT(contractAddresses[i], nftMetadataPaths[j]));
            }
        }
    }
    await Promise.all(promises);
}

const batch_size = 5;
if (!batch_size) {
    console.error('Usage: node mint_nft_batch.js <batch_size>');
    process.exit(1);
}

mintNFTBatch(batch_size)
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });