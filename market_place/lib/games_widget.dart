import 'package:flutter/material.dart';
import 'user_account.dart';
import 'rounded_container.dart';
import 'games/game_blank_widget.dart';
import 'games/game_widgets.dart';

class GamesWidget extends StatefulWidget {
  const GamesWidget({Key? key}) : super(key: key);

  @override
  _GamesWidgetState createState() => _GamesWidgetState();
}

class _GamesWidgetState extends State<GamesWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: UserAccount().IsLogged()
            ? const RoundedContainer(
            width: null,
            height: null,
            padding: EdgeInsets.all(16),
            child: Text(
              "First you need to login!",
              style: TextStyle(fontSize: 24),
            ))
            : _buildGamesLib(context));
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
              children:
              Games.map((game) => GameBlankWidget(info: game)).toList(),
            ),),
          const Expanded(
            flex: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VerticalDivider(
                thickness: 4,
                width: 32,
                indent: 20,
                endIndent: 0,
                color: Colors.white,
                          ),
              ],
            ),)
        ],
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context){
    return Container();
  }
}
