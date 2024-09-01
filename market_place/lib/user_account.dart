import 'dart:js' as js;
import 'dart:js_util' as jsu;

class UserAccount {
  UserAccount._internal();

  static final UserAccount _instance = UserAccount._internal();

  factory UserAccount() {
    return _instance;
  }

  void OnLogin(String etherId) {
    _etherId = etherId;
  }

  String? _etherId;
}
