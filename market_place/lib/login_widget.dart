import 'package:flutter/material.dart';
import 'package:market_place/rounded_container.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final parentWidth = constraints.maxWidth;
      final parentHeight = constraints.maxHeight;

      return _buildWidget(parentWidth, parentHeight);
    });
  }

  void _loginUser() {}

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
                      children: [
                        Image.asset('assets/metamask.png'),
                        const Text(
                          "Use your Metamask wallet.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.black),
                        )
                      ],
                    ))),
                Expanded(
                    flex: 3,
                    child: ElevatedButton(
                        onPressed: _loginUser,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black),
                        )))
              ],
            ))));
  }
}
