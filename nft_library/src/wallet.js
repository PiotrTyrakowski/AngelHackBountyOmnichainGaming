// wallet.js
let account_public_key = null;

export function getAccountPublicKey() {
    return account_public_key;
}

export async function connectWallet(updateButtonText) {
    // Check if MetaMask or other Ethereum provider is installed
    if (typeof window.ethereum !== 'undefined') {
        try {
            // Request account access
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            account_public_key = accounts[0];

            updateButtonText('Connected');

            alert(`Connected to account: ${account_public_key}`);

        } catch (error) {
            console.error('Connection request was rejected or there was an error', error);
            alert('Failed to connect. Please try again.');
        }
    } else {
        alert('MetaMask is not installed. Please install MetaMask and try again.');
    }
}