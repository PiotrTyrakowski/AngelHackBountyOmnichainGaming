// index.js
import './setup.js';    // Sets up canvas and context
import './game.js';     // Initializes and runs the game logic
import './snake.js';    // Handles snake operations
import './food.js';     // Manages food generation and rendering
import './controls.js'; // Deals with user input for game controls and skin selection
import './wallet_connect.js'; // Connects to MetaMask wallet

// Libs for NFT integration
import './lib_nft/wallet.js'; // Allows wallet connection
import './lib_nft/fetch_user_nft.js'; // Fetches user NFTs
import './lib_nft/get_nft_metadata.js'; // Fetches NFT metadata
import './lib_nft/settings.js'; // Contains network and contract address