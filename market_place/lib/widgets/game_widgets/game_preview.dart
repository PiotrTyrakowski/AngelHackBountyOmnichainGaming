import 'package:flutter/material.dart';
import 'package:market_place/widgets/RoundedBox.dart';
import 'package:market_place/widgets/general_purpose/image_carousel.dart';
import '../general_purpose/rounded_container.dart';
import 'game_preview_widget.dart';
import '../../settings/game_info_list.dart';
import '../login/login_first_widget.dart';

class GamePreview extends StatefulWidget {
  final Function(GameInfo) _onChange;

  const GamePreview({super.key, required Function(GameInfo) onChange})
      : _onChange = onChange;

  @override
  _GamePreviewState createState() => _GamePreviewState();
}

class _GamePreviewState extends State<GamePreview> {
  GameInfo? _selectedGame;

  @override
  Widget build(BuildContext context) {
    return LoginFirstWidget(child: _buildGamesLib(context));
  }

  Widget _buildGamesLib(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: RoundedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: Games.map((game) => GameBlankWidget(
                      info: game,
                      onClick: () {
                        setState(() {
                          _selectedGame = game;
                          widget._onChange(game);
                        });
                      },
                    )).toList(),
              ),
            ),
          ),
          const SizedBox(
            width: 22,
          ),
          Expanded(flex: 10, child: _buildGameInfoGuard(context))
        ],
      ),
    );
  }

  Widget _buildGameInfoGuard(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: RoundedBox(
        child: _selectedGame == null
            ? const Center(
                child: Text(
                  "Select your game first!",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              )
            : _buildGameInfo(context),
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    _selectedGame!.path,
                    width: 128,
                    height: 128,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  width: 32,
                ),
                Text(
                  _selectedGame!.name,
                  style: const TextStyle(
                      fontSize: 92,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.white,
              thickness: 2,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ImageCarousel(imagePaths: _selectedGame!.screens),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.white,
              thickness: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_selectedGame!.desc,
                style: const TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
