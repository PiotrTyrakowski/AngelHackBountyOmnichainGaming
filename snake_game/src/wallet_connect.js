import { connectWallet } from "./lib_nft_eth/wallet";

const connectWalletBtn = document.getElementById('connectWalletBtn');

function updateButtonText(text) {
    connectWalletBtn.textContent = text;
}

async function connectWalletWrapper() {
    await connectWallet(updateButtonText);
}

connectWalletBtn.addEventListener('click', connectWalletWrapper);

updateButtonText('Connect Your Wallet');