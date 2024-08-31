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
API_URL="https://rpc2.sepolia.org"
PRIVATE_KEY=dajsfhreie123r429rfeig8sdfb4lwer4033u02941kjlljewflkqsifpqwoe234
```

deploy the contract:
```shell
npx hardhat run scripts/deploy.js --network sepolia
```

mint-nft:
```shell
node scripts/mint-nft.js
```
