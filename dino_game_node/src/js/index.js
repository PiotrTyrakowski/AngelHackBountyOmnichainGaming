import '../css/style.css';
import { initializeElements, startGame, resetGame, jump, changeSkin } from './script.js';
import './wallet.js';


document.addEventListener('DOMContentLoaded', () => {
  initializeElements();

  const startButton = document.getElementById("startButton");
  const skins = document.getElementById("skins");

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

  // Initialize game
  resetGame();
});