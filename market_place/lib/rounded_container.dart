import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;
  final Color backgroundColor; // Renamed to avoid confusion with borderColor
  final Color borderColor; // Added for border color
  final double borderRadius;
  final double borderWidth; // Added for border width

  const RoundedContainer({
    super.key,
    required this.width,
    required this.height,
    this.child,
    this.backgroundColor = Colors.transparent, // Background color parameter
    this.borderColor = Colors.black, // Border color parameter
    this.borderRadius = 8.0,
    this.borderWidth = 2.0, // Border width parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor, // Use background color for the background
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor, // Set the border color
          width: borderWidth, // Set the border width
        ),
      ),
      child: child,
    );
  }
}
