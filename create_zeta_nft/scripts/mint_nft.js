require('dotenv').config();
const ethers = require('ethers');
const fs = require('fs');

const mintNFT = async () => {
    const contract = require("../contract_abi/GamingNFT.json");
    if(!contract) {
      console.log('Contract ABI not found');
      return;
    }

    // Create a signer
    const provider = new ethers.providers.JsonRpcProvider(process.env.API_URL);
    const privateKey = process.env.PRIVATE_KEY
    const signer = new ethers.Wallet(privateKey, provider)

    // Get contract ABI and address
    const abi = contract
    const contractAddress = process.env.GAMING_NFT_ADDRESS

    // Create a contract instance
    const gamingNftContract = new ethers.Contract(contractAddress, abi, signer)

    const metadataPath = './nft-metadata/blue-skin.json';
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


mintNFT()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
