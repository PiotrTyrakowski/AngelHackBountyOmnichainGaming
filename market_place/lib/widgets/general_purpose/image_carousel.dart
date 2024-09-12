import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imagePaths;

  const ImageCarousel({super.key, required this.imagePaths});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;

  void _previousImage() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % widget.imagePaths.length;
    });
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.imagePaths.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          widget.imagePaths[_currentIndex],
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _previousImage,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            const SizedBox(width: 16.0),
            IconButton(
              onPressed: _nextImage,
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
