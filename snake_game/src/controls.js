// controls.js
import { getDirection, setDirection, setRainbowSkin, setSnakeColor} from './snake.js';

const skinSelector = document.getElementById('skinSelector');

document.addEventListener('keydown', (e) => {
    let currentDirection = getDirection();
    switch(e.key) {
        case 'ArrowUp': if (currentDirection !== 'down') setDirection('up'); break;
        case 'ArrowDown': if (currentDirection !== 'up') setDirection('down'); break;
        case 'ArrowLeft': if (currentDirection !== 'right') setDirection('left'); break;
        case 'ArrowRight': if (currentDirection !== 'left') setDirection('right'); break;
    }
});


skinSelector.addEventListener('change', (e) => {
    if (e.target.value === 'rainbow') {
        setRainbowSkin(true);
    } else {
        setRainbowSkin(false);
        setSnakeColor(e.target.value);
    }
});
``
