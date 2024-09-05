import 'package:market_place/models/swap_info.dart';
import 'package:market_place/models/nft_token.dart';

List<SwapInfo> swap_mock = [
  SwapInfo(
      swapId: 'contract123',
      senderId: 'Alice',
      targetId: 'Bob',
      senderTokens: [
        const NftToken(
          ContractId: '002',
          OwnerId: 'Bob',
          TokenId: 'T002',
          Description: 'An uncommon token',
          Rarity: 'Uncommon',
          Name: 'Silver Token',
        ),
        const NftToken(
          ContractId: '003',
          OwnerId: 'Charlie',
          TokenId: 'T003',
          Description: 'A common token',
          Rarity: 'Common',
          Name: 'Bronze Token',
        ),
        const NftToken(
          ContractId: '002',
          OwnerId: 'Bob',
          TokenId: 'T002',
          Description: 'An uncommon token',
          Rarity: 'Uncommon',
          Name: 'Silver Token',
        ),
        const NftToken(
          ContractId: '003',
          OwnerId: 'Charlie',
          TokenId: 'T003',
          Description: 'A common token',
          Rarity: 'Common',
          Name: 'Bronze Token',
        ),
        const NftToken(
          ContractId: '002',
          OwnerId: 'Bob',
          TokenId: 'T002',
          Description: 'An uncommon token',
          Rarity: 'Uncommon',
          Name: 'Silver Token',
        ),
        const NftToken(
          ContractId: '003',
          OwnerId: 'Charlie',
          TokenId: 'T003',
          Description: 'A common token',
          Rarity: 'Common',
          Name: 'Bronze Token',
        ),
        const NftToken(
          ContractId: '002',
          OwnerId: 'Bob',
          TokenId: 'T002',
          Description: 'An uncommon token',
          Rarity: 'Uncommon',
          Name: 'Silver Token',
        ),
        const NftToken(
          ContractId: '003',
          OwnerId: 'Charlie',
          TokenId: 'T003',
          Description: 'A common token',
          Rarity: 'Common',
          Name: 'Bronze Token',
        )
      ],
      targetTokens: [
        const NftToken(
          ContractId: '001',
          OwnerId: 'Alice',
          TokenId: 'T001',
          Description: 'A rare token',
          Rarity: 'Rare',
          Name: 'Golden Token',
        )
      ]),
  SwapInfo(
      swapId: 'contract456',
      senderId: 'Jacob',
      targetId: 'Bob',
      senderTokens: [
        const NftToken(
          ContractId: '003',
          OwnerId: 'Charlie',
          TokenId: 'T003',
          Description: 'A common token',
          Rarity: 'Common',
          Name: 'Bronze Token',
        ),
        const NftToken(
          ContractId: '004',
          OwnerId: 'Bob',
          TokenId: 'T002',
          Description: 'An uncommon token',
          Rarity: 'Uncommon',
          Name: 'Silver Token',
        ),
        const NftToken(
          ContractId: '005',
          OwnerId: 'Charlie',
          TokenId: 'T003',
          Description: 'A common token',
          Rarity: 'Common',
          Name: 'Bronze Token',
        ),
      ],
      targetTokens: [
        const NftToken(
          ContractId: '001',
          OwnerId: 'Alice',
          TokenId: 'T001',
          Description: 'A rare token',
          Rarity: 'Rare',
          Name: 'Golden Token',
        ),
        const NftToken(
          ContractId: '004',
          OwnerId: 'Diana',
          TokenId: 'T004',
          Description: 'A legendary token',
          Rarity: 'Legendary',
          Name: 'Platinum Token',
        )
      ])
];
