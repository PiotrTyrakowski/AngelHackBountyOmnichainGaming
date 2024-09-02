require('dotenv').config();
const ethers = require('ethers');
const fs = require('fs');

const mintNFT = require('./mint_nft');

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
    for (let x = 0; x < parseInt(batch_size); x++) {
        for (let i = 0; i < contractAddresses.length; i++) {
            for (let j = 0; j < nftMetadataPaths.length; j++) {
                console.log(`Minting NFT ${x * contractAddresses.length * nftMetadataPaths.length + i * nftMetadataPaths.length + j + 1}`);
                try {
                    await mintNFT(contractAddresses[i], nftMetadataPaths[j]);
                } catch (error) {
                    console.error(error);
                    return;
                }
            }
        }
    }
};


const batch_size = parseInt(process.argv[2]);
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