import { ethers, Interface } from "ethers";
import contractAbi from "./abi/GamingNFT.json";

class NftMetadataFetcher {
    constructor(network, contractAddress) {
        if (!network) {
            throw new Error("Network not provided");
        }

        if (!contractAddress) {
            throw new Error("Contract address not provided");
        }

        this.network = network;
        this.contractAddress = contractAddress;
        this.iface = new Interface(contractAbi.abi);
    }

    async getNftMetadata(tokenId) {
        if (!tokenId) {
            console.error("Token ID not provided");
            return null;
        }

        const provider = new ethers.BrowserProvider(window.ethereum, this.network);
        if (!provider) {
            console.error("Provider not found");
            return null;
        }
        const signer = await provider.getSigner();
        if (!signer) {
            console.error("Signer not found");
            return null;
        }

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
