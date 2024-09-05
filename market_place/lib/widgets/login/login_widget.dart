@JS()
library my_lib; //Not avoid the library annotation

import 'package:js/js.dart';

import 'package:flutter/material.dart';
import 'package:market_place/widgets/general_purpose/rounded_container.dart';
import '../../user_account.dart';
import 'dart:js_util' as jsu;

@JS()
external connectAndGetAccount();

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String? _loginStatus = UserAccount().IsLogged() ? "SUCCESS" : "";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final parentWidth = constraints.maxWidth;
      final parentHeight = constraints.maxHeight;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildWidget(parentWidth, parentHeight),
          if (_loginStatus == "FAIL")
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                "Failed to login",
                style: TextStyle(color: Colors.red, fontSize: 28),
              ),
            ),
        ],
      );
    });
  }

  Future<void> _loginUser() async {
    try {
      var jsPromise = connectAndGetAccount();
      String result = await jsu.promiseToFuture<String>(jsPromise);

      if (result != "FAIL") {
        UserAccount().OnLogin(result);

        setState(() {
          _loginStatus = "SUCCESS";
        });
      } else {
        throw Exception("connection to metamask failed");
      }
    } catch (e) {
      print('Error during login: $e');
      setState(() {
        _loginStatus = "FAIL";
      });
    }
  }

  Widget _buildWidget(double width, double height) {
    return RoundedContainer(
      width: 0.3 * width,
      height: 0.4 * height,
      borderColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/metamask.png'),
                      const Text(
                        "Use your Metamask wallet.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: _loginStatus == "SUCCESS"
                    ? const Text(
                        "Successfully logged in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 38,
                          color: Colors.green,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _loginUser,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
