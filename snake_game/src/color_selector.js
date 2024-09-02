import { setSnakeColor } from './snake.js';
import { getAvailableSkins } from './get_skins.js';

export async function updateSkinSelector() {

    const colorMap = {
        1: "#C92626", //red
        2: "#3030E3", //blue
        3: "#29AB29", //green
        4: "#FFCC00", //yellow
        5: "#4C00B0", //purple
        6: "#E65B05", //orange
        7: "#BE2ED6", //pink
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

