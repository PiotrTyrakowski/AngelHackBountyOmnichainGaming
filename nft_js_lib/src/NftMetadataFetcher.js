import { ethers, Interface } from "ethers";
import contractAbi from "./abi/GamingNft.json";
import { assignCheckNull } from "./Utils.js";
import { validateAddress, validateTokenId } from "./Utils.js";

// Fetcher class to fetch NFT metadata for a given token ID
/**
 * Class representing a NFT Metadata Fetcher.
 */
class NftMetadataFetcher {
    /**
     * Create a NftMetadataFetcher.
     * @param {ethers.Network} network - The network to connect to.
     * @param {string} contractAddress - The address of the NFT contract.
     */
    constructor(network, contractAddress) {
        validateAddress(contractAddress);
        if (!(network instanceof ethers.Network)) {
            console.error("Invalid network provided");
            console.error(new Error().stack);
            return;
        }
        this.network = assignCheckNull(network, "Network not provided");
        this.contractAddress = assignCheckNull(contractAddress, "Contract address not provided");
        this.iface = assignCheckNull(new Interface(contractAbi.abi), "Interface not found");
    }

    /**
     * Get the metadata of a specific NFT token.
     * @param {number} tokenId - The ID of the NFT token.
     * @returns {Promise<string|null>} The metadata of the NFT token, or null if an error occurs.
     */
    async getNftMetadata(tokenId) {
        validateTokenId(tokenId);

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

    /**
     * Get the metadata of multiple NFT tokens.
     * @param {number[]} tokens - An array of NFT token IDs.
     * @returns {Promise<(string|null)[]>} An array of NFT metadata, or null if an error occurs.
     */
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
