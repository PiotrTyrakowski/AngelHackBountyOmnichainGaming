import { ethers, Interface } from "ethers";
import contractAbi from "./abi/GamingNft.json";
import { assignCheckNull } from "./Utils.js";
import { validateAddress, validateTokenId, exponentialBackoffRetry } from "./Utils.js";

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
        this.contractAddress = assignCheckNull(contractAddress.toLowerCase(), "Contract address not provided");
        this.iface = assignCheckNull(new Interface(contractAbi.abi), "Interface not found");
    }

    /**
     * Get the metadata of a specific NFT token.
     * @param {number} tokenId - The ID of the NFT token.
     * @returns {Promise<string|null>} The metadata of the NFT token, or null if an error occurs.
     */
    async getNftMetadata(tokenId) {
        validateTokenId(tokenId);
        tokenId = parseInt(tokenId);

        const provider = assignCheckNull(new ethers.BrowserProvider(window.ethereum, this.network), "Provider");
        const signer = assignCheckNull(await provider.getSigner(), "Signer not found");

        try {
            const gamingNftContract = assignCheckNull(
                new ethers.Contract(this.contractAddress, this.iface, signer),
                "Contract not found");

            let metadata = assignCheckNull(await exponentialBackoffRetry(async () => {
                return await gamingNftContract.tokenURI(tokenId);
            }, 5), "Metadata URI not found");

            metadata = assignCheckNull(JSON.parse(metadata), "Metadata is not JSON");
            metadata = Object.fromEntries(Object.entries(metadata).map(([key, value]) => [key.toLowerCase(), value]));

            metadata["tokenid"] = tokenId;
            metadata["contractid"] = this.contractAddress;
            metadata["ownerid"] = assignCheckNull(await exponentialBackoffRetry(async () => {
                return await gamingNftContract.ownerOf(tokenId);
            }
                , 5), "Owner ID not found");

            metadata = JSON.stringify(metadata);
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
        // for all tokens, use validateTokenId to check if each token is a valid number and parse it to an integer
        tokens = tokens.map(token => parseInt(token));
        tokens.map(token => validateTokenId(token));

        try {
            return await Promise.all(tokens.map(tokenId => this.getNftMetadata(tokenId)));
        } catch (error) {
            console.error("Error retrieving multiple NFT metadata:", error);
            return null;
        }
    }
}

export default NftMetadataFetcher;
