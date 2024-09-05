import 'package:flutter/material.dart';
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
          const VerticalDivider(
            thickness: 4,
            width: 32,
            indent: 20,
            endIndent: 0,
            color: Colors.white,
          ),
          Expanded(
              flex: 10,
              child: Center(
                child: _buildGameInfoGuard(context),
              ))
        ],
      ),
    );
  }

  Widget _buildGameInfoGuard(BuildContext context) {
    return Center(
        child: _selectedGame == null
            ? const RoundedContainer(
                width: null,
                height: null,
                padding: EdgeInsets.all(16),
                borderColor: Colors.white,
                child: Text(
                  "Select your game first!",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ))
            : RoundedContainer(
                width: null,
                height: null,
                padding: const EdgeInsets.all(16),
                borderColor: Colors.white,
                child: _buildGameInfo(context),
              ));
  }

  Widget _buildGameInfo(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  _selectedGame!.path,
                  width: 256,
                  height: 256,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 256, // Match the height of the image
                  child: VerticalDivider(
                    thickness: 4,
                    width: 32,
                    color: Colors.white,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _selectedGame!.name,
                      style: const TextStyle(
                          fontSize: 92,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
            flex: 7,
            child: Row(
              children: [
                Expanded(
                    flex: 6,
                    child: ImageCarousel(imagePaths: _selectedGame!.screens)),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedContainer(
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.all(28.0),
                        borderColor: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Description: ",
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Flexible(
                              child: SingleChildScrollView(
                                child: Text(_selectedGame!.desc,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ),
                            ),
                          ],
                        )),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
