import { request, gql } from 'graphql-request';
import { assignCheckNull, validateAddress } from './Utils.js';

// Fetcher class to fetch user's NFTs
/**
 * Class representing an NFT Fetcher.
 */
class NftFetcher {
  /**
   * Constructor to initialize the API and the wallet address.
   * @param {string} goldskyApi - The Goldsky API.
   * @param {string} walletAddress - The wallet address.
   */
  constructor(goldskyApi, walletAddress) {
    this.goldskyApi = assignCheckNull(goldskyApi, 'Goldsky API not provided');
    this.walletAddress = assignCheckNull(walletAddress.toLowerCase(), 'Wallet address not provided');
    validateAddress(walletAddress);
  }

  /**
   * Method to fetch user's NFT.
   * @returns {Promise<string[]>} - The owned tokens.
   * @throws {Error} - If there is an error fetching user NFTs.
   */
  async fetchUserNft() {
    try {
      const transfers = assignCheckNull(await this.fetchUserTransfers(), 'Transfers not found');

      // Sort the transfers based on block number
      transfers.sort(
        (a, b) => parseInt(a.block_number) - parseInt(b.block_number)
      );

      // Initialize an object to track current ownership
      let currentOwnership = {};

      // Iterate over transfers to determine current ownership
      transfers.forEach(transfer => {
        if (transfer.to.toLowerCase() === this.walletAddress.toLowerCase()) {
          currentOwnership[transfer.tokenId] = true;
        } else if (transfer.from.toLowerCase() === this.walletAddress.toLowerCase()) {
          currentOwnership[transfer.tokenId] = false;
        }
      });

      // Filter owned tokens
      const ownedTokens = Object.keys(currentOwnership).filter(id => currentOwnership[id]);
      return ownedTokens;
    } catch (error) {
      console.error('Error fetching user NFTs:', error);
      throw error;
    }
  }

  /**
   * Method to fetch user transfers.
   * @returns {Promise<Object[]>} - The user transfers.
   * @throws {Error} - If there is an error fetching transfers.
   */
  async fetchUserTransfers() {
    try {
      const response = await request(
        this.goldskyApi,
        this._buildQuery(this.walletAddress)
      );

      const transfers = response.transfers;
      console.log('Transfers:', transfers);
      return transfers;
    } catch (error) {
      console.error('Error fetching transfers:', error);
      throw error;
    }
  }

  /**
   * Private method to build the GraphQL query.
   * @param {string} address - The wallet address.
   * @returns {string} - The GraphQL query.
   * @private
   */
  _buildQuery(address) {
    return gql`
      query {
        transfers(
          first: 100
          where: {
            or: [
              { to: "${address}" }
              { from: "${address}" }
            ]
          }
        ) {
          id
          to
          from
          block_number
          tokenId
        }
      }
    `;
  }
}

export default NftFetcher;
