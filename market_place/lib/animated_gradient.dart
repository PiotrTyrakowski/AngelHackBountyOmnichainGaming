import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedGradientFont extends StatefulWidget {
  final String text;
  final double fontSize;

  const AnimatedGradientFont({
    Key? key,
    required this.text,
    this.fontSize = 40,
  }) : super(key: key);

  @override
  _AnimatedGradientFontState createState() => _AnimatedGradientFontState();
}

class _AnimatedGradientFontState extends State<AnimatedGradientFont>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.blue,
              Colors.green,
              Colors.red,
              Colors.blue,
            ],
            stops: [
              0,
              0.33,
              0.67,
              1,
            ],
            transform: GradientRotation(_animation.value),
            tileMode: TileMode.decal,
          ).createShader(bounds),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.fontSize,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

// Usage example:
// AnimatedGradientFont(text: "Hello, Gradient!")