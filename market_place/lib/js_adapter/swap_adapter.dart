import 'package:market_place/contract_info.dart';

import '../nft_token.dart';
import 'dart:collection';

class SwapAdapter{

  static void IssueContract(String fromId, String toId, List<NftToken> fromItems, List<NftToken> toItems)
  {
    print("Swap contract send");
  }

  static void IssueContractUsingInfo(ContractInfo info)
  {
    IssueContract(info.senderId, info.targetId, info.senderTokens, info.targetTokens);
  }
}