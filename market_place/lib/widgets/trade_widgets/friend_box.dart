import 'package:flutter/material.dart';
import 'package:market_place/models/friend_info.dart';
import 'package:market_place/widgets/RoundedBox.dart';

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
    return InkWell(
      onTap: onClick,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  _info.icon,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 32,
              ),
              Text(
                _info.name,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
