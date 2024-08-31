import 'package:flutter/material.dart';
import "web_page_bar.dart";
import "pages.dart";

class BlankPage extends StatelessWidget {
  final String title;

  const BlankPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: WebPageBar(
          title: title,
          pages: PageList
      ),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
