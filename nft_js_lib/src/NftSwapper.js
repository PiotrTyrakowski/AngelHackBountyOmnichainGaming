import { ethers, Interface } from 'ethers';
import swapperContractAbi from "./abi/SwapNft.json";
import nftContractAbi from "./abi/GamingNft.json";
import { assignCheckNull, validateAddress, validateTokenId, validateSwapId, zeroAddress } from './Utils.js';

/**
 * Represents a NftSwapper object that interacts with a smart contract to facilitate NFT swaps.
 * @class
 */
class NftSwapper {
    /**
     * Creates an instance of NftSwapper.
     * @constructor
     * @param {ethers.Network} network - The network to connect to.
     * @param {string} contractAddress - The address of the swapper contract.
     * @throws Will throw an error if the contract address is invalid.
     * @throws Will throw an error if the network is invalid.
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
        this.swapperContractInterface = assignCheckNull(new Interface(swapperContractAbi.abi), "Interface not provided");
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
     * @async
     * @returns {Promise<void>} A promise that resolves when the initialization is complete.
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
     * Approves an NFT for swapping by allowing the swapper contract to transfer the specified NFT.
     * @async
     * @param {string} nftContractAddress - The address of the NFT contract.
     * @param {number} tokenId - The ID of the NFT token to approve.
     * @returns {Promise<void>} A promise that resolves when the NFT is approved for swapping.
     * @throws Will throw an error if the token ID is invalid.
     * @throws Will throw an error if the NFT contract address is invalid.
     */
    async approveNft(nftContractAddress, tokenId) {
        validateAddress(nftContractAddress);
        validateTokenId(tokenId);

        await this.init();

        const nftContract = new ethers.Contract(nftContractAddress, this.nftContractInterface, this.signer);
        const approveTx = await nftContract.approve(this.swapperContractAddress, tokenId);
        await approveTx.wait();
        console.log(`Approved NFT ${tokenId} for swapping`);
    }

    /**
     * Initiates a swap between two parties, transferring the NFTs to the contract.
     * @async
     * @param {string} counterparty - The address of the counterparty.
     * @param {string[]} initiatorContracts - Array of the NFT contracts of the initiator.
     * @param {number[]} initiatorTokenIds - Array of the token IDs of the NFTs that the initiator is swapping.
     * @param {number[]} initiatorTokenCounts - Array representing the number of tokens being swapped from each initiator's contract.
     * @param {string[]} counterpartyContracts - Array of the NFT contracts of the counterparty.
     * @param {number[]} counterpartyTokenIds - Array of the token IDs of the NFTs that the counterparty is swapping.
     * @param {number[]} counterpartyTokenCounts - Array representing the number of tokens being swapped from each counterparty's contract.
     * @returns {Promise<number>} The ID of the initiated swap.
     * @throws Will throw an error if any of the provided addresses or token IDs are invalid.
     */
    async initiateSwap(counterparty, initiatorContracts, initiatorTokenIds, initiatorTokenCounts, counterpartyContracts, counterpartyTokenIds, counterpartyTokenCounts) {
        validateAddress(counterparty);
        initiatorContracts.forEach(validateAddress);
        counterpartyContracts.forEach(validateAddress);
        initiatorTokenIds.forEach(validateTokenId);
        counterpartyTokenIds.forEach(validateTokenId);

        await this.init();

        for (let i = 0; i < initiatorContracts.length; i++) {
            let start = 0;
            for (let j = 0; j < i; j++) {
                start += initiatorTokenCounts[j];
            }
            for (let k = start; k < start + initiatorTokenCounts[i]; k++) {
                await this.approveNft(initiatorContracts[i], initiatorTokenIds[k]);
            }
        }

        const initiateTx = await this.nftSwapperContract.initiateSwap(
            counterparty,
            initiatorContracts,
            initiatorTokenIds,
            initiatorTokenCounts,
            counterpartyContracts,
            counterpartyTokenIds,
            counterpartyTokenCounts
        );

        const receipt = await initiateTx.wait();
        console.log(`Swap initiated: ${receipt.transactionHash}`);

        const swapId = await this.nftSwapperContract.swapCounter() - 1;
        console.log(`Swap ID: ${swapId}`);
        return swapId;
    }

    /**
     * Completes a swap by approving the NFT transfer and calling the `completeSwap` function on the NftSwapper contract.
     * @async
     * @param {number} swapId - The ID of the swap to complete.
     * @param {string[]} counterpartyContracts - Array of the NFT contracts for the NFTs being received.
     * @param {number[]} counterpartyTokenIds - Array of the token IDs of the NFTs being received.
     * @param {number[]} counterpartyTokenCounts - Array representing the number of tokens being swapped from each counterparty's contract.
     * @returns {Promise<void>} A promise that resolves when the swap is completed.
     * @throws Will throw an error if the swap ID, contract addresses, or token IDs are invalid.
     */
    async completeSwap(swapId, counterpartyContracts, counterpartyTokenIds, counterpartyTokenCounts) {
        validateSwapId(swapId);
        counterpartyContracts.forEach(validateAddress);
        counterpartyTokenIds.forEach(validateTokenId);

        await this.init();

        for (let i = 0; i < counterpartyContracts.length; i++) {
            let start = 0;
            for (let j = 0; j < i; j++) {
                start += counterpartyTokenCounts[j];
            }
            for (let k = start; k < start + counterpartyTokenCounts[i]; k++) {
                await this.approveNft(counterpartyContracts[i], counterpartyTokenIds[k]);
            }
        }

        const completeTx = await this.nftSwapperContract.completeSwap(swapId);
        const receipt = await completeTx.wait();
        console.log(`Swap completed: ${receipt.transactionHash}`);
    }

    /**
     * Cancels a swap by its ID.
     * @async
     * @param {number} swapId - The ID of the swap to cancel.
     * @returns {Promise<void>} A promise that resolves when the swap is cancelled.
     * @throws Will throw an error if the swap ID is invalid.
     */
    async cancelSwap(swapId) {
        validateSwapId(swapId);
        await this.init();

        const cancelTx = await this.nftSwapperContract.cancelSwap(swapId);
        const receipt = await cancelTx.wait();
        console.log(`Swap cancelled: ${receipt.transactionHash}`);
    }

    // /**
    //  * Retrieves the details of a swap by its ID and parses it into a Swap object.
    //  * @async
    //  * @param {number} swapId - The ID of the swap to retrieve.
    //  * @returns {Promise<Object|null>} The parsed swap object or null if the swap is not found.
    //  * @throws Will throw an error if the swap ID is invalid.
    //  * 
    //  * @typedef {Object} Swap
    //  * @property {string} initiator - The address of the initiator.
    //  * @property {string} counterparty - The address of the counterparty.
    //  * @property {string[]} initiatorNftContracts - Array of the initiator's NFT contracts.
    //  * @property {number[]} initiatorTokenIds - Array of the initiator's token IDs.
    //  * @property {number[]} initiatorTokenCounts - Array representing the number of tokens being swapped from each initiator's contract.
    //  * @property {string[]} counterpartyNftContracts - Array of the counterparty's NFT contracts.
    //  * @property {number[]} counterpartyTokenIds - Array of the counterparty's token IDs.
    //  * @property {number[]} counterpartyTokenCounts - Array representing the number of tokens being swapped from each counterparty's contract.
    //  * @property {boolean} isCompleted - Whether the swap is completed.
    //  */
}

export default NftSwapper;
