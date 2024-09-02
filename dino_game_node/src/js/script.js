import { getAvailableSkins } from "./get_skins";

let character, block, scoreSpan, startButton, skins;
let counter = 0;
let gameStarted = false;
let checkDead;

// Map to store skin options (example: skin name -> color)
let skinMap = new Map();

export function initializeElements() {
  character = document.getElementById("mySvg");
  block = document.getElementById("block");
  scoreSpan = document.getElementById("scoreSpan");
  startButton = document.getElementById("startButton");
  skins = document.getElementById("skins");

    // Initialize the skin map with some default values
    skinMap.set("Default", "#000000");          // Black
    skinMap.set("Blue Gaming Skin", "#0000FF"); // Blue
    skinMap.set("Red Gaming Skin", "#FF0000");  // Red
    skinMap.set("Green Skin", "#00FF00");       // Green
    skinMap.set("Orange Skin", "#FFA500");      // Orange
    skinMap.set("Pink Skin", "#FFC0CB");        // Pink
    skinMap.set("Purple Skin", "#800080");      // Purple
    skinMap.set("Yellow Skin", "#FFFF00");      // Yellow
}

export function startGame() {
  if (!character || !block || !scoreSpan || !startButton) {
    console.error("Game elements not initialized");
    return;
  }
  
  if (gameStarted) return;

  gameStarted = true;
  counter = 0;
  block.style.animation = "block 1s infinite linear";
  startButton.style.display = "none";

  checkDead = setInterval(function() {
    let characterTop = parseInt(window.getComputedStyle(character).getPropertyValue("top"));
    let blockLeft = parseInt(window.getComputedStyle(block).getPropertyValue("left"));

    if (blockLeft < 60 && blockLeft > 20 && characterTop >= 60) {
      block.style.animation = "none";
      alert("Game Over. Score: " + Math.floor(counter / 100));
      resetGame();
    } else {
      counter++;
      scoreSpan.innerHTML = Math.floor(counter / 100);
    }
  }, 10);
}

export function resetGame() {
  if (!block || !scoreSpan || !startButton) {
    console.error("Game elements not initialized");
    return;
  }

  clearInterval(checkDead);
  gameStarted = false;
  block.style.animation = "none";
  scoreSpan.innerHTML = "0";
  startButton.style.display = "inline";
}

export function jump() {
  if (!character || !gameStarted || character.classList.contains("animate")) return;
  character.classList.add("animate");
  setTimeout(function() {
    character.classList.remove("animate");
  }, 300);
}

export async function changeSkin() {
  if (!character || !skins) {
    console.error("Character or skins not initialized");
    return;
  }
  var selectedSkin = skins.value;
  let skinColor = skinMap.get(selectedSkin) || skinMap.get("Default");
  character.querySelector('g').setAttribute('fill', skinColor);
}