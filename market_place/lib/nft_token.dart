import 'dart:convert';

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

  factory NftToken.fromJson(Map<String, dynamic> json) {
    return NftToken(
      ContractId: json['contractid']?.toString() ?? '',
      OwnerId: json['ownerid']?.toString() ?? '',
      TokenId: json['tokenid']?.toString() ?? '',
      Description: json['description']?.toString() ?? '',
      Rarity: json['rarity']?.toString() ?? '',
      Name: json['name']?.toString() ?? '',
    );
  }

  factory NftToken.fromJsonString(String jsonString) {
    return NftToken.fromJson(jsonDecode(jsonString));
  }
}
