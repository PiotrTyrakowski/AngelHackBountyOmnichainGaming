# Create Ethereum NFT contract
1. Setup HardHat
```shell
npm install --save-dev hardhat
npx hardhat
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.ts
```
2. Setup npm
```shell
npm install
```

3. Create and set up a **.env**

example:
```shell
API_URL="https://rpc2.sepolia.org"
PRIVATE_KEY=dajsfhreie123r429rfeig8sdfb4lwer4033u02941kjlljewflkqsifpqwoe234
```
*API_URL* - Url rpc endpoint of the chain you want to deploy the contract on
*PRIVATE_KEY* - Your wallet private key

## Deploy the contract
```shell
npx hardhat run scripts/deploy.js --network sepolia
```
This command should automatically add an entry to **.env** with the address of the contract, and copy the contract ABI into [contract_abi](contract_abi) folder

## Mint NFT
Ensure that **.env** contains the address of the contract as "**GAMING_NFT_ADDRESS=[example address]**"

And that [contract_abi](contract_abi) contains a file called **GamingNFT.json**

```shell
node scripts/mint_nft.js
```

## Get NFT Metadata
Ensure that **.env** contains the address of the contract as "**GAMING_NFT_ADDRESS=[example address]**"

And that [contract_abi](contract_abi) contains a file called **GamingNFT.json**

```shell
node scripts/get_nft_metadata.js
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