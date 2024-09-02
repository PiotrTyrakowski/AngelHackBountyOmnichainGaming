import 'package:flutter/material.dart';
import 'nft_token.dart';
import 'dart:ui' as ui;

class NftTokenPreview extends StatelessWidget {
  final NftToken token;

  const NftTokenPreview({required this.token});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image container
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                // Map tokenId to image url here (replace with your logic)
                getImageUrl(token.TokenId),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Name and details column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name - bold
              Text(
                token.Name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Rarity - with gradient
              Text(
                token.Rarity,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  foreground:  Paint()
                    ..shader = ui.Gradient.linear(
                      0, 1,
                      endOffset,
                      [
                        Colors.red,
                        Colors.yellow,
                      ],
                    )
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                token.Description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Replace this with your logic to get image url based on tokenId
  String getImageUrl(String tokenId) {
    // Replace with your image url logic based on tokenId
    return "https://example.com/image_$tokenId.png"; // Placeholder
  }
}