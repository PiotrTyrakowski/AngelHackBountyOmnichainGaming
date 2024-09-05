// src/index.js
import walletInstance from './Wallet.js';
import { settingsInstance, ContractSettings } from './Settings.js';
import NftFetcher from './NftFetcher.js';
import NftMetadataFetcher from './NftMetadataFetcher.js';
import NftSwapper from './NftSwapper.js';
import NftSwapsFetcher from './NftSwapsFetcher.js';
import { assignCheckNull, validateAddress, validateSwapId, validateTokenId } from './Utils.js';

// Expose walletInstance to the global scope
window.walletInstance = walletInstance;
window.settingsInstance = settingsInstance;
window.NftFetcher = NftFetcher;
window.NftMetadataFetcher = NftMetadataFetcher;
window.NftSwapsFetcher = NftSwapsFetcher;
window.NftSwapper = NftSwapper;
window.assignCheckNull = assignCheckNull;
window.validateAddress = validateAddress;
window.validateSwapId = validateSwapId;
window.validateTokenId = validateTokenId;