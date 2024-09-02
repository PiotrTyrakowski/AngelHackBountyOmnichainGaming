import { ethers, Interface } from 'ethers';
import swapperContractAbi from "./abi/SwapNft.json";
import nftContractAbi from "./abi/GamingNft.json";
import { assignCheckNull, validateAddress, validateTokenId, validateSwapId } from './Utils.js';


// Fetcher class to fetch NFT metadata for a given token ID
class NftSwapper {
    constructor(network, contractAddress) {
        validateAddress(contractAddress);
        this.network = assignCheckNull(network, "Network not provided");
        this.swapperContractAddress = assignCheckNull(contractAddress, "Contract address not provided");
        this.swapperContractInterface = assignCheckNull(new Interface(swapperContractAbi), "Interface not provided");
        this.nftContractInterface = assignCheckNull(new Interface(nftContractAbi.abi), "NFT Contract ABI not found");
        this.provider = assignCheckNull(new ethers.BrowserProvider(window.ethereum, this.network), "Provider not found");
        this.initialized = false;
        this.signer = null;
        this.nftSwapperContract = null;
    }

    async init() {
        if (this.initialized) {
            return;
        }
        this.signer = assignCheckNull(await this.provider.getSigner(), "Signer not found");
        this.nftSwapperContract = assignCheckNull(new ethers.Contract(this.swapperContractAddress, this.swapperContractInterface, this.signer), "NFT Swapper contract not found");
        this.initialized = true;
    }

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

    async cancelSwap(swapId) {
        validateSwapId(swapId);
        await this.init();

        const cancelTx = await this.nftSwapperContract.cancelSwap(swapId);
        const receipt = await cancelTx.wait();
        console.log(`Swap cancelled: ${receipt.transactionHash}`);
    }
}

export default NftSwapper;

