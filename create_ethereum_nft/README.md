
# Create Ethereum NFT Contract

## Setup

### 1. Install Dependencies
To install all necessary dependencies, run the following command:

```bash
npm install
```

### 2. Set Up Hardhat
Install and initialize Hardhat by running the following commands:

```bash
npm install --save-dev hardhat
npx hardhat
```

For more information about Hardhat, you can run:

```bash
npx hardhat help
```

### 3. Create the `.env` File
Create a `.env` file in the root directory of the project. Populate the `.env` file with your `API_URL` and `PRIVATE_KEY` values.

Example:

```bash
API_URL="https://rpc2.sepolia.org"
PRIVATE_KEY="dajsfhreie123r429rfeig8sdfb4lwer4033u02941kjlljewflkqsifpqwoe234"
```

- **API_URL**: The RPC endpoint URL of the chain you want to deploy the contract on.
- **PRIVATE_KEY**: Your wallet's private key.

## Deploy the Contract

Deploy the smart contract by running the following command:

```bash
npx hardhat run scripts/deploy.js --network sepolia
```

This command will automatically add an entry to the `.env` file with the address of the contract and copy the contract ABI into the `contract_abi` folder.

## Mint NFT

Ensure that the `.env` file contains the contract address as `GAMING_NFT_ADDRESS=[example address]` and that the `contract_abi` folder contains a file named `GamingNFT.json`.

To mint an NFT, run the following command:

```bash
node scripts/mint_nft.js
```

## Get NFT Metadata

To retrieve the metadata of an NFT, ensure that the `.env` file contains the contract address as `GAMING_NFT_ADDRESS=[example address]` and that the `contract_abi` folder contains a file named `GamingNFT.json`.

Run the following command to get the NFT metadata:

```bash
node scripts/get_nft_metadata.js
```

## Deploy Goldsky

### Install Goldsky
To install Goldsky, run the following command:

```bash
curl https://goldsky.com | sh
```

### Login
Log in to Goldsky using your account and **API** key:

```bash
goldsky login
```

### Deploy
Deploy the subgraph using the following command:

```bash
goldsky subgraph deploy swap/v1 --from-abi goldsky.json
```

This should deploy the subgraph and return the URL.
