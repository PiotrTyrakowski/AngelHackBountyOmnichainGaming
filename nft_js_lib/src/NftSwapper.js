import { ethers, Interface } from 'ethers';
import swapperContractAbi from "./abi/SwapNft.json";
import nftContractAbi from "./abi/GamingNft.json";
import { assignCheckNull, validateAddress, validateTokenId, validateSwapId, zeroAddress } from './Utils.js';


// Fetcher class to fetch NFT metadata for a given token ID
/**
 * Represents a NftSwapper object.
 * @constructor
 * @param {ethers.Network} network - The network to connect to.
 * @param {string} contractAddress - The address of the swapper contract.
 */
class NftSwapper {
    /**
     * Represents a NftSwapper object.
     * @constructor
     * @param {ethers.Network} network - The network to connect to.
     * @param {string} contractAddress - The address of the swapper contract.
     */
    constructor(network, contractAddress) {
        validateAddress(contractAddress);
        if (!(network instanceof ethers.Network)) {
            console.error("Invalid network provided");
            console.error(new Error().stack);
            return;
        }

        this.network = assignCheckNull(network, "Network not provided");
        this.swapperContractAddress = assignCheckNull(contractAddress, "Contract address not provided");
        this.swapperContractInterface = assignCheckNull(new Interface(swapperContractAbi), "Interface not provided");
        this.nftContractInterface = assignCheckNull(new Interface(nftContractAbi.abi), "NFT Contract ABI not found");
        this.provider = assignCheckNull(new ethers.BrowserProvider(window.ethereum, this.network), "Provider not found");
        this.initialized = false;
        this.signer = null;
        this.nftSwapperContract = null;
    }

    /**
     * Initializes the necessary values asynchronously.
     * This method is used to initialize values that require asynchronous operations outside the constructor.
     * If the values have already been initialized, this method will return immediately.
     *
     * @returns {Promise<void>} - A promise that resolves when the initialization is complete.
     */
    async init() {
        if (this.initialized) {
            return;
        }
        this.signer = assignCheckNull(await this.provider.getSigner(), "Signer not found");
        this.nftSwapperContract = assignCheckNull(new ethers.Contract(this.swapperContractAddress, this.swapperContractInterface, this.signer), "NFT Swapper contract not found");
        this.initialized = true;
    }

    /**
     * Approves an NFT for swapping.
     *
     * @param {string} nftContractAddress - The address of the NFT contract.
     * @param {number} tokenId - The ID of the NFT token to approve.
     * @returns {Promise<void>} - A promise that resolves when the NFT is approved for swapping.
     */
    async approveNft(nftContractAddress, tokenId) {
        validateAddress(nftContractAddress);
        validateTokenId(tokenId);

        await this.init();

        if (isNaN(tokenId) || !Number.isInteger(tokenId)) {
            console.error("Token ID must be an integer");
            return;
        }
        if (tokenId < 0) {
            console.error("Token ID must be a positive integer");
            return;
        }
        if (tokenId > Number.MAX_SAFE_INTEGER) {
            console.error("Token ID is too large");
            return;
        }
        if (!nftContractAddress) {
            console.error("NFT contract address not provided");
            return;
        }

        const nftContract = new ethers.Contract(nftContractAddress, this.nftContractInterface, this.signer);
        const approveTx = await nftContract.approve(this.swapperContractAddress, tokenId);
        await approveTx.wait();
        console.log(`Approved NFT ${tokenId} for swapping`);
    }

    /**
     * Initiates a swap between two NFTs.
     *
     * @param {string} counterparty - The address of the account to swap with.
     * @param {string} nftContractA - The address of the NFT contract of token A the caller owns.
     * @param {string} tokenIdA - The ID of the NFT token the caller owns.
     * @param {string} nftContractB - The address of the NFT contract of token B the counterparty owns.
     * @param {string} tokenIdB - The ID of the NFT token B the counterparty owns.
     * @returns {Promise<number>} The ID of the initiated swap.
     */
    async initiateSwap(counterparty, nftContractA, tokenIdA, nftContractB, tokenIdB) {
        validateAddress(counterparty);
        validateAddress(nftContractA);
        validateAddress(nftContractB);
        validateTokenId(tokenIdA);
        validateTokenId(tokenIdB);
        await this.init();

        await this.approveNft(nftContractA, tokenIdA);

        const initiateTx = await this.nftSwapperContract.initiateSwap(
            counterparty,
            nftContractA,
            tokenIdA,
            nftContractB,
            tokenIdB
        );

        const receipt = await initiateTx.wait();
        console.log(`Swap initiated: ${receipt.transactionHash}`);

        const swapId = await this.nftSwapperContract.swapCounter() - 1;
        console.log(`Swap ID: ${swapId}`);
        return swapId;
    }

    /**
     * Completes a swap by approving the NFT transfer and calling the `completeSwap` function on the NftSwapper contract.
     * @param {string} swapId - The ID of the swap to complete.
     * @param {string} nftContractB - The address of the NFT contract for the NFT being received.
     * @param {string} tokenIdB - The ID of the NFT being received.
     * @returns {Promise<void>} - A promise that resolves when the swap is completed.
     */
    async completeSwap(swapId, nftContractB, tokenIdB) {
        validateAddress(nftContractB);
        validateTokenId(tokenIdB);
        validateSwapId(swapId);
        await this.init();

        await this.approveNft(nftContractB, tokenIdB);

        const completeTx = await this.nftSwapperContract.completeSwap(swapId);
        const receipt = await completeTx.wait();
        console.log(`Swap completed: ${receipt.transactionHash}`);
    }

    /**
     * Cancels a swap by its ID.
     * @param {string} swapId - The ID of the swap to cancel.
     * @returns {Promise<void>} - A promise that resolves when the swap is cancelled.
     */
    async cancelSwap(swapId) {
        validateSwapId(swapId);
        await this.init();

        const cancelTx = await this.nftSwapperContract.cancelSwap(swapId);
        const receipt = await cancelTx.wait();
        console.log(`Swap cancelled: ${receipt.transactionHash}`);
    }

    /**
     * @typedef {Object} Swap
     * @property {string} initiator - Address of the initiator
     * @property {string} counterparty - Address of the counterparty
     * @property {string} nftContractA - Address of the first NFT contract
     * @property {string} tokenIdA - Token ID of the first NFT
     * @property {string} nftContractB - Address of the second NFT contract
     * @property {string} tokenIdB - Token ID of the second NFT
     * @property {boolean} isCompleted - Whether the swap is completed
     */

    /**
     * Retrieves the swap details from the contract and parses it into a Swap object.
     * 
     * @param {number} swapId - The ID of the swap to retrieve.
     * @returns {Promise<Swap|null>} - The parsed swap object or null if the swap is not found.
     */
    async getSwap(swapId) {
        validateSwapId(swapId);
        await this.init();

        const swap = await this.nftSwapperContract.swaps(swapId);
        if (!swap.initiator) {
            console.error(`Swap with ID ${swapId} not found`);
            return null;
        }

        validateAddress(swap.initiator);
        validateAddress(swap.counterparty);
        validateAddress(swap.nftContractA);
        validateAddress(swap.nftContractB);
        validateTokenId(parseInt(swap.tokenIdA));
        validateTokenId(parseInt(swap.tokenIdB));

        /** @type {Swap} */
        const swapObject = {
            initiator: swap.initiator,
            counterparty: swap.counterparty,
            nftContractA: swap.nftContractA,
            tokenIdA: parseInt(swap.tokenIdA),
            nftContractB: swap.nftContractB,
            tokenIdB: parseInt(swap.tokenIdB),
            isCompleted: swap.isCompleted
        };

        // check if the swap exists
        if (
            swapObject.initiator === zeroAddress() ||
            swapObject.counterparty === zeroAddress() ||
            swapObject.nftContractA === zeroAddress() ||
            swapObject.nftContractB === zeroAddress() ||
            swapObject.tokenIdA === 0 ||
            swapObject.tokenIdB === 0
        ) {
            console.log("No swap found with ID", swapId);
            return null;
        }

        return swapObject;

    }
}

export default NftSwapper;

