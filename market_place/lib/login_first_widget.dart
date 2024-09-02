import 'package:flutter/material.dart';
import 'user_account.dart';
import 'rounded_container.dart';

class LoginFirstWidget extends StatelessWidget {
  final Widget _child;

  const LoginFirstWidget({super.key, required Widget child}) : _child = child;

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
            : _child);
  }
}
