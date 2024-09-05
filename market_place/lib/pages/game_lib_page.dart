import 'package:flutter/material.dart';
import 'package:market_place/widgets/game_widgets/game_preview_widget.dart';
import 'package:market_place/widgets/general_purpose/rounded_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:market_place/widgets/web_page_bar.dart';
import "../settings/pages_list.dart";
import '../widgets/game_widgets/game_preview.dart';

class GameLibPage extends StatefulWidget {
  const GameLibPage({super.key});

  @override
  State<GameLibPage> createState() => _GameLibPageState();
}

class _GameLibPageState extends State<GameLibPage> {
  GameInfo? _selectedGame;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: const WebPageBar(title: "Games", pages: PageList),
      body: Padding(
          padding: const EdgeInsets.all(24),
          child: LayoutBuilder(builder: (context, constraints) {
            return RoundedContainer(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                borderColor: Colors.white,
                child: GamePreview(
                  onChange: (GameInfo info) {
                    setState(() {
                      _selectedGame = info;
                    });
                  },
                ));
          })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _startGame(context);
        },
        label:
            const Text('Play your game', style: TextStyle(color: Colors.black)),
        icon: const Icon(Icons.play_arrow, color: Colors.black),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _show_dialog(BuildContext context, String title, String desc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(desc),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _startGame(BuildContext context) {
    if (_selectedGame == null) {
      _show_dialog(context, "Error", "First select your game!");
      return;
    }

    launch(_selectedGame!.gameLink);
  }
}
