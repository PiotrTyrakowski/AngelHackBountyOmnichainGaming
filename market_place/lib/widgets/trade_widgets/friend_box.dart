import 'package:flutter/material.dart';
import 'package:market_place/models/friend_info.dart';

class FriendBox extends StatelessWidget {
  final FriendInfo _info;
  final VoidCallback? onClick;

  const FriendBox({
    super.key,
    required FriendInfo info,
    this.onClick,
  }) : _info = info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Use all available horizontal space
      child: InkWell(
        onTap: onClick,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  _info.icon,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 64, // Match the height of the image
                  child: VerticalDivider(
                    thickness: 4,
                    width: 32,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _info.name,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
