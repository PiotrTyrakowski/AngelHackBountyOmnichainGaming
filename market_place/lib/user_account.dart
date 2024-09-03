import 'nft_token.dart';
import 'js_adapter/nft_adapter.dart';
import 'dart:collection';
import 'games/game_widgets.dart';

class UserAccount {
  UserAccount._internal();

  static final UserAccount _instance = UserAccount._internal();

  factory UserAccount() {
    return _instance;
  }

  bool IsLogged() {
    return _etherId != "";
  }

  void OnLogin(String etherId) {
    _etherId = etherId;
  }

  HashMap<String, List<NftToken>> GetOwnedNfts() {
    return NftAdapter.GetOwnedNfts(_etherId);
  }

  String _etherId = "";

  String get etherId => _etherId;
}
