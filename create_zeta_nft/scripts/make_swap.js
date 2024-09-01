require('dotenv').config();
const ethers = require('ethers');

// ABI of the swapNFT contract
const swapNFTABI = [
  "function initiateSwap(address _counterparty, address _nftContractA, uint256 _tokenIdA, address _nftContractB, uint256 _tokenIdB) external",
  "function completeSwap(uint256 _swapId) external",
  "function cancelSwap(uint256 _swapId) external",
  "function swapCounter() public view returns (uint256)"
];

// ABI of a standard ERC721 contract
const erc721ABI = [
  "function approve(address to, uint256 tokenId) public",
  "function setApprovalForAll(address operator, bool approved) public"
];

const provider = new ethers.providers.JsonRpcProvider(process.env.API_URL);
const privateKey = process.env.PRIVATE_KEY;
const signer = new ethers.Wallet(privateKey, provider);

const swapNFTAddress = process.env.SWAP_NFT_ADDRESS
const swapNFTContract = new ethers.Contract(swapNFTAddress, swapNFTABI, signer);

async function approveNFT(nftContractAddress, tokenId) {
  const nftContract = new ethers.Contract(nftContractAddress, erc721ABI, signer);
  const approveTx = await nftContract.approve(swapNFTAddress, tokenId);
  await approveTx.wait();
  console.log(`Approved NFT ${tokenId} for swapping`);
}

async function initiateSwap(counterparty, nftContractA, tokenIdA, nftContractB, tokenIdB) {
  await approveNFT(nftContractA, tokenIdA);

  const initiateTx = await swapNFTContract.initiateSwap(
    counterparty,
    nftContractA,
    tokenIdA,
    nftContractB,
    tokenIdB
  );
  const receipt = await initiateTx.wait();
  console.log(`Swap initiated: ${receipt.transactionHash}`);
  
  const swapId = await swapNFTContract.swapCounter() - 1;
  console.log(`Swap ID: ${swapId}`);
  return swapId;
}

async function completeSwap(swapId, nftContractB, tokenIdB) {
  await approveNFT(nftContractB, tokenIdB);

  const completeTx = await swapNFTContract.completeSwap(swapId);
  const receipt = await completeTx.wait();
  console.log(`Swap completed: ${receipt.transactionHash}`);
}

async function cancelSwap(swapId) {
  const cancelTx = await swapNFTContract.cancelSwap(swapId);
  const receipt = await cancelTx.wait();
  console.log(`Swap cancelled: ${receipt.transactionHash}`);
}

// Example usage
async function main() {
  // Initiate a swap


  const counterparty = '0xEd8cEC29D464F86F4Ff274d615a7a2C6F23CefF7'; // Address of the other party public key
  const nftContractA = '0xB75027AA1084c8fb8AcD99f2859a30f54E74E8a7'; // Address of the first NFT contract
  const tokenIdA = 1; // ID of the first NFT
  const nftContractB = '0x34819B7a4B318D50Ff61941fb372D28cCFD27491'; // Address of the second NFT contract
  const tokenIdB = 2; // ID of the second NFT

  try {
    // Initiate a swap by first person
    //const swapId = await initiateSwap(counterparty, nftContractA, tokenIdA, nftContractB, tokenIdB);


    // To complete the swap (run this as the counterparty) (change conterparty to the first address)
    // await completeSwap(0, nftContractB, tokenIdB)

    // To cancel the swap (run this as the initiator)
    // await cancelSwap(swapId);
  } catch (error) {
    console.error('Error:', error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
