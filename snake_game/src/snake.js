// snake.js
import { getScore, setScore, updateScore } from './game.js';
import { food, generateFood } from "./food.js";
import { ctx, gridSize, tileCount } from './setup.js';

let snake = [{ x: 200, y: 200 }];
let direction = null; // Use a private variable to manage direction
let snakeColor = '#666666';

export function getDirection() {
    return direction;
}

export function setDirection(newDirection) {
    direction = newDirection;
}

export function moveSnake() {
    const head = { x: snake[0].x, y: snake[0].y };

    switch (direction) {
        case 'up': head.y -= gridSize; break;
        case 'down': head.y += gridSize; break;
        case 'left': head.x -= gridSize; break;
        case 'right': head.x += gridSize; break;
    }

    snake.unshift(head);

    if (head.x === food.x && head.y === food.y) {
        setScore(getScore() + 1);
        updateScore();
        generateFood();
    } else {
        snake.pop();
    }
}

export function drawSnake() {
    snake.forEach((segment, index) => {
        ctx.fillStyle = index === 0 ? darkenColor(snakeColor, 20) : snakeColor;
        ctx.fillRect(segment.x, segment.y, gridSize - 2, gridSize - 2);
    });
}

export function setSnakeColor(color) {
    snakeColor = color;
}

function darkenColor(color, percent) {
    const num = parseInt(color.slice(1), 16);
    const amt = Math.round(2.55 * percent);
    const R = (num >> 16) - amt;
    const G = (num >> 8 & 0x00FF) - amt;
    const B = (num & 0x0000FF) - amt;
    return `#${(1 << 24 | (R < 255 ? R < 1 ? 0 : R : 255) << 16 | (G < 255 ? G < 1 ? 0 : G : 255) << 8 | (B < 255 ? B < 1 ? 0 : B : 255)).toString(16).slice(1)}`;
}

export { snake };
