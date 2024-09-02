import { ethers } from "ethers";

class Settings {
    constructor() {
        if (Settings.instance) {
            return Settings.instance;
        }

        this.contracts = {};
        Settings.instance = this;
    }

    // Define settings for a specific contract
    addContractSettings(contractName, network, contractAddress, goldskyApi) {
        this.contracts[contractName] = new ContractSettings(network, contractAddress, goldskyApi);
    }

    // Retrieve settings for a specific contract
    getContractSettings(contractName) {
        return this.contracts[contractName];
    }
}

class ContractSettings {
    constructor(network, contractAddress, goldskyApi) {
        this.network = network;
        this.contractAddress = contractAddress;
        this.goldskyApi = goldskyApi;
    }

    getNetwork() {
        return this.network;
    }

    getContractAddress() {
        return this.contractAddress;
    }

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
    'https://api.goldsky.com/api/public/project_cm0jlloqy8ay901vt86y56f0t/subgraphs/nft-2-zetachain-testnet/v1/g'
);

settingsInstance.addContractSettings(
    'GamingNftSepolia',
    new ethers.Network("https://mainnet.infura.io/v3/", 1),
    '0x6479A92F15CC8558c823eaCd1013b047DA90BA8f',
    'https://api.goldsky.com/api/public/project_cm0jlloqy8ay901vt86y56f0t/subgraphs/nft-sepolia/v1/gn'
);

settingsInstance.addContractSettings(
    'SwapperNftZetachain',
    new ethers.Network("https://zeta-chain-testnet.drpc.org", 7001),
    '0x68F47ba9878FE221954ecE8b2dB6BbbE05759374',
    'https://api.goldsky.com/api/public/project_cm0l8yvile64b01wo51lfdaga/subgraphs/nft-swapper-zetachain-testnet/v1/gn'
);
