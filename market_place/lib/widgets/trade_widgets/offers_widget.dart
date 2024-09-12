import 'package:flutter/material.dart';
import 'package:market_place/js_adapter/swap_adapter.dart';
import 'package:market_place/user_account.dart';
import 'package:market_place/widgets/RoundedBox.dart';
import '../general_purpose/animated_gradient_text.dart';
import '../general_purpose/rounded_container.dart';
import '../login/login_first_widget.dart';
import 'swap_blank_widget.dart';
import 'package:market_place/models/swap_info.dart';
import 'package:market_place/models/nft_token.dart';

class OffersWidget extends StatefulWidget {
  const OffersWidget({super.key});

  @override
  _OffersWidgetState createState() => _OffersWidgetState();
}

class _OffersWidgetState extends State<OffersWidget> {
  final List<SwapInfo> _userSwaps = [];
  String? _selectedSwapId;
  SwapInfo? _contractInfo;

  @override
  void initState() {
    super.initState();
    SwapAdapter.GetSwapsToUser(UserAccount().etherId).then((value) {
      setState(() {
        _userSwaps.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginFirstWidget(child: _buildGamesLib(context));
  }

  void _cleanContract(SwapInfo info) {
    setState(() {
      if (_selectedSwapId == info.swapId) {
        _selectedSwapId = null;
      }

      if (_contractInfo == info) {
        _contractInfo = null;
      }

      if (_userSwaps.contains(info)) {
        _userSwaps.remove(info);
      }
    });
  }

  Widget _buildGamesLib(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: RoundedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _userSwaps
                  .map((swap) => SwapBlankWidget(
                      info: swap,
                      onClick: () {
                        setState(() {
                          _selectedSwapId = swap.swapId;
                          _contractInfo = swap;
                        });
                      },
                      onAccept: (SwapInfo info) async {
                        SwapAdapter.AcceptSwap(info);
                        _cleanContract(info);
                      },
                      onDecline: (SwapInfo info) async {
                        SwapAdapter.CancelSwap(info);
                        _cleanContract(info);
                      }))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(
          width: 32,
        ),
        Expanded(
            flex: 10,
            child: Center(
              child: _swapInfo(context),
            ))
      ],
    );
  }

  Widget _swapInfo(BuildContext context) {
    return Center(
        child: _selectedSwapId == null
            ? const RoundedContainer(
                width: null,
                height: null,
                padding: EdgeInsets.all(16),
                borderColor: Colors.white,
                child: Text(
                  "Select swap offer",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ))
            : _swapDetails(context));
  }

  Widget _swapDetails(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return RoundedBox(
          child: Column(
            children: [
              Text(
                "Contract $_selectedSwapId selected",
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: RoundedContainer(
                          width: null,
                          height: null,
                          padding: const EdgeInsets.all(16),
                          borderColor: Colors.white,
                          child: Column(
                            children: [
                              Text(
                                "${_contractInfo!.senderId} tokens",
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: CustomScrollView(
                                  slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          final token = _contractInfo!
                                              .senderTokens[index];
                                          return _tokenCard(token, 300, 150);
                                        },
                                        childCount:
                                            _contractInfo!.senderTokens.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: RoundedContainer(
                          width: null,
                          height: null,
                          padding: const EdgeInsets.all(16),
                          borderColor: Colors.white,
                          child: Column(
                            children: [
                              Text(
                                "${_contractInfo!.targetId} tokens",
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  children: _contractInfo!.targetTokens
                                      .map((token) =>
                                          _tokenCard(token, 300, 150))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static Widget _getCommonText(double fontSize) {
    return Text(
      "Common",
      style: TextStyle(fontSize: fontSize, color: Colors.black),
    );
  }

  static Widget _getRareText(double fontSize) {
    return Text(
      "Rare",
      style: TextStyle(fontSize: fontSize, color: Colors.blue),
    );
  }

  static Widget _getMegaRareText(double fontSize) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.purple.shade300,
          Colors.purple.shade700,
        ],
      ).createShader(bounds),
      child: Text(
        "Mega Rare",
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _getLegendary(double font) {
    return AnimatedGradientText(text: "Legendary", fontSize: font);
  }

  static const Map<String, Widget Function(double)> _rarityMap = {
    "COMMON": _getCommonText,
    "RARE": _getRareText,
    "MEGA RARE": _getMegaRareText,
    "LEGENDARY": _getLegendary
  };

  Widget _getTokenColoredText(NftToken token, double fontSize) {
    if (_rarityMap.containsKey(token.Rarity.toUpperCase())) {
      return _rarityMap[token.Rarity.toUpperCase()]!(fontSize);
    }
    return _getCommonText(fontSize);
  }

  static const Map<String, Color> _colors = {
    "BLUE": Colors.blue,
    "GREEN": Colors.green,
    "ORANGE": Colors.orange,
    "PINK": Colors.pink,
    "PURPLE": Colors.purple,
    "RED": Colors.red,
    "YELLOW": Colors.yellow
  };

  Color _getTokenColor(NftToken token) {
    String first = token.Name.split(' ')[0].toUpperCase();

    if (!_colors.containsKey(first)) {
      return Colors.red;
    }

    return _colors[first]!;
  }

  Widget _tokenCard(NftToken token, double cellWidth, double cellHeight) {
    return Container(
        width: cellWidth,
        height: cellHeight,
        padding: const EdgeInsets.all(1.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 40,
                        height: 40,
                        child: Container(
                            decoration: BoxDecoration(
                          color: _getTokenColor(token),
                          borderRadius: BorderRadius.circular(8),
                        ))),
                    const SizedBox(
                      height: 40,
                      width: 16,
                      child: VerticalDivider(thickness: 2, color: Colors.black),
                    ),
                    Text(
                      token.Name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Center(
                      child: _getTokenColoredText(token, 28),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      token.Description,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
