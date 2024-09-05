import 'package:market_place/models/contract_info.dart';
import 'package:market_place/models/nft_token.dart';


List<ContractInfo> swaps = [
  ContractInfo(
      contractId: 'contract123',
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
  ContractInfo(
      contractId: 'contract456',
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
