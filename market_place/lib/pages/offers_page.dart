import 'package:flutter/material.dart';
import 'package:market_place/widgets/general_purpose/rounded_container.dart';
import 'package:market_place/widgets/web_page_bar.dart';
import "../settings/pages_list.dart";
import '../widgets/trade_widgets/offers_widget.dart';

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
            return const OffersWidget();
          })),
    );
  }
}
