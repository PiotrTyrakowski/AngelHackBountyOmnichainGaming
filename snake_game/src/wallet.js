// wallet.js
import getNFTMetadata from "./get_nft_metadata.js";
import {network, contractAddress} from "./settings";

const connectWalletBtn = document.getElementById('connectWalletBtn');

async function connectWallet() {
    // Check if MetaMask or other Ethereum provider is installed
    if (typeof window.ethereum !== 'undefined') {
        try {
            // Request account access
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            const account = accounts[0];
            updateButtonText('Connected');
            alert(`Connected to account: ${account}`);
            getNFTMetadata(1, network, contractAddress);

        } catch (error) {
            console.error('Connection request was rejected or there was an error', error);
            alert('Failed to connect. Please try again.');
        }
    } else {
        alert('MetaMask is not installed. Please install MetaMask and try again.');
    }
}

function updateButtonText(text) {
    connectWalletBtn.textContent = text;
}

connectWalletBtn.addEventListener('click', connectWallet);

updateButtonText('Connect Your Wallet');
