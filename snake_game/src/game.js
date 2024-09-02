// game.js
import { ctx, canvas } from './setup.js'; // Import canvas and context setup
import { drawSnake, moveSnake, snake, setDirection } from './snake.js';
import { drawFood } from './food.js';

const scoreSpan = document.getElementById('score');

let score = 0;
export function getScore() {
    return score;
}
export function setScore(newScore) {
    score = newScore;
}

export function updateScore() {
    scoreSpan.textContent = score;
}

function drawGame() {
    clearCanvas();
    moveSnake();
    drawFood();
    drawSnake();
    checkCollision();
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
    snake.length = 0;
    snake.push({ x: 200, y: 200 });
    setDirection('right');
    score = 0;
    updateScore();
    import('./food.js').then(module => module.generateFood());
}

setInterval(drawGame, 100);
