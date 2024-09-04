import 'dart:collection';
import 'nft_token.dart';
import 'js_adapter/nft_adapter.dart';

class FriendInfo {
  final String name;
  final String icon;
  final String userId;

  HashMap<String, List<NftToken>> GetOwnedNfts() {
    return NftAdapter.GetOwnedNfts(userId);
  }

  const FriendInfo(
      {required this.name, required this.icon, required this.userId});
}

const List<FriendInfo> Friends = [
  FriendInfo(name: "Johnny", icon: "assets/johny_icon.png", userId: "1")
];