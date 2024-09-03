import 'package:flutter/material.dart';
import 'package:market_place/contract_info.dart';

class SwapBlankWidget extends StatelessWidget {
  final ContractInfo _info;
  final VoidCallback? onDecline;
  final VoidCallback? onAccept;
  final VoidCallback? onClick;

  const SwapBlankWidget({
    super.key,
    required ContractInfo info,
    this.onDecline,
    this.onAccept,
    this.onClick
  }) : _info = info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Use all available horizontal space
      child: InkWell(
        onTap: onClick,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  infoCoverter(),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: onDecline,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, 
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Decline')
                    ),
                    ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, 
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Accept')
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String infoCoverter()
  {
    return "ContractID: ${_info.contractId}.\nUser ${_info.senderId} proposes swap of user's tokens: ${_info.targetTokens.map((token) => token.Name).join(', ')} for your tokens: ${_info.senderTokens.map((token) => token.Name).join(', ')}.";
  }
}