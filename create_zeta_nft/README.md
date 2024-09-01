# Sample Hardhat Project

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.ts
```
set up .env: (example .env)
```shell
API_URL="https://zetachain-athens-evm.blockpi.network/v1/rpc/public"
PRIVATE_KEY="your private key"
```

deploy the contract:
```shell
npx hardhat run scripts/{file}.js --network zetachain
```
deploy_nft - script that creates nft minter for zetachain

mint_nft - script that mints nft

get_nft_metadata - script for getting metadata for nft

deploy_swap_nft - scirpt that create swapping functionality for zetachain

make_swap - script that makes swap.

# make_swap
how do you call?

