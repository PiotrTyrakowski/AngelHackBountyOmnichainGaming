
# NFT Library

This is an NFT library built using JavaScript, Webpack, and Ethers.js. It includes utilities for fetching NFT metadata, handling wallet connections, and interacting with smart contracts. The project is configured with Webpack for easy bundling and includes several test HTML files for interacting with the library.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Scripts](#scripts)
- [Tests](#tests)
- [Contributing](#contributing)
- [License](#license)

## Installation

To get started with the project, install the dependencies:

```bash
cd nft_library
npm install
```

## Usage

### Building the Project

To build the project for production, run:

```bash
npm run build
```

This will bundle the JavaScript files and output them to the `dist` directory.

### Starting the Development Server

To start the development server, which automatically rebuilds your code and reloads the browser on changes, run:

```bash
npm start
```

The server will be available at `http://localhost:8080` by default.

### Running in Watch Mode

To run Webpack in watch mode, use:

```bash
npm run watch
```

This will watch for file changes and automatically rebuild the project.

## Tests

There are several HTML files provided to test different functionalities of the library:

- `test1.html`: Test wallet connection and display the connected wallet address.
- `test2.html`: Fetch and display the user's NFTs using the `NftUtils` class.
- `test3.html`: Fetch and display NFT metadata using the `NftMetadataFetcher` class.
- `test4.html`: Complete a swap using `NftSwapper` and `SwapNft Smart Contract` - when using it, keep in mind that doing it from the web requires a carefull setup, and that
disconnecting from account has to be done each time manually (since the web client can' complete actions in the wallet in your stead), so every time it tells you that it "disconnected"
it mearly cleared the account variable, and you still have to disconnect manually at each step of the swap, here is an address of an account that has completed a transaction
- `test5.html`: Test out the wrapper for goldsky api `NftSwapsFetcher.js`, here is an account that has a completed swap: `0x0829a8908AC3D2a225FCF01be9f9178D0aaebA21`

To use these tests:

1. Build the project using `npm run build`.
2. Start the development server using `npm start`.
3. Open the test files in your browser, e.g., `http://localhost:8080/test1.html`.

## Settings

To configure the NFT Library, you can use the `Settings.js` file.

To populate the `Settings.js` file with the desired content, you can refer to the `Contracts.md` file, it provides values for the contracts we use and configured.
By default it is set up to use our own Smart Contracts
