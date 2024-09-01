import '../css/style.css';
import { initializeElements, startGame, resetGame, jump, changeSkin } from './script.js';
import { initializeWallet, connectWallet } from './wallet.js';
import guyImage from '../images/guy.svg';  // Import the image

document.addEventListener('DOMContentLoaded', () => {
  initializeElements();
  initializeWallet();

  const startButton = document.getElementById("startButton");
  const skins = document.getElementById("skins");
  const connectWalletBtn = document.getElementById('connectWalletBtn');
  const character = document.getElementById('character');

  // Event listeners
  document.addEventListener('keydown', (event) => {
    if (event.code === 'Space') {
      jump();
    }
  });

  if (startButton) {
    startButton.addEventListener('click', startGame);
  }

  if (skins) {
    skins.addEventListener('change', changeSkin);
  }

  if (connectWalletBtn) {
    connectWalletBtn.addEventListener('click', connectWallet);
  }

  // Initialize game
  resetGame();
});