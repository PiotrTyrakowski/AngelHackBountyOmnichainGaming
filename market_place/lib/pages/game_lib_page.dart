import 'package:flutter/material.dart';
import '../web_page_bar.dart';
import "../pages.dart";

class GameLibPage extends StatelessWidget {
  const GameLibPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black38,
      appBar: WebPageBar(
          title: "Games",
          pages: PageList
      )
    );
  }
}
