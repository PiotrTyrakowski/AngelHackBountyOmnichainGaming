import '../nft_token.dart';
import '../nft_mock1.dart';
import '../games/games_info.dart';
import 'dart:collection';

class NftAdapter{

  static List<NftToken> GetGameTokens(String gameId, String userId)
  {
    List<NftToken> tokens = List.from(userId == "0" ? mock0 : mock1);
    tokens.shuffle();

    print("Get game tokens");
    return tokens;
  }

  static HashMap<String, List<NftToken>> GetOwnedNfts(String id) {
    var rv = HashMap<String, List<NftToken>>();

    for (var game in Games) {
      rv[game.name] = List.from(NftAdapter.GetGameTokens(game.contractId, id));
    }

    print("Get all nfts");
    return rv;
  }
}