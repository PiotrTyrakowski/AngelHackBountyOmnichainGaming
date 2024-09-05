@JS()
library my_lib; //Not avoid the library annotation

import 'dart:convert';
import 'dart:js_interop';

import '../nft_token.dart';
import '../games/games_info.dart';
import 'dart:collection';

import 'dart:js_util' as jsu;

// external fetchUserNfts(String userAccountAddress);
@JS()
external JSPromise<JSArray<JSString>> fetchUserNfts(
    String gameNftContractAddress, String userAccountAddress);

class NftAdapter {
  static Future<List<NftToken>> GetGameTokens(
      String gameNftContractAddress, String userAccountAddress) async {
    gameNftContractAddress = gameNftContractAddress.toLowerCase();
    userAccountAddress = userAccountAddress.toLowerCase();
    print(
        "Getting tokens for game $gameNftContractAddress, user $userAccountAddress");

    List<NftToken> tokens = await jsu
        .promiseToFuture<JSArray<JSString>>(
            fetchUserNfts(gameNftContractAddress, userAccountAddress))
        .then((value) {
      return value.toDart
          .map((e) => NftToken.fromJson(jsonDecode(e.toDart)))
          .toList();
    });
    tokens.shuffle();
    print("Got ${tokens.length} tokens for game $gameNftContractAddress");
    return tokens;
  }

  static Future<HashMap<String, List<NftToken>>> GetOwnedNfts(String id) async {
    var rv = HashMap<String, List<NftToken>>();

    for (var game in Games) {
      rv[game.name] =
          List.from(await NftAdapter.GetGameTokens(game.contractId, id));
    }

    print("Get all nfts");
    return rv;
  }
}
