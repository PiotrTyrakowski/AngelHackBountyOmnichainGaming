import 'package:flutter/material.dart';

class BlankGameInfo {
  final String name;
  final String path;

  const BlankGameInfo({required this.name, required this.path});
}

class GameBlankWidget extends StatelessWidget {
  final BlankGameInfo _info;

  const GameBlankWidget({super.key, required BlankGameInfo info})
      : _info = info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Use all available horizontal space
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                _info.path,
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
    );
  }
}
