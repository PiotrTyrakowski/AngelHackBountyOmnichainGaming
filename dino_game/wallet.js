
const connectWalletBtn = document.getElementById('connectWalletBtn');

function updateButtonText(isConnected) {
    connectWalletBtn.textContent = isConnected ? 'Connected' : 'Connect Your Wallet';
}

connectWalletBtn.addEventListener('click', async function() {
    console.log('connectWalletBtn clicked');  
    // Check if MetaMask is installed
    if (typeof window.ethereum !== 'undefined') {
        try {
            // Request account access if needed
            console.log('trying to connect');  
            const accounts = await window.ethereum.request({ 
                method: 'eth_requestAccounts' 
            });
            const account = accounts[0];
            alert(`Connected to account: ${account}`);
            // Update button text to 'Connected'
            updateButtonText(true);
        } catch (error) {
            console.error('User rejected the request or there was an error', error);
        }
    } else {
        alert('MetaMask is not installed. Please install MetaMask and try again.');
    }
});

// Initial button text
updateButtonText(false);