# Zetachain NFT Setup Guide

## Setup

### 1. Install Dependencies
To install all necessary dependencies, run the following command:

```bash
yarn
```

> **Note:** If you don't have `yarn` installed, you can install it globally using the following command:

```bash
npm install --global yarn
```

### 2. Create the `.env` File
Create a `.env` file in the root directory of the project using the provided `.env.example` as a reference. Populate the `.env` file with your `API_URL` and `PRIVATE_KEY` values.

### 3. Compile the Contracts
Compile the smart contracts by running:

```bash
npx hardhat compile
```

### 4. Deploy All Contracts
Here are the possible script names that deploy contracts:

- `deploy_first_gaming_nft`
- `deploy_second_gaming_nft`
- `deploy_swap_nft`

Use the following commands to deploy the contracts. Replace `[script_name]` with the appropriate script name.

```bash
npx hardhat run scripts/[script_name].js --network zetachain
```



## Scripts

### Descriptions
- **deploy_first_gaming_nft**: Deploys the first of two gaming NFT contracts.
- **deploy_second_gaming_nft**: Deploys the second of two gaming NFT contracts.
- **deploy_swap_nft**: Deploys the contract responsible for swapping NFTs.
- **get_nft_metadata.js**: Queries the metadata of token with ID 1 on the first gaming contract (for testing).
- **mint_nft.js**: Takes in the `contractAddress` of the NFT contract, and the `metadataPath`, and mints an NFT on the provided contract with the provided contents of the `.json` file pointed to by `metadataPath`.
- **mint_nft_batch.js**: Mints `x` NFTs per NFT metadata on both NFT contracts (in total `x * metadata_count * 2`) where `x` is the script's argument.

### Run
To run any of the scripts, use the following command:

```bash
npx hardhat run scripts/{file}.js --network zetachain
```

## Deploy Goldsky

### Install Goldsky
To install Goldsky, run the following command:

```bash
curl https://goldsky.com | sh
```

### Login
Login to Goldsky using your account and **API** key:

```bash
goldsky login
```

### Deploy
Deploy the subgraph using:

```bash
goldsky subgraph deploy swap/v1 --from-abi goldsky.json
```

This should deploy the subgraph and return the URL.
