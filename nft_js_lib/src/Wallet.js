class Wallet {
    constructor() {
        if (Wallet.instance) {
            return Wallet.instance;
        }

        this._state = {
            walletAddress: null, // Store address in a mutable object
        };
        Wallet.instance = this;
    }

    getWalletAddress() {
        return this._state.walletAddress;
    }

    setWalletAddress(address) {
        this._state.walletAddress = address;
    }

    async connectWallet(updateButtonText) {
        // Check if MetaMask or another Ethereum provider is installed
        if (typeof window.ethereum !== 'undefined') {
            try {
                // Request account access
                const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
                this.setWalletAddress(accounts[0]);

                if (updateButtonText && typeof updateButtonText === 'function') {
                    updateButtonText('Connected');
                }

                alert(`Connected to account: ${this.getWalletAddress()}`);
                return true;
            } catch (error) {
                console.error('Connection request was rejected or there was an error', error);
                alert('Failed to connect. Please try again.');
                return false;
            }
        } else {
            alert('MetaMask is not installed. Please install MetaMask and try again.');
        }
    }

    disconnectWallet(updateButtonText) {
        this.setWalletAddress(null);

        if (updateButtonText && typeof updateButtonText === 'function') {
            updateButtonText('Connect Wallet');
        }

        alert('Disconnected from wallet.');
    }
}

// Export the singleton instance
const walletInstance = new Wallet();
Object.freeze(walletInstance);

export default walletInstance;
export { Wallet };
