import 'package:flutter/material.dart';
import 'package:market_place/rounded_container.dart';
import '../web_page_bar.dart';
import "../pages.dart";
import '../offers_widget.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: const WebPageBar(title: "Offers", pages: PageList),
      body: Padding(
          padding: const EdgeInsets.all(24),
          child: LayoutBuilder(builder: (context, constraints) {
            return RoundedContainer(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                borderColor: Colors.white,
                child: const OffersWidget());
          })),
    );
  }
}