@JS()
library my_lib;

import 'package:flutter/material.dart';
import 'package:market_place/settings/margins.dart';
import 'package:js/js.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util' as jsu;

import 'package:market_place/user_account.dart';

@JS()
external connectAndGetAccount();

class WebPageBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<String> pages;

  const WebPageBar({
    super.key,
    required this.title,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        "DEGames: $title",
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
      ),
      actions: pages.map((page) => _buildButton(context, page)).toList(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
        child: Container(
          color: Colors.white,
          height: 2.0,
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizonstalMargin),
      child: TextButton(
        onPressed: () =>
            label != 'Login' ? _navigateToPage(context, label) : _loginUser(),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, String label) {
    String route = '/${label.toLowerCase()}';
    Navigator.of(context).pushNamed(route);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);

  Future<void> _loginUser() async {
    try {
      var jsPromise = connectAndGetAccount();
      String result = await jsu.promiseToFuture<String>(jsPromise);

      if (result != "FAIL") {
        UserAccount().OnLogin(result);
      } else {
        throw Exception("connection to metamask failed");
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }
}
