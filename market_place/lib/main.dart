import 'package:flutter/material.dart';
import 'pages/game_lib_page.dart';
import 'pages/login_page.dart';
import 'pages/trade_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const mainPage = GameLibPage();

    return MaterialApp(
      title: 'DEGames',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => mainPage,
        '/games': (context) => mainPage,
        '/trades': (context) => const TradePage(),
        '/login': (context) => const LoginPage()
      },
    );
  }
}
