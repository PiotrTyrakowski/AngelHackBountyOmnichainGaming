// get_nft_metadata.js
import { ethers } from 'ethers';
import jsonData from './GamingNFT.json';

const contractAddress = '0x6479A92F15CC8558c823eaCd1013b047DA90BA8f';

export default async function getNFTMetadata() {
    console.log("ABI json: ", jsonData.abi);
    const provider = new ethers.BrowserProvider(window.ethereum)
    console.log("Provider: ", provider);
    const signer = await provider.getSigner();
    console.log("Signer: ", signer);

    try {
        const gamingNftContract = new ethers.Contract(contractAddress, jsonData.abi, signer);
        console.log("GamingNFT Contract: ", gamingNftContract);
        const tokenId = 1;
        const metadata = await gamingNftContract.tokenURI(tokenId);
        console.log(`Metadata for Token ID ${tokenId}: ${metadata}`);
    } catch (error) {
        console.error("Error retrieving NFT metadata:", error);
    }
}
