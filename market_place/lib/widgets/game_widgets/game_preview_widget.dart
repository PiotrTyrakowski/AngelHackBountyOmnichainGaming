import 'package:flutter/material.dart';

class GameInfo {
  final String name;
  final String path;
  final String contractId;
  final String desc;
  final String gameLink;
  final List<String> screens;

  const GameInfo(
      {this.name = "",
      this.path = "",
      this.contractId = "",
      this.screens = const [],
      this.desc = "",
      this.gameLink = ""});
}

class GameBlankWidget extends StatelessWidget {
  final GameInfo _info;
  final VoidCallback? onClick;

  const GameBlankWidget({
    super.key,
    required GameInfo info,
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
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    _info.path,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  _info.name,
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
