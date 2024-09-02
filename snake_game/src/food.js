// food.js
import { ctx, gridSize, tileCount } from './setup.js';

let food = {};

export function generateFood() {
    food = {
        x: Math.floor(Math.random() * tileCount) * gridSize,
        y: Math.floor(Math.random() * tileCount) * gridSize
    };
}

export function drawFood() {
    ctx.fillStyle = 'red';
    ctx.fillRect(food.x, food.y, gridSize - 2, gridSize - 2);
}

generateFood(); // Generate initial food position

export { food };
