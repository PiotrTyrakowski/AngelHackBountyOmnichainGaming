// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract swapNFT is ERC721Holder {
    struct Swap {
        address initiator;
        address counterparty;
        address nftContractA;
        uint256 tokenIdA;
        address nftContractB;
        uint256 tokenIdB;
        bool isCompleted;
    }

    mapping(uint256 => Swap) public swaps;
    uint256 public swapCounter;

    event SwapInitiated(uint256 swapId, address initiator, address nftContractA, uint256 tokenIdA, address nftContractB, uint256 tokenIdB);
    event SwapCompleted(uint256 swapId);
    event SwapCancelled(uint256 swapId);

    function initiateSwap(
        address _counterparty,
        address _nftContractA,
        uint256 _tokenIdA,
        address _nftContractB,
        uint256 _tokenIdB
    ) external {
        IERC721(_nftContractA).transferFrom(msg.sender, address(this), _tokenIdA);

        swaps[swapCounter] = Swap({
            initiator: msg.sender,
            counterparty: _counterparty,
            nftContractA: _nftContractA,
            tokenIdA: _tokenIdA,
            nftContractB: _nftContractB,
            tokenIdB: _tokenIdB,
            isCompleted: false
        });

        emit SwapInitiated(swapCounter, msg.sender, _nftContractA, _tokenIdA, _nftContractB, _tokenIdB);
        swapCounter++;
    }

    function completeSwap(uint256 _swapId) external {
        Swap storage swap = swaps[_swapId];
        require(!swap.isCompleted, "Swap already completed");
        require(msg.sender == swap.counterparty, "Only counterparty can complete the swap");

        IERC721(swap.nftContractB).transferFrom(msg.sender, swap.initiator, swap.tokenIdB);
        IERC721(swap.nftContractA).transferFrom(address(this), msg.sender, swap.tokenIdA);

        swap.isCompleted = true;
        emit SwapCompleted(_swapId);
    }

    function cancelSwap(uint256 _swapId) external {
        Swap storage swap = swaps[_swapId];
        require(!swap.isCompleted, "Swap already completed");
        require(msg.sender == swap.initiator, "Only initiator can cancel the swap");

        IERC721(swap.nftContractA).transferFrom(address(this), swap.initiator, swap.tokenIdA);

        swap.isCompleted = true;
        emit SwapCancelled(_swapId);
    }
}