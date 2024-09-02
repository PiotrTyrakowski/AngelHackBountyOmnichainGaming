// src/index.js
import walletInstance from './Wallet.js';
import settingsInstance from './Settings.js';
import NftUtils from './NftUtils.js';
import NftMetadataFetcher from './NftMetadataFetcher.js';

// Expose walletInstance to the global scope
window.walletInstance = walletInstance;
window.settingsInstance = settingsInstance;
window.NftUtils = NftUtils;
window.NftMetadataFetcher = NftMetadataFetcher;
