// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GamingNFT is ERC721, Ownable {
    uint256 private _tokenIds;
    // Mapping from token ID to token URI
    mapping(uint256 => string) private _tokenURIs;

    /*
    * @dev Constructor to set the owner
    * @param initialOwner: Address of the owner
    */
    constructor(address initialOwner) ERC721("GamingNFT", "NFT") Ownable(initialOwner) {}

    /*
    * @dev Set the token URI
    * @param tokenId: Token ID
    * @param uri: Token URI
    */
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = uri;
    }

    /*
    * @dev Returns the token URI
    * @param tokenId: Token ID
    * @return: Token URI
    */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    /*
    * @dev Mint a new NFT
    * @param recipient: Address of the recipient
    * @param jsonURI: JSON data to be stored as token URI
    */
    function mintNFT(address recipient, string memory jsonURI)
        public
        onlyOwner
        returns (uint256)
    {
        _tokenIds++;
        uint256 newItemId = _tokenIds;
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, jsonURI);
        return newItemId;
    }
}
