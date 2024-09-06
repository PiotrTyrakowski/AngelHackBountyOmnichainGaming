@JS()
library my_lib; //Not avoid the library annotation

import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_util' as jsu;

import 'package:market_place/js_adapter/js_swap_info.dart';
import 'package:market_place/models/swap_info.dart';

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
external JSPromise<JSString> GetSwapsToUserJs(JSString walletAddress);

@JS()
external JSPromise CancelSwapJs(JSNumber swapId);

@JS()
external JSPromise AcceptSwapJs(
    JSNumber swapId,
    JSArray<JSString> counterpartyContracts,
    JSArray<JSNumber> counterpartyTokenIds,
    JSArray<JSNumber> counterpartyTokenCounts);

@JS()
external JSPromise<JSArray<JSString>> fetchNftsMetadata(
    JSString contractId, JSArray<JSNumber> tokenIds);

class SwapAdapter {
  static InitiateSwap(String fromId, String toId, List<NftToken> fromItems,
      List<NftToken> toItems) async {
    // Call the JS function
    JsSwapInfo info = JsSwapInfo(fromId, toId, fromItems, toItems, null);
    jsu.promiseToFuture<JSNumber>(InitiateSwapJs(
        info.counterparty,
        info.initiatorNftContracts,
        info.initiatorTokenIds,
        info.initiatorTokenCounts,
        info.counterpartyNftContracts,
        info.counterpartyTokenIds,
        info.counterpartyTokenCounts));
  }

  static Future<List<SwapInfo>> GetSwapsToUser(String userId) async {
    var swapsJson =
        await jsu.promiseToFuture<JSString>(GetSwapsToUserJs(userId.toJS));
    List<dynamic> swaps = jsonDecode(swapsJson.toString()) as List<dynamic>;

    print("Got ${swaps.length} swaps for user $userId");
    // for item in swaps parse the underlying js object
    return Future.wait(swaps.map((e) async {
      print("Swap is $e");

      print("Parsing swap");
      var swap = e as Map<String, dynamic>;
      print("Map is $swap");

      // Declaring the intermediate form
      print("Parsing swap ${swap["swapId"]}");

      Map<String, List<int>> senderTokensIntermediateForm = {};
      Map<String, List<int>> targetTokensIntermediateForm = {};

      List<String> senderContracts = (swap["initiatorNftContracts"] != null &&
              swap["initiatorNftContracts"] is List)
          ? List<String>.from(swap["initiatorNftContracts"])
          : [];
      List<int> senderTokenIds = (swap["initiatorTokenIds"] != null &&
              swap["initiatorTokenIds"] is List)
          ? List<int>.from(swap["initiatorTokenIds"])
          : [];
      List<int> senderTokenCounts = (swap["initiatorTokenCounts"] != null &&
              swap["initiatorTokenCounts"] is List)
          ? List<int>.from(swap["initiatorTokenCounts"])
          : [];

      List<String> targetContracts =
          (swap["counterpartyNftContracts"] != null &&
                  swap["counterpartyNftContracts"] is List)
              ? List<String>.from(swap["counterpartyNftContracts"])
              : [];
      List<int> targetTokenIds = (swap["counterpartyTokenIds"] != null &&
              swap["counterpartyTokenIds"] is List)
          ? List<int>.from(swap["counterpartyTokenIds"])
          : [];

      List<int> targetTokenCounts = (swap["counterpartyTokenCounts"] != null &&
              swap["counterpartyTokenCounts"] is List)
          ? List<int>.from(swap["counterpartyTokenCounts"])
          : [];

      // Getting the first intermediate form
      print("Parsing sender tokens");
      int totalCounts = 0;
      for (int i = 0; i < senderContracts.length; i++) {
        for (int j = 0; j < senderTokenCounts[i]; j++) {
          if (!senderTokensIntermediateForm.containsKey(senderContracts[i])) {
            senderTokensIntermediateForm[senderContracts[i]] =
                List.empty(growable: true);
          }
          senderTokensIntermediateForm[senderContracts[i]]!
              .add(senderTokenIds[totalCounts]);
          totalCounts++;
        }
      }

      print("Parsing target tokens");
      totalCounts = 0;
      for (int i = 0; i < targetContracts.length; i++) {
        for (int j = 0; j < targetTokenCounts[i]; j++) {
          if (!targetTokensIntermediateForm.containsKey(targetContracts[i])) {
            targetTokensIntermediateForm[targetContracts[i]] =
                List.empty(growable: true);
          }
          targetTokensIntermediateForm[targetContracts[i]]!
              .add(targetTokenIds[totalCounts]);
          totalCounts++;
        }
      }

      print("Got sender tokens $senderTokensIntermediateForm");
      print("Got target tokens $targetTokensIntermediateForm");

      // Fetching the metadata for the tokens from the intermediate form
      List<NftToken> senderTokens = List.empty(growable: true);
      List<NftToken> targetTokens = List.empty(growable: true);

      print("Fetching sender tokens");
      for (var entry in senderTokensIntermediateForm.entries) {
        List<NftToken> tokens = await jsu
            .promiseToFuture<JSArray<JSString>>(fetchNftsMetadata(
                entry.key.toJS, entry.value.map((e) => e.toJS).toList().toJS))
            .then((value) {
          return value.toDart
              .map((e) => NftToken.fromJson(jsonDecode(e.toDart)))
              .toList();
        });
        senderTokens.addAll(tokens);
      }
      print("Got sender tokens ${senderTokens.length}");
      print("Sender tokens: $senderTokens");

      print("Fetching target tokens");
      for (var entry in targetTokensIntermediateForm.entries) {
        List<NftToken> tokens = await jsu
            .promiseToFuture<JSArray<JSString>>(fetchNftsMetadata(
                entry.key.toJS, entry.value.map((e) => e.toJS).toList().toJS))
            .then((value) {
          return value.toDart
              .map((e) => NftToken.fromJson(jsonDecode(e.toDart)))
              .toList();
        });
        targetTokens.addAll(tokens);
      }

      print("Got sender tokens of len: ${senderTokens.length}");
      print("Got target tokens of len: ${targetTokens.length}");

      print("swapId: ${swap["swapId"]}");
      print("initator: ${swap["initiator"]}");
      print("counterparty: ${swap["counterparty"]}");

      return SwapInfo(
          swapId: swap["swapId"],
          senderId: swap["initiator"],
          targetId: swap["counterparty"],
          senderTokens: senderTokens,
          targetTokens: targetTokens);
    }));
  }

  static void CancelSwap(SwapInfo info) async {
    int swapId = int.parse(info.swapId);
    if (swapId == null) {
      throw Exception("Invalid swap id");
    }
    jsu.promiseToFuture<JSPromise<JSAny>>(CancelSwapJs(swapId.toJS));
  }

  static void AcceptSwap(SwapInfo info) async {
    JsSwapInfo jsInfo = JsSwapInfo(info.senderId, info.targetId,
        info.senderTokens, info.targetTokens, info.swapId);
    jsu.promiseToFuture<JSPromise<JSAny>>(AcceptSwapJs(
        jsInfo.swapId!,
        jsInfo.counterpartyNftContracts,
        jsInfo.counterpartyTokenIds,
        jsInfo.counterpartyTokenCounts));
  }

  // "" = success, otherwise provide error
  static void IssueSwapUsingInfo(SwapInfo info) async {
    InitiateSwap(
        info.senderId, info.targetId, info.senderTokens, info.targetTokens);
  }
}
