import walletInstance from "../../nft_js_lib/src/Wallet";
import NftFetcher from "../../nft_js_lib/src/NftFetcher";
import NftMetadataFetcher from "../../nft_js_lib/src/NftMetadataFetcher";
import settingsInstance from "../../nft_js_lib/src/Settings";

const connectWalletBtn = document.getElementById('connectWalletBtn');

function updateButtonText(text) {
    connectWalletBtn.textContent = text;
}

const skinSelector = document.getElementById('skinSelector');

async function connectWalletWrapper() {
    let isConnected = await walletInstance.connectWallet(updateButtonText);

    if (!isConnected)
        return;

    const walletAddress = walletInstance.getWalletAddress();
    const settings = settingsInstance.getContractSettings('GamingNftSepolia');
    const nftUtils = new NftFetcher(settings.getGoldskyApi(), walletAddress);
    const tokenIds = await nftUtils.fetchUserNFT();

    if (!walletAddress) {
        alert('Failed to connect wallet.');
        return;
    }
    
    const nftMetadataFetcher = new NftMetadataFetcher(settings.getNetwork(), settings.getContractAddress());
    console.log("dfsdfs");
    console.log(nftMetadataFetcher);

    const metadataList = await nftMetadataFetcher.getTokensMetadata(tokenIds);
    
    if (!metadataList)
        return;


    const skinNameArray = metadataList.map(jsonString => {
        const jsonObject = JSON.parse(jsonString);
        return jsonObject.name;
    });
    console.log(skinNameArray);

    // const skins = document.getElementById("skins");
    
    // skinNameArray.forEach(str => {
    //     const option = document.createElement('option');
    //     option.value = str;  // Set the value of the option
    //     option.textContent = str; // Set the visible text of the option
    //     str.appendChild(option); // Add the option to the select element
    // });

    const colorMap = {
        1: "#C92626", //red
        2: "#3030E3", //blue
        3: "#29AB29", //green
        4: "#FFCC00", //yellow
        5: "#4C00B0", //purple
        6: "#E65B05", //orange
        7: "#BE2ED6", //pink
    }

    skinNameArray.forEach((skin, index) => {
        console.log(skin);
        const option = document.createElement('option');

        option.value = colorMap[tokenIds[index]];
        option.text = skin; 
        skinSelector.add(option);
    });
}

connectWalletBtn.addEventListener('click', connectWalletWrapper);

updateButtonText('Connect Your Wallet');