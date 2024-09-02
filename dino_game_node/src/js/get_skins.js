import { fetchUserNFT } from "./lib_nft/fetch_user_nft";
import { getTokensMetadata } from "./lib_nft/get_nft_metadata";
import { network, contractAddress } from "./lib_nft/settings";

export async function getAvailableSkins() {
    const NFTs = await fetchUserNFT();
    if (!NFTs) {
        console.log("Null NFTs");
        return null;
    }
    const Metadatas = await getTokensMetadata(NFTs, network, contractAddress);
    if (!Metadatas) {
        console.log("Null NFTs");
        return null;
    }

    let uniqueSkins = {};
    Metadatas.forEach(metadataString => {
        const metadata = JSON.parse(metadataString);
        uniqueSkins[metadata.id] = metadata;
    });

    return Metadatas;
}
