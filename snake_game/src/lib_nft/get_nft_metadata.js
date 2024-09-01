// get_nft_metadata.js
import { ethers, Interface } from 'ethers';
import jsonData from './GamingNFT.json';

// Retrieve NFT metadata from the contract
// @param tokenId The ID of the NFT token
// @param network The network to connect to ("sepolia" for Sepolia testnet)
export default async function getNFTMetadata(tokenId, network, contractAddress) {
    if (!network) {
        console.error("Network not provided");
        return null;
    }

    if (!tokenId) {
        console.error("Token ID not provided");
        return null;
    }

    if (!contractAddress) {
        console.error("Contract address not provided");
        return null;
    }

    const iface = new Interface(jsonData.abi);
    // console.log("Interface: ", iface);

    const provider = new ethers.BrowserProvider(window.ethereum);
    // console.log("Provider: ", provider);

    const signer = await provider.getSigner();
    // console.log("Signer: ", signer);

    try {
        const gamingNftContract = new ethers.Contract(contractAddress, iface, signer);
        // console.log("GamingNFT Contract: ", gamingNftContract);

        const metadata = await gamingNftContract.tokenURI(tokenId);
        console.log(`Metadata for Token ID ${tokenId}: ${metadata}`);

        return metadata;
    } catch (error) {
        console.error("Error retrieving NFT metadata:", error);
        return null;
    }
}

export function getTokensMetadata(tokens, network, contractAddress) {
    return Promise.all(tokens.map(tokenId => getNFTMetadata(tokenId, network, contractAddress)));
}