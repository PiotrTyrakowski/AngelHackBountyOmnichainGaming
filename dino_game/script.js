var character = document.getElementById("character");
var block = document.getElementById("block");
var scoreSpan = document.getElementById("scoreSpan");
var startButton = document.getElementById("startButton");
var skins = document.getElementById("skins");
var counter = 0;
var gameStarted = false;
var checkDead;

// Function to start the game
function startGame() {
    if (gameStarted) return;  // Prevent restarting the game

    // Initialize game state
    gameStarted = true;
    counter = 0;
    block.style.animation = "block 1s infinite linear";  // Start block animation
    startButton.style.display = "none";  // Hide the start button when the game starts

    // Check for collision and update score
    checkDead = setInterval(function() {
        let characterTop = parseInt(window.getComputedStyle(character).getPropertyValue("top"));
        let blockLeft = parseInt(window.getComputedStyle(block).getPropertyValue("left"));

        if (blockLeft < 20 && blockLeft > -20 && characterTop >= 130) {
            block.style.animation = "none";
            alert("Game Over. Score: " + Math.floor(counter / 100));
            resetGame();
        } else {
            counter++;
            scoreSpan.innerHTML = Math.floor(counter / 100);
        }
    }, 10);
}

// Function to reset the game after Game Over
function resetGame() {
    clearInterval(checkDead);  // Stop the collision checking
    gameStarted = false;
    block.style.animation = "none";  // Stop the block animation
    scoreSpan.innerHTML = "0";
    startButton.style.display = "inline";  // Show the start button again
}

// Jump function definition
function jump() {
    if (!gameStarted || character.classList.contains("animate")) return;  // Only jump if the game is running
    character.classList.add("animate");
    setTimeout(function() {
        character.classList.remove("animate");
    }, 300);
}

// Event listener for spacebar key press
document.addEventListener('keydown', function(event) {
    if (event.code === 'Space') {
        jump();
    }
});

// Event listener for start button
startButton.addEventListener('click', startGame);

// Function to change the character's skin
function changeSkin() {
    var selectedSkin = skins.value;
    character.style.backgroundColor = selectedSkin;
}

// Initial game state setup (when the page loads)
resetGame();
