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
    skinMap.set("default", "#000000");
    skinMap.set("green", "#00FF00");
    skinMap.set("blue", "#0000FF");
    skinMap.set("red", "#FF0000");
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
    console.log(characterTop, blockLeft);
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

export function changeSkin() {
  if (!character || !skins) {
    console.error("Character or skins not initialized");
    return;
  }
  var selectedSkin = skins.value;
  let skinColor = skinMap.get(selectedSkin) || skinMap.get("default");
  character.querySelector('g').setAttribute('fill', skinColor);
}