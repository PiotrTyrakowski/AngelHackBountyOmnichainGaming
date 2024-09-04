import 'package:market_place/nft_token.dart';

class ContractInfo {
  String contractId;
  String senderId;
  String targetId;
  List<NftToken> senderTokens;
  List<NftToken> targetTokens;

  ContractInfo(
      {this.contractId = "",
      this.targetId = "",
      this.senderId = "",
      this.senderTokens = const [],
      this.targetTokens = const []});
<<<<<<< HEAD
}
=======
}
>>>>>>> 14-market-place---create-offer-page
