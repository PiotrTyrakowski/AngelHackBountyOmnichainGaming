// get_nft_metadata.js
import {ethers, Interface} from 'ethers';
import jsonData from './GamingNFT.json';

const contractAddress = '0x6479A92F15CC8558c823eaCd1013b047DA90BA8f';

export default async function getNFTMetadata(tokenId) {
    const iface = new Interface(jsonData.abi);
    console.log("Interface: ", iface);
    const provider = new ethers.BrowserProvider(window.ethereum, "sepolia");
    console.log("Provider: ", provider);
    const signer = await provider.getSigner();
    console.log("Signer: ", signer);

    try {
        const gamingNftContract = new ethers.Contract(contractAddress, iface, signer);
        console.log("GamingNFT Contract: ", gamingNftContract);
        const metadata = await gamingNftContract.tokenURI(tokenId);
        console.log(`Metadata for Token ID ${tokenId}: ${metadata}`);
        return metadata;
    } catch (error) {
        console.error("Error retrieving NFT metadata:", error);
        return null;
    }
}
