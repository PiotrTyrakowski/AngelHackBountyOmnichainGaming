import 'package:flutter/material.dart';
import 'rounded_container.dart';
import 'login_first_widget.dart';
import 'swaps/swap_blank_widget.dart';
import 'swaps/swap_widgets.dart';

class OffersWidget extends StatefulWidget {
  const OffersWidget({Key? key}) : super(key: key);

  @override
  _OffersWidgetState createState() => _OffersWidgetState();
}

class _OffersWidgetState extends State<OffersWidget> {
  String? _selectedSwapId;

  @override
  Widget build(BuildContext context) {
    return LoginFirstWidget(child: _buildGamesLib(context));
  }

  Widget _buildGamesLib(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: swaps.map((swap) => SwapBlankWidget(
                    info: swap,
                    onClick: () {
                      setState(() {
                        _selectedSwapId = swap.contractId;
                      });
                    },
                    onAccept: () => {},
                    onDecline: () => {}
                  )).toList(),
            ),
          ),
          const VerticalDivider(
            thickness: 4,
            width: 32,
            indent: 20,
            endIndent: 0,
            color: Colors.white,
          ),
          Expanded(
              flex: 10,
              child: Center(
                child: _swapInfo(context),
              ))
        ],
      ),
    );
  }

    Widget _swapInfo(BuildContext context) {
    return Center(
        child: _selectedSwapId == null
            ? const RoundedContainer(
                width: null,
                height: null,
                padding: EdgeInsets.all(16),
                borderColor: Colors.white,
                child: Text(
                  "Select swap offer",
                  style: TextStyle(fontSize: 18),
                ))
            : RoundedContainer(
                width: null,
                height: null,
                padding: const EdgeInsets.all(16),
                borderColor: Colors.white,
                child: Text(
                  "Selected swap offer: $_selectedSwapId",
                  style: const TextStyle(fontSize: 18),
                )));
  }
}
