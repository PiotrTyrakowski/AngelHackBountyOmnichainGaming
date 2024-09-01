let connectWalletBtn;

export function initializeWallet() {
  connectWalletBtn = document.getElementById('connectWalletBtn');
  if (connectWalletBtn) {
    updateButtonText(false);
  }
}

function updateButtonText(isConnected) {
  if (connectWalletBtn) {
    connectWalletBtn.textContent = isConnected ? 'Connected' : 'Connect Your Wallet';
  }
}

export async function connectWallet() {
  console.log('connectWalletBtn clicked');
  if (typeof window.ethereum !== 'undefined') {
    try {
      console.log('trying to connect');
      const accounts = await window.ethereum.request({
        method: 'eth_requestAccounts'
      });
      const account = accounts[0];
      alert(`Connected to account: ${account}`);
      updateButtonText(true);
    } catch (error) {
      console.error('User rejected the request or there was an error', error);
    }
  } else {
    alert('MetaMask is not installed. Please install MetaMask and try again.');
  }
}