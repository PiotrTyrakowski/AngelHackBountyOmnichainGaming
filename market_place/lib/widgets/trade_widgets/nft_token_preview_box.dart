import 'package:flutter/material.dart';
import 'package:market_place/widgets/general_purpose/rounded_container.dart';
import '../general_purpose/animated_gradient_text.dart';
import '../../models/nft_token.dart';

class NftTokenPreviewBox extends StatelessWidget {
  final NftToken token;

  const NftTokenPreviewBox({super.key, required this.token});

  static Widget _getCommonText(double fontSize) {
    return Text(
      "Common",
      style: TextStyle(fontSize: fontSize, color: Colors.white),
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
    return _rarityMap[token.Rarity.toUpperCase()]!(fontSize);
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

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(1.0),
      borderColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                    width: 128,
                    height: 128,
                    child: Container(
                        decoration: BoxDecoration(
                      color: _getTokenColor(token),
                      borderRadius: BorderRadius.circular(8),
                    ))),
                const SizedBox(width: 16, height: 128),
                Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    height: 128,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          token.Name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Colors.white),
                        ),
                        const SizedBox(
                            width: double.infinity,
                            height: 16,
                            child: Divider(
                              thickness: 4,
                              color: Colors.white,
                              height: 16,
                            )),
                        _getTokenColoredText(token, 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              "Description:",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(token.Description,
                      style: const TextStyle(fontSize: 24, color: Colors.white))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getImageUrl(String tokenId) {
    return "https://cdn-icons-png.flaticon.com/512/906/906349.png"; // Placeholder
  }
}
