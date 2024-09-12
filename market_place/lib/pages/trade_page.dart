import 'package:flutter/material.dart';
import 'package:market_place/models/swap_info.dart';
import 'package:market_place/js_adapter/swap_adapter.dart';
import 'package:market_place/widgets/general_purpose/rounded_container.dart';
import 'package:market_place/widgets/trade_widgets/trade_box.dart';
import 'package:market_place/widgets/web_page_bar.dart';
import "../settings/pages_list.dart";

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final SwapInfo _info = SwapInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: const WebPageBar(title: "Trades", pages: PageList),
      body: Padding(
          padding: const EdgeInsets.all(24),
          child: LayoutBuilder(builder: (context, constraints) {
            return TradeBox(info: _info);
          })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _send_contract(context);
        },
        label: const Text('Send', style: TextStyle(color: Colors.black)),
        icon: const Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.white,
      ),
    );
  }

  void _show_dialog(BuildContext context, String title, String desc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(desc),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _send_contract(BuildContext context) async {
    if (_info.senderTokens.isEmpty && _info.targetTokens.isEmpty) {
      _show_dialog(context, 'Contract error',
          'Contract has to contain at least one item');
      return;
    }

    SwapAdapter.IssueSwapUsingInfo(_info);
    _show_dialog(context, 'Notification',
        'Contract sent. A series of blockchain transactions will be initiated. Please wait for the confirmations.');
  }
}
