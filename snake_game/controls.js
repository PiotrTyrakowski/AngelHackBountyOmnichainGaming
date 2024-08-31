const skinSelector = document.getElementById('skinSelector');

document.addEventListener('keydown', (e) => {
    switch(e.key) {
        case 'ArrowUp': if (direction !== 'down') direction = 'up'; break;
        case 'ArrowDown': if (direction !== 'up') direction = 'down'; break;
        case 'ArrowLeft': if (direction !== 'right') direction = 'left'; break;
        case 'ArrowRight': if (direction !== 'left') direction = 'right'; break;
    }
});

skinSelector.addEventListener('change', (e) => {
    if (e.target.value === 'rainbow') {
        isRainbowSkin = true;
    } else {
        isRainbowSkin = false;
        snakeColor = e.target.value;
    }
});
