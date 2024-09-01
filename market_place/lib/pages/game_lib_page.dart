import 'package:flutter/material.dart';
import 'package:market_place/rounded_container.dart';
import '../web_page_bar.dart';
import "../pages.dart";
import '../games_widget.dart';

class GameLibPage extends StatelessWidget {
  const GameLibPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: const WebPageBar(title: "Games", pages: PageList),
      body: Padding(
          padding: const EdgeInsets.all(24),
          child: LayoutBuilder(builder: (context, constraints) {
            return RoundedContainer(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                borderColor: Colors.white,
                child: const GamesWidget());
          })),
    );
  }
}
