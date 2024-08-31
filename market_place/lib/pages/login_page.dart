import 'package:flutter/material.dart';
import 'package:market_place/login_widget.dart';
import 'package:market_place/rounded_container.dart';
import '../web_page_bar.dart';
import "../pages.dart";

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black38,
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
