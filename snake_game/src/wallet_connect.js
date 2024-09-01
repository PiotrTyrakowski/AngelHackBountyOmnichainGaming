import { connectWallet } from "./lib_nft/wallet";
import { getAvailableSkins } from "./get_skins";

const connectWalletBtn = document.getElementById('connectWalletBtn');

function updateButtonText(text) {
    connectWalletBtn.textContent = text;
}

async function connectWalletWrapper() {
    await connectWallet(updateButtonText);
    let skins = await getAvailableSkins();
    console.log(skins);
}

connectWalletBtn.addEventListener('click', connectWalletWrapper);

updateButtonText('Connect Your Wallet');