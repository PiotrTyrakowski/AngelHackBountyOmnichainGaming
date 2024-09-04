import 'package:flutter/material.dart';
import 'package:market_place/login_widget.dart';
import '../web_page_bar.dart';
import "../pages.dart";

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black87,
      appBar: WebPageBar(
          title: "Login",
          pages: PageList
      ),
      body: Center(
        child: LoginWidget()
      ),
    );
  }
}
