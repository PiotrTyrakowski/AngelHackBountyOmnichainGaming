import 'dart:collection';
import 'package:market_place/js_adapter/nft_adapter.dart';
import 'package:market_place/models/nft_token.dart';

class FriendInfo {
  final String name;
  final String icon;
  final String userId;

  Future<HashMap<String, List<NftToken>>> GetOwnedNfts() async {
    return await NftAdapter.GetOwnedNfts(userId);
  }

  const FriendInfo(
      {required this.name, required this.icon, required this.userId});
}
