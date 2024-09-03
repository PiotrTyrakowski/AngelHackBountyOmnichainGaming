import 'dart:collection';

class NftToken {
  final String ContractId;
  final String OwnerId;
  final String TokenId;
  final String Description;
  final String Rarity;
  final String Name;

  const NftToken(
      {required this.ContractId,
        required this.OwnerId,
        required this.Description,
        required this.Rarity,
        required this.Name,
        required this.TokenId});
}