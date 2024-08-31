require('dotenv').config();
const ethers = require('ethers');
const fs = require('fs');

const mintNFT = async () => {
    const contract = require("../artifacts/contracts/GamingNft.sol/GamingNFT.json");
    console.log(JSON.stringify(contract.abi));

    // Create a signer
    const provider = new ethers.providers.JsonRpcProvider(process.env.API_URL);
    const privateKey = process.env.PRIVATE_KEY
    const signer = new ethers.Wallet(privateKey, provider)

    // Get contract ABI and address
    const abi = contract.abi
    const contractAddress = '0x6479A92F15CC8558c823eaCd1013b047DA90BA8f'

    // Create a contract instance
    const gamingNftContract = new ethers.Contract(contractAddress, abi, signer)

    const metadataPath = './nft-metadata/red-skin.json'; // Ensure this path is correct
    const metadataContent = fs.readFileSync(metadataPath, { encoding: 'utf8' });
    const metadataJson = JSON.parse(metadataContent); // Parse the JSON content to ensure it's valid JSON

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