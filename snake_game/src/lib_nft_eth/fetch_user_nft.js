import { goldskyApi } from "./settings"
import { getAccountPublicKey } from "./wallet"
import { request, gql } from 'graphql-request'

const query = (address) => {
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
    `
}

async function fetchUserTransfers() {
  const accountPublicKey = getAccountPublicKey();
  if (!accountPublicKey) {
    console.error('No account found');
    return;
  }

  const response = await request(
    goldskyApi,
    query(accountPublicKey)
  );

  const transfers = response.transfers;
  console.log('Transfers:', response);
  return transfers;
}

export async function fetchUserNFT() {
  const transfers = await fetchUserTransfers();
  if (!transfers) {
    console.error('Failed to fetch transfers');
    return;
  }

  transfers.sort(
    (a, b) => parseInt(a.block_number) - parseInt(b.block_number)
  );

  let currentOwnership = {};
  const walletAddress = getAccountPublicKey();

  transfers.forEach(transfer => {
    if (transfer.to.toLowerCase() === walletAddress.toLowerCase()) {
      currentOwnership[transfer.tokenId] = true;
    } else if (transfer.from.toLowerCase() === walletAddress.toLowerCase()) {
      currentOwnership[transfer.tokenId] = false;
    }
  });

  const ownedTokens = Object.keys(currentOwnership).filter(id => currentOwnership[id]);
  console.log('Owned Tokens:', ownedTokens);
  return ownedTokens;
}
