@JS()
library my_lib; //Not avoid the library annotation

import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_util' as jsu;

import 'package:market_place/models/swap_info.dart';
import '../mock_data/swap_mock_list_2.dart';

import '../models/nft_token.dart';

// external fetchUserNfts(String userAccountAddress);
@JS()
external JSPromise<JSNumber> InitiateSwapJs(
    JSString counterparty,
    JSArray<JSString> initatorContracts,
    JSArray<JSNumber> initatiorTokenIds,
    JSArray<JSNumber> initatorTokenCounts,
    JSArray<JSString> counterpartyContracts,
    JSArray<JSNumber> counterpartyTokenIds,
    JSArray<JSNumber> counterpartyTokenCounts);

@JS()
external JSPromise<JSObject> GetSwapsToUserJs(JSString walletAddress);

@JS()
external JSPromise<JSAny> CancelSwapJs(JSString swapId);

@JS()
external JSPromise<JSAny> AcceptSwapJs(JSString swapId);

class SwapAdapter {
  static InitiateSwap(String fromId, String toId, List<NftToken> fromItems,
      List<NftToken> toItems) async {
    // Make a hash map of contract id to list of token ids per from and to
    var fromMap = <String, List<int>>{};
    var toMap = <String, List<int>>{};

    for (var token in fromItems) {
      if (!fromMap.containsKey(token.ContractId)) {
        fromMap[token.ContractId] = List<int>.empty();
      }
      fromMap[token.ContractId]!.add(int.parse(token.TokenId));
    }

    for (var token in toItems) {
      if (!toMap.containsKey(token.ContractId)) {
        toMap[token.ContractId] = List<int>.empty();
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

    print("Initiating swap from $fromId to $toId");
    print("From: $fromContracts, $fromTokenIds, $fromTokenCounts");
    print("To: $toContracts, $toTokenIds, $toTokenCounts");

    // Convert to JS types
    JSString counterparty = toId.toJS;
    JSArray<JSString> initatorContracts =
        fromContracts.map((e) => e.toJS).toList().toJS;
    JSArray<JSNumber> initatiorTokenIds =
        fromTokenIds.map((e) => e.toJS).toList().toJS;
    JSArray<JSNumber> initatorTokenCounts =
        fromTokenCounts.map((e) => e.toJS).toList().toJS;
    JSArray<JSString> counterpartyContracts =
        toContracts.map((e) => e.toJS).toList().toJS;
    JSArray<JSNumber> counterpartyTokenIds =
        toTokenIds.map((e) => e.toJS).toList().toJS;
    JSArray<JSNumber> counterpartyTokenCounts =
        toTokenCounts.map((e) => e.toJS).toList().toJS;

    // Call the JS function
    jsu.promiseToFuture<JSNumber>(InitiateSwapJs(
        counterparty,
        initatorContracts,
        initatiorTokenIds,
        initatorTokenCounts,
        counterpartyContracts,
        counterpartyTokenIds,
        counterpartyTokenCounts));
  }

  static Future<List<SwapInfo>> GetSwapsToUser(String userId) async {
    var swaps =
        await jsu.promiseToFuture<JSObject>(GetSwapsToUserJs(userId.toJS));
    return [];
  }

  static void CancelSwap(SwapInfo info) async {
    CancelSwapJs(info.swapId.toJS);
  }

  static void AcceptSwap(SwapInfo info) async {
    AcceptSwapJs(info.swapId.toJS);
  }

  // "" = success, otherwise provide error
  static void IssueSwapUsingInfo(SwapInfo info) async {
    InitiateSwap(
        info.senderId, info.targetId, info.senderTokens, info.targetTokens);
  }
}
