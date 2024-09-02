import { request, gql } from 'graphql-request';

// Fetcher class to fetch user's NFTs
class NftFetcher {
  // Constructor to initialize the API and the wallet address
  constructor(goldskyApi, walletAddress) {
    this.goldskyApi = goldskyApi;
    this.walletAddress = walletAddress;
    if (!this.goldskyApi) {
      throw new Error('No API found');
    }
    if (!this.walletAddress) {
      throw new Error('No wallet address found');
    }
  }

  // Method to fetch user's NFT
  async fetchUserNFT() {
    try {

      const transfers = await this.fetchUserTransfers();
      if (!transfers) {
        return [];
      }

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

  // Method to fetch user transfers
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

  // Private method to build the GraphQL query
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
