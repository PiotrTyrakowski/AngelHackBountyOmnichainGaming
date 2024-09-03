import { request, gql } from 'graphql-request';
import { assignCheckNull, validateAddress } from './Utils.js';

/**
 * Class representing a fetcher for NFT swap data.
 */
class NftSwapsFetcher {
    /**
     * Create an NftSwapsFetcher.
     * @param {string} goldskyApi - The API endpoint for GraphQL requests.
     * @param {string} walletAddress - The wallet address of the user.
     * @throws Will throw an error if the goldskyApi or walletAddress is null or invalid.
     */
    constructor(goldskyApi, walletAddress) {
        this.goldskyApi = assignCheckNull(goldskyApi);
        this.walletAddress = assignCheckNull(walletAddress);
        validateAddress(walletAddress);
    }

    /**
     * Fetch swaps where the user is the initiator and the swap is not completed.
     * @returns {Promise<Object[]>} A promise that resolves to an array of swap objects where the user is the initiator and the swap is not completed.
     * @throws Will throw an error if the fetching fails.
     */
    async fetchInitiatedSwapsNotCompleted() {
        try {
            const initiatedSwaps = await this._fetchSwapsByUser(true);
            const completedSwapIds = await this._fetchCompletedOrCancelledSwapIds(initiatedSwaps.map(swap => swap.swapId), true);

            return initiatedSwaps.filter(
                swap => !completedSwapIds.includes(swap.swapId)
            );
        } catch (error) {
            console.error('Error fetching initiated swaps:', error);
            throw error;
        }
    }

    /**
     * Fetch swaps where the user is the counterparty and the swap is not completed.
     * @returns {Promise<Object[]>} A promise that resolves to an array of swap objects where the user is the counterparty and the swap is not completed.
     * @throws Will throw an error if the fetching fails.
     */
    async fetchCounterpartySwapsNotCompleted() {
        try {
            const counterpartySwaps = await this._fetchSwapsByUser(false);
            const completedSwapIds = await this._fetchCompletedOrCancelledSwapIds(counterpartySwaps.map(swap => swap.swapId), true);

            return counterpartySwaps.filter(
                swap => !completedSwapIds.includes(swap.swapId)
            );
        } catch (error) {
            console.error('Error fetching counterparty swaps:', error);
            throw error;
        }
    }

    /**
     * Fetch swaps where the user is either the initiator or counterparty and the swap is completed.
     * @returns {Promise<Object[]>} A promise that resolves to an array of completed swap objects where the user is either the initiator or counterparty.
     * @throws Will throw an error if the fetching fails.
     */
    async fetchCompletedSwaps() {
        try {
            const allSwaps = await this._fetchSwapsByUser(null);
            const completedSwapIds = await this._fetchCompletedOrCancelledSwapIds(allSwaps.map(swap => swap.swapId), true);

            return allSwaps.filter(
                swap => completedSwapIds.includes(swap.swapId)
            );
        } catch (error) {
            console.error('Error fetching completed swaps:', error);
            throw error;
        }
    }

    /**
     * Fetch swaps where the user is either the initiator or counterparty and the swap is cancelled.
     * @returns {Promise<Object[]>} A promise that resolves to an array of cancelled swap objects where the user is either the initiator or counterparty.
     * @throws Will throw an error if the fetching fails.
     */
    async fetchCancelledSwaps() {
        try {
            const allSwaps = await this._fetchSwapsByUser(null);
            const cancelledSwapIds = await this._fetchCompletedOrCancelledSwapIds(allSwaps.map(swap => swap.swapId), false);

            return allSwaps.filter(
                swap => cancelledSwapIds.includes(swap.swapId)
            );
        } catch (error) {
            console.error('Error fetching cancelled swaps:', error);
            throw error;
        }
    }

    /**
     * Fetch swaps where the user is either the initiator or counterparty.
     * @param {boolean|null} isInitiator - True if fetching swaps where the user is the initiator, false if the user is the counterparty, and null for both.
     * @returns {Promise<Object[]>} A promise that resolves to an array of swap objects.
     * @throws Will throw an error if the fetching fails.
     * @private
     */
    async _fetchSwapsByUser(isInitiator) {
        try {
            const query = this._buildUserSwapsQuery();

            const response = await request(
                this.goldskyApi,
                query,
                { walletAddress: this.walletAddress.toLowerCase() }
            );

            const swaps = response.swapInitiateds;

            return swaps.map(swap => ({
                swapId: swap.swapId,
                blockNumber: swap.block_number,
                timestamp: swap.timestamp_,
                transactionHash: swap.transactionHash_,
                initiator: swap.initiator,
                initiatorNftContracts: swap.initiatorNftContracts.split(','),
                initiatorTokenIds: swap.initiatorTokenIds.split(',').map(Number),
                initiatorTokenCounts: swap.initiatorTokenCounts.split(',').map(Number),
                counterparty: swap.counterparty,
                counterpartyNftContracts: swap.counterpartyNftContracts.split(','),
                counterpartyTokenIds: swap.counterpartyTokenIds.split(',').map(Number),
                counterpartyTokenCounts: swap.counterpartyTokenCounts.split(',').map(Number),
                contractId: swap.contractId_
            })).filter(swap => {
                if (isInitiator === true) {
                    return swap.initiator.toLowerCase() === this.walletAddress.toLowerCase();
                } else if (isInitiator === false) {
                    return swap.counterparty.toLowerCase() === this.walletAddress.toLowerCase();
                }
                return true;
            });
        } catch (error) {
            console.error('Error fetching user swaps:', error);
            throw error;
        }
    }

    /**
     * Fetch completed or cancelled swap IDs.
     * @param {string[]} swapIds - An array of swap IDs to check.
     * @param {boolean} [isCompleted=true] - True if fetching completed swaps, false if fetching cancelled swaps.
     * @returns {Promise<string[]>} A promise that resolves to an array of swap IDs that are either completed or cancelled.
     * @throws Will throw an error if the fetching fails.
     * @private
     */
    async _fetchCompletedOrCancelledSwapIds(swapIds, isCompleted = true) {
        try {
            const query = this._buildCompletionOrCancellationQuery(isCompleted ? 'swapCompleted' : 'swapCancelled');

            const response = await request(
                this.goldskyApi,
                query,
                { swapIds }
            );

            const swaps = response[`${isCompleted ? 'swapCompleted' : 'swapCancelled'}s`];
            return swaps.map(swap => swap.swapId);
        } catch (error) {
            console.error(`Error fetching ${isCompleted ? 'completed' : 'cancelled'} swaps:`, error);
            throw error;
        }
    }

    /**
     * Build a GraphQL query to fetch swaps where the user is the initiator or counterparty.
     * @returns {string} The GraphQL query string.
     * @private
     */
    _buildUserSwapsQuery() {
        return gql`
        query GetUserInitiatedSwaps($walletAddress: String!) {
            swapInitiateds(
                first: 100
                where: {
                    or: [
                        { initiator: $walletAddress },
                        { counterparty: $walletAddress }
                    ]
                }
            ) {
                swapId
                block_number
                timestamp_
                transactionHash_
                initiator
                initiatorNftContracts
                initiatorTokenIds
                initiatorTokenCounts
                counterparty
                counterpartyNftContracts
                counterpartyTokenIds
                counterpartyTokenCounts
                contractId_
            }
        }`;
    }

    /**
     * Build a GraphQL query to fetch completed or cancelled swaps.
     * @param {string} entity - The entity type to fetch, either 'swapCompleted' or 'swapCancelled'.
     * @returns {string} The GraphQL query string.
     * @private
     */
    _buildCompletionOrCancellationQuery(entity) {
        return gql`
        query GetCompletedOrCancelledSwaps($swapIds: [ID!]!) {
            ${entity}s(
                first: 100
                where: {
                    swapId_in: $swapIds
                }
            ) {
                swapId
            }
        }`;
    }
}

export default NftSwapsFetcher;
