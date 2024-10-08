import NftFetcher from "./lib_nft/NftFetcher.js";
import NftMetadataFetcher from "./lib_nft/NftMetadataFetcher.js";
import walletInstance from "./lib_nft/Wallet.js";
import settingsInstance from "./lib_nft/Settings.js";
import { getAvailableSkins } from "./get_skins";

const connectWalletBtn = document.getElementById('connectWalletBtn');

function updateButtonText(text) {
    connectWalletBtn.textContent = text;
}

async function connectWalletWrapper() {
    let isConnected = await walletInstance.connectWallet(updateButtonText);

    if (!isConnected)
        return;

    // fetching token ids
    const walletAddress = walletInstance.getWalletAddress();
    const settings = settingsInstance.getContractSettings('GamingNftZetachain2');
    const nftFetcher = new NftFetcher(settings.getGoldskyApi(), walletAddress);
    const tokenIds = await nftFetcher.fetchUserNft();

    // Get the wallet address
    if (!walletAddress) {
        alert('Failed to connect wallet.');
        return;
    }

    // Create an instance of NftMetadataFetcher
    const nftMetadataFetcher = new NftMetadataFetcher(settings.network, settings.contractAddress);

    // Fetch metadata for the tokens
    const metadataList = await nftMetadataFetcher.getTokensMetadata(tokenIds);

    if (!metadataList)
        return;

    // Converting array of jsons into string arrays containing skin names
    const skinNameArray = metadataList.map(jsonString => {
        const jsonObject = JSON.parse(jsonString);
        return jsonObject.name;
    });

    // Updateing the select of available skins
    const skinSelect = document.getElementById("skins");

    console.log(skinNameArray);
    
    skinNameArray.forEach(str => {
        const option = document.createElement('option');
        option.value = str;  // Set the value of the option
        option.textContent = str; // Set the visible text of the option
        skinSelect.appendChild(option); // Add the option to the select element
    });
}

connectWalletBtn.addEventListener('click', connectWalletWrapper);

updateButtonText('Connect Your Wallet');
