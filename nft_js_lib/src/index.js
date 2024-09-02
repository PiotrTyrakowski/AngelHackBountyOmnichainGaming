// src/index.js
import walletInstance from './Wallet.js';
import settingsInstance from './Settings.js';
import NftFetcher from './NftFetcher.js';
import NftMetadataFetcher from './NftMetadataFetcher.js';

// Expose walletInstance to the global scope
window.walletInstance = walletInstance;
window.settingsInstance = settingsInstance;
window.NftFetcher = NftFetcher;
window.NftMetadataFetcher = NftMetadataFetcher;
