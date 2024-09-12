import { NftFetcher } from "./lib_nft/index-prod.js";
import { NftMetadataFetcher } from "./lib_nft/index-prod.js";
import { settingsInstance } from "./lib_nft/index-prod.js";
import { walletInstance } from "./lib_nft/index-prod.js";
import NftFetcher from "./lib_nft/NftFetcher.js";

export async function getAvailableSkins() {
    const ZetachainSettings = settingsInstance.getContractSettings('GamingNftZetachain1');
    const network = ZetachainSettings.getNetwork();
    const contractAddress = ZetachainSettings.getContractAddress();

    const nftFetcher = NftFetcher(settings.getGoldskyApi(), walletInstance.getWalletAddress());
    const metadataFetcher = NftMetadataFetcher(network, contractAddress);

    const NFTs = await nftFetcher.fetchUserNFT();
    const Metadatas = await metadataFetcher.getTokensMetadata(NFTs);

    let uniqueSkins = {};
    Metadatas.forEach(metadataString => {
        const metadata = JSON.parse(metadataString);
        uniqueSkins[metadata.id] = metadata;
    });

    let skinsArray = Object.values(uniqueSkins);
    return skinsArray;
}
