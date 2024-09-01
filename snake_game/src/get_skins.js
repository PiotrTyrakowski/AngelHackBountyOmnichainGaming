import { fetchUserNFT } from "./lib_nft_eth/fetch_user_nft";
import { getTokensMetadata } from "./lib_nft_eth/get_nft_metadata";
import { network, contractAddress } from "./lib_nft_eth/settings";

export async function getAvailableSkins() {
    const NFTs = await fetchUserNFT();
    const Metadatas = await getTokensMetadata(NFTs, network, contractAddress);

    let uniqueSkins = {};
    Metadatas.forEach(metadataString => {
        const metadata = JSON.parse(metadataString);
        uniqueSkins[metadata.id] = metadata;
    });

    let skinsArray = Object.values(uniqueSkins);
    return skinsArray;
}
