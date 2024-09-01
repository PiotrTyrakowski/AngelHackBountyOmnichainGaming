# Zetachain NFT

## Setup
1. Run yarn to install all dependencies
```shell
yarn
```

If you don't have yarn install it with
```shell
npm install --global yarn
```
2. Create the .env file with your API_URL and PRIVATE_KEY

Referencing the .env.example file, create a .env file in the root directory of the project

3. Compile the contracts
```shell
npx hardhat compile
```

4. Deploy the contract:
```shell
npx hardhat run scripts/deploy_nft.js --network zetachain
```


## Other scripts

### Descriptions
deploy_nft - script that creates nft minter for zetachain

mint_nft - script that mints nft

get_nft_metadata - script for getting metadata for nft

deploy_swap_nft - scirpt that create swapping functionality for zetachain

make_swap - script that makes swap.

### Run
```shell
npx hardhat run scripts/{file}.js --network zetachain
```

## Deploy goldsky
### Install goldsky
```shell
curl https://goldsky.com | sh
```
### Login
This will require a goldsky account, and it's **API** key
```shell
goldsky login
```
### Deploy
```shell
goldsky subgraph deploy swap/v1 --from-abi goldsky.json
```
This should deploy the subgraph and return the url