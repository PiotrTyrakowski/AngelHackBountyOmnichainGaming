import 'nft_token.dart';
import 'js_adapter/nft_adapter.dart';
import 'dart:collection';

class UserAccount {
  UserAccount._internal();

  static final UserAccount _instance = UserAccount._internal();

  factory UserAccount() {
    return _instance;
  }

  bool IsLogged() {
    return _etherId != "0";
  }

  void OnLogin(String etherId) {
    _etherId = etherId;
  }

  HashMap<String, List<NftToken>> GetOwnedNfts() {
    return NftAdapter.GetOwnedNfts(_etherId);
  }

  String _etherId = "0";

  String get etherId => _etherId;
}
