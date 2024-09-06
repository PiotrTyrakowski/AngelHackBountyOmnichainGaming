import 'dart:js_interop';
import 'package:market_place/models/nft_token.dart';

class JsSwapInfo {
  late final JSNumber? swapId;
  late final JSString initiator;
  late final JSString counterparty;
  late final JSArray<JSString> initiatorNftContracts;
  late final JSArray<JSNumber> initiatorTokenIds;
  late final JSArray<JSNumber> initiatorTokenCounts;
  late final JSArray<JSString> counterpartyNftContracts;
  late final JSArray<JSNumber> counterpartyTokenIds;
  late final JSArray<JSNumber> counterpartyTokenCounts;

  JsSwapInfo(
    String fromId,
    String toId,
    List<NftToken> fromItems,
    List<NftToken> toItems,
    String? swapId,
  ) {
    // Make a hash map of contract id to list of token ids per from and to
    var fromMap = <String, List<int>>{};
    var toMap = <String, List<int>>{};

    for (var token in fromItems) {
      if (!fromMap.containsKey(token.ContractId)) {
        fromMap[token.ContractId] = List<int>.empty(growable: true);
      }
      fromMap[token.ContractId]!.add(int.parse(token.TokenId));
    }

    for (var token in toItems) {
      if (!toMap.containsKey(token.ContractId)) {
        toMap[token.ContractId] = List<int>.empty(growable: true);
      }
      toMap[token.ContractId]!.add(int.parse(token.TokenId));
    }

    // Flatten the maps into arrays, and counts
    var fromContracts = List<String>.empty(growable: true);
    var fromTokenIds = List<int>.empty(growable: true);
    var fromTokenCounts = List<int>.empty(growable: true);

    for (var entry in fromMap.entries) {
      fromContracts.add(entry.key);
      fromTokenIds.addAll(entry.value);
      fromTokenCounts.add(entry.value.length);
    }

    var toContracts = List<String>.empty(growable: true);
    var toTokenIds = List<int>.empty(growable: true);
    var toTokenCounts = List<int>.empty(growable: true);

    for (var entry in toMap.entries) {
      toContracts.add(entry.key);
      toTokenIds.addAll(entry.value);
      toTokenCounts.add(entry.value.length);
    }

    print("Created swapInfo with data: from $fromId to $toId");
    print("From: $fromContracts, $fromTokenIds, $fromTokenCounts");
    print("To: $toContracts, $toTokenIds, $toTokenCounts");

    // Convert to JS types
    if (swapId == null) {
      this.swapId = null;
    } else {
      this.swapId = int.parse(swapId).toJS;
    }
    counterparty = toId.toJS;
    initiatorNftContracts = fromContracts.map((e) => e.toJS).toList().toJS;
    initiatorTokenIds = fromTokenIds.map((e) => e.toJS).toList().toJS;
    initiatorTokenCounts = fromTokenCounts.map((e) => e.toJS).toList().toJS;
    counterpartyNftContracts = toContracts.map((e) => e.toJS).toList().toJS;
    counterpartyTokenIds = toTokenIds.map((e) => e.toJS).toList().toJS;
    counterpartyTokenCounts = toTokenCounts.map((e) => e.toJS).toList().toJS;
  }
}
