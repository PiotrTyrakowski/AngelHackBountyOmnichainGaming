import { ethers, Interface } from "ethers";
import contractAbi from "./abi/GamingNft.json";
import { assignCheckNull } from "./Utils.js";

// Fetcher class to fetch NFT metadata for a given token ID
class NftMetadataFetcher {
    constructor(network, contractAddress) {
        this.network = assignCheckNull(network, "Network not provided");
        this.contractAddress = assignCheckNull(contractAddress, "Contract address not provided");
        this.iface = assignCheckNull(new Interface(contractAbi.abi), "Interface not found");
    }

    async getNftMetadata(tokenId) {
        if (!tokenId) {
            console.error("Token ID not provided");
            return null;
        }

        const provider = assignCheckNull(new ethers.BrowserProvider(window.ethereum, this.network), "Provider not found");
        const signer = assignCheckNull(await provider.getSigner(), "Signer not found");

        try {
            const gamingNftContract = new ethers.Contract(this.contractAddress, this.iface, signer);
            const metadata = await gamingNftContract.tokenURI(tokenId);
            return metadata;
        } catch (error) {
            console.error(`Error retrieving NFT metadata for Token ID ${tokenId}:`, error);
            return null;
        }
    }

    async getTokensMetadata(tokens) {
        if (!tokens || !Array.isArray(tokens)) {
            console.error("Invalid tokens array provided");
            return null;
        }

        try {
            return await Promise.all(tokens.map(tokenId => this.getNftMetadata(tokenId)));
        } catch (error) {
            console.error("Error retrieving multiple NFT metadata:", error);
            return null;
        }
    }
}

export default NftMetadataFetcher;
