require('dotenv').config();
const ethers = require('ethers');
const fs = require('fs');

const mintNFT = async () => {
    const contract = require("../contract_abi/GamingNFT.json");
    console.log(JSON.stringify(contract));

    // Create a signer
    const provider = new ethers.providers.JsonRpcProvider(process.env.API_URL);
    const privateKey = process.env.PRIVATE_KEY
    const signer = new ethers.Wallet(privateKey, provider)

    // Get contract ABI and address
    const abi = contract
    const contractAddress = '0xB75027AA1084c8fb8AcD99f2859a30f54E74E8a7'

    // Create a contract instance
    const gamingNftContract = new ethers.Contract(contractAddress, abi, signer)

    const metadataPath = './nft-metadata/red-skin.json';
    const metadataContent = fs.readFileSync(metadataPath, { encoding: 'utf8' });
    const metadataJson = JSON.parse(metadataContent); 

    const jsonURI = JSON.stringify(metadataJson);

    // Mint the NFT
    let nftTxn = await gamingNftContract.mintNFT(signer.address, jsonURI);
    await nftTxn.wait();
    console.log(`NFT Minted! Check it out at: https://sepolia.etherscan.io/tx/${nftTxn.hash}`);

    console.log('NFT Metadata:', metadataJson);
    console.log('NFT tx:', nftTxn.hash);

}


mintNFT()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });