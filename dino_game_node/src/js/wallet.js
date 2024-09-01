import { connectWallet } from "./lib_nft/wallet";
import { getAvailableSkins } from "./get_skins";

const connectWalletBtn = document.getElementById('connectWalletBtn');

function updateButtonText(text) {
    connectWalletBtn.textContent = text;
}

async function connectWalletWrapper() {
    await connectWallet(updateButtonText);
    const skins = document.getElementById("skins");
    
    let skinsArray = await getAvailableSkins();

    const skinNameArray = skinsArray.map(jsonString => {
        const jsonObject = JSON.parse(jsonString);
        return jsonObject.name;
    });

    console.log(skinNameArray);
    
    skinNameArray.forEach(str => {
        const option = document.createElement('option');
        option.value = str;  // Set the value of the option
        option.textContent = str; // Set the visible text of the option
        skins.appendChild(option); // Add the option to the select element
    });
}

connectWalletBtn.addEventListener('click', connectWalletWrapper);

updateButtonText('Connect Your Wallet');