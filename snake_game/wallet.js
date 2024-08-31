// Get the button element
const connectWalletBtn = document.getElementById('connectWalletBtn');

// Function to update button text
function updateButtonText(isConnected) {
    connectWalletBtn.textContent = isConnected ? 'Connected' : 'Connect Your Wallet';
}

// Add event listener to the button
connectWalletBtn.addEventListener('click', async function() {
    // Check if MetaMask is installed
    if (typeof window.ethereum !== 'undefined') {
        try {
            // Request account access if needed
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




