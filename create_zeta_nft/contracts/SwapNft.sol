// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract SwapNft is ERC721Holder {
    struct Swap {
        address initiator;
        address counterparty;
        address[] initiatorNftContracts;
        uint256[] initiatorTokenIds;
        uint256[] initiatorTokenCounts;  // Keeps track of how many tokens per contract
        address[] counterpartyNftContracts;
        uint256[] counterpartyTokenIds;
        uint256[] counterpartyTokenCounts;  // Keeps track of how many tokens per contract
        bool isCompleted;
    }

    mapping(uint256 => Swap) public swaps;
    uint256 public swapCounter;

    event SwapInitiated(
        uint256 swapId,
        address initiator,
        address[] initiatorNftContracts,
        uint256[] initiatorTokenIds,
        uint256[] initiatorTokenCounts,
        address counterparty,
        address[] counterpartyNftContracts,
        uint256[] counterpartyTokenIds,
        uint256[] counterpartyTokenCounts
    );
    event SwapCompleted(uint256 swapId);
    event SwapCancelled(uint256 swapId);

    function initiateSwap(
        address _counterparty,
        address[] calldata _initiatorNftContracts,
        uint256[] calldata _initiatorTokenIds,
        uint256[] calldata _initiatorTokenCounts,
        address[] calldata _counterpartyNftContracts,
        uint256[] calldata _counterpartyTokenIds,
        uint256[] calldata _counterpartyTokenCounts
    ) external {
        require(_initiatorNftContracts.length == _initiatorTokenCounts.length, "Mismatched lengths for initiator NFTs");
        require(_counterpartyNftContracts.length == _counterpartyTokenCounts.length, "Mismatched lengths for counterparty NFTs");

        // Transfer initiator's NFTs to this contract
        uint256 initiatorTokenIndex = 0;
        for (uint256 i = 0; i < _initiatorNftContracts.length; i++) {
            for (uint256 j = 0; j < _initiatorTokenCounts[i]; j++) {
                IERC721(_initiatorNftContracts[i]).transferFrom(msg.sender, address(this), _initiatorTokenIds[initiatorTokenIndex]);
                initiatorTokenIndex++;
            }
        }

        // Store the swap details
        swaps[swapCounter] = Swap({
            initiator: msg.sender,
            counterparty: _counterparty,
            initiatorNftContracts: _initiatorNftContracts,
            initiatorTokenIds: _initiatorTokenIds,
            initiatorTokenCounts: _initiatorTokenCounts,
            counterpartyNftContracts: _counterpartyNftContracts,
            counterpartyTokenIds: _counterpartyTokenIds,
            counterpartyTokenCounts: _counterpartyTokenCounts,
            isCompleted: false
        });

        emit SwapInitiated(swapCounter, msg.sender, _initiatorNftContracts, _initiatorTokenIds, _initiatorTokenCounts, _counterparty, _counterpartyNftContracts, _counterpartyTokenIds, _counterpartyTokenCounts);
        swapCounter++;
    }

    function completeSwap(uint256 _swapId) external {
        Swap storage swap = swaps[_swapId];
        require(!swap.isCompleted, "Swap already completed");
        require(msg.sender == swap.counterparty, "Only counterparty can complete the swap");

        // Transfer counterparty's NFTs to the initiator
        uint256 counterpartyTokenIndex = 0;
        for (uint256 i = 0; i < swap.counterpartyNftContracts.length; i++) {
            for (uint256 j = 0; j < swap.counterpartyTokenCounts[i]; j++) {
                IERC721(swap.counterpartyNftContracts[i]).transferFrom(msg.sender, swap.initiator, swap.counterpartyTokenIds[counterpartyTokenIndex]);
                counterpartyTokenIndex++;
            }
        }

        // Transfer initiator's NFTs to the counterparty
        uint256 initiatorTokenIndex = 0;
        for (uint256 i = 0; i < swap.initiatorNftContracts.length; i++) {
            for (uint256 j = 0; j < swap.initiatorTokenCounts[i]; j++) {
                IERC721(swap.initiatorNftContracts[i]).transferFrom(address(this), msg.sender, swap.initiatorTokenIds[initiatorTokenIndex]);
                initiatorTokenIndex++;
            }
        }

        swap.isCompleted = true;
        emit SwapCompleted(_swapId);
    }

    function cancelSwap(uint256 _swapId) external {
        Swap storage swap = swaps[_swapId];
        require(!swap.isCompleted, "Swap already completed");
        require(msg.sender == swap.initiator, "Only initiator can cancel the swap");

        // Return initiator's NFTs
        uint256 initiatorTokenIndex = 0;
        for (uint256 i = 0; i < swap.initiatorNftContracts.length; i++) {
            for (uint256 j = 0; j < swap.initiatorTokenCounts[i]; j++) {
                IERC721(swap.initiatorNftContracts[i]).transferFrom(address(this), swap.initiator, swap.initiatorTokenIds[initiatorTokenIndex]);
                initiatorTokenIndex++;
            }
        }

        swap.isCompleted = true;
        emit SwapCancelled(_swapId);
    }
}
