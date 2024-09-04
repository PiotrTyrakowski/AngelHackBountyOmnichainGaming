import 'package:market_place/contract_info.dart';

import '../nft_token.dart';
import 'dart:collection';

class SwapAdapter{

  static void IssueContract(String fromId, String toId, List<NftToken> fromItems, List<NftToken> toItems)
  {
    print("Swap contract send");
  }

  static List<ContractInfo> GetAllContracts(String userId)
  {
    return [];
  }

  static void CancelContract(ContractInfo info)
  {
    print("Swap contract cancelled");
  }

  static void AcceptContract(ContractInfo info)
  {
    print("Swap contract accepted");
  }

  // "" = success, otherwise provide error
  static void IssueContractUsingInfo(ContractInfo info)
  {
    return IssueContract(info.senderId, info.targetId, info.senderTokens, info.targetTokens);
  }
}