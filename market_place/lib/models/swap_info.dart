import 'package:market_place/models/nft_token.dart';

class SwapInfo {
  String swapId;
  String senderId;
  String targetId;
  List<NftToken> senderTokens;
  List<NftToken> targetTokens;

  SwapInfo(
      {this.swapId = "",
      this.targetId = "",
      this.senderId = "",
      this.senderTokens = const [],
      this.targetTokens = const []});
}
