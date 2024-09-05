import { ethers } from "ethers";

/**
Singleton class that stores the settings for the NFT contracts.
 */
class Settings {
    constructor() {
        if (Settings.instance) {
            return Settings.instance;
        }

        this.contracts = {};
        this.contractsByAddress = {};
        Settings.instance = this;
    }

    /**
     * Adds contract settings for a specific contract.
     * @param {string} contractName - The name of the contract.
     * @param {ethers.Network} network - The network of the contract.
     * @param {string} contractAddress - The address of the contract.
     * @param {string} goldskyApi - The Goldsky API for the contract.
     */
    addContractSettings(contractName, network, contractAddress, goldskyApi) {
        if (this.contractsByAddress[contractAddress]) {
            console.error(`Contract address ${contractAddress} already exists`);
            return;
        }

        contractAddress = contractAddress.toLowerCase();
        this.contracts[contractName] = new ContractSettings(network, contractAddress, goldskyApi);
        this.contractsByAddress[contractAddress] = this.contracts[contractName];
    }

    /**
     * Retrieves the contract settings for a specific contract.
     * @param {string} contractName - The name of the contract.
     * @returns {ContractSettings} The contract settings.
     */
    getContractSettings(contractName) {
        return this.contracts[contractName];
    }

    getContractSettingsByAddress(contractAddress) {
        return this.contractsByAddress[contractAddress];
    }
}

/**
 * Represents the settings for a specific contract.
 */
class ContractSettings {
    /**
     * @param {ethers.Network} network 
     * @param {string} contractAddress 
     * @param {string} goldskyApi 
     */
    constructor(network, contractAddress, goldskyApi) {
        if (!(network instanceof ethers.Network)) {
            console.error("Invalid network provided");
            console.error(new Error().stack);
            return;
        }
        if (typeof contractAddress !== "string") {
            console.error("Invalid contract address provided");
            console.error(new Error().stack);
            return;
        }
        if (typeof goldskyApi !== "string") {
            console.error("Invalid Goldsky API provided");
            console.error(new Error().stack);
            return
        }

        this.network = network;
        this.contractAddress = contractAddress.toLowerCase();
        this.goldskyApi = goldskyApi;
    }

    /**
     * @returns {ethers.Network}
     */
    getNetwork() {
        return this.network;
    }

    /**
     * @returns {string}
     * */
    getContractAddress() {
        return this.contractAddress;
    }

    /**
     * @returns {string}
     * */
    getGoldskyApi() {
        return this.goldskyApi;
    }
}

const settingsInstance = new Settings();
Object.freeze(settingsInstance); // Prevent modification of the instance

export default settingsInstance;
export { settingsInstance, ContractSettings };

settingsInstance.addContractSettings(
    'GamingNftZetachain1',
    new ethers.Network("https://zeta-chain-testnet.drpc.org", 7001),
    '0x2f1b7b418A51A62685c0E7617ca6c0C5551106e6',
    'https://api.goldsky.com/api/public/project_cm0jlloqy8ay901vt86y56f0t/subgraphs/nft-1-zetachain-testnet/v1/gn'
);

settingsInstance.addContractSettings(
    'GamingNftZetachain2',
    new ethers.Network("https://zeta-chain-testnet.drpc.org", 7001),
    '0xB5E0066AAd80b5f1fdDAcA49e928e95d636FC0FF',
    'https://api.goldsky.com/api/public/project_cm0jlloqy8ay901vt86y56f0t/subgraphs/nft-2-zetachain-testnet/v1/gn'
);

settingsInstance.addContractSettings(
    'GamingNftSepolia',
    new ethers.Network("wss://ethereum-sepolia-rpc.publicnode.com", 11155111),
    '0x6479A92F15CC8558c823eaCd1013b047DA90BA8f',
    'https://api.goldsky.com/api/public/project_cm0jlloqy8ay901vt86y56f0t/subgraphs/nft-sepolia/v1/gn'
);

settingsInstance.addContractSettings(
    'SwapperNftZetachain',
    new ethers.Network("https://zeta-chain-testnet.drpc.org", 7001),
    '0xe9c75c3b48BD57F63886322F0ca1C5b04937791a',
    'https://api.goldsky.com/api/public/project_cm0l8yvile64b01wo51lfdaga/subgraphs/nft-swapper-2-zetachain-testnet/v1/gn'
);
