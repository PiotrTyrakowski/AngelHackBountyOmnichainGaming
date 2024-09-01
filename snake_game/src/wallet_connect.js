import { connectWallet } from "./lib_nft/wallet";
import { updateSkinSelector } from "./color_selector";

const connectWalletBtn = document.getElementById('connectWalletBtn');

function updateButtonText(text) {
    connectWalletBtn.textContent = text;
}

async function connectWalletWrapper() {
    await connectWallet(updateButtonText);
    updateSkinSelector();
}

connectWalletBtn.addEventListener('click', connectWalletWrapper);

updateButtonText('Connect Your Wallet');