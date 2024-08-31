const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');
const scoreSpan = document.getElementById('score');

let score = 0;

const gridSize = 20;
const tileCount = canvas.width / gridSize;

function drawGame() {
    clearCanvas();
    moveSnake();
    drawFood();
    drawSnake();
    checkCollision();
    updateScore();
}

function clearCanvas() {
    ctx.fillStyle = 'white';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
}

function checkCollision() {
    const head = snake[0];

    if (head.x < 0 || head.x >= canvas.width || head.y < 0 || head.y >= canvas.height) {
        resetGame();
    }

    for (let i = 1; i < snake.length; i++) {
        if (head.x === snake[i].x && head.y === snake[i].y) {
            resetGame();
        }
    }
}

function resetGame() {
    snake = [{x: 200, y: 200}];
    direction = 'right';
    score = 0;
    generateFood();
}

function updateScore() {
    scoreSpan.textContent = `Score: ${score}`;
}

setInterval(drawGame, 100);
