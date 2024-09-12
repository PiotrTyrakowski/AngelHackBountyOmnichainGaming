import 'package:flutter/material.dart';

class RoundedBox extends StatelessWidget {
  final Widget _child;

  const RoundedBox({
    super.key,
    required Widget child,
  }) : _child = child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border:
            Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _child,
      ),
    );
  }
}
