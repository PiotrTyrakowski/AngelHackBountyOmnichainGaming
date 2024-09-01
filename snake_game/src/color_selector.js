import { setSnakeColor } from './snake.js';
import { getAvailableSkins } from './get_skins.js';

export async function updateSkinSelector() {
    const skins = [
        { id: 1, name: "Red" },
        { id: 2, name: "Blue" }
    ]

    const colorMap = {
        1: "#FF0000",
        2: "#0000FF"
    }

    const skinSelector = document.getElementById('skinSelector');

    skins.forEach(skin => {
        console.log(skin);
    });


    let availableSkins = await getAvailableSkins();
    skinSelector.innerHTML = "";

    availableSkins.forEach(skin => {
        console.log(skin);
        const option = document.createElement('option');

        option.value = colorMap[skin.id];
        option.text = skin.name; 
        skinSelector.add(option);
    });
}

