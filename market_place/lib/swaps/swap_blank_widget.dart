import 'package:flutter/material.dart';
import 'package:market_place/contract_info.dart';

class SwapBlankWidget extends StatelessWidget {
  final ContractInfo info;
  final Function(ContractInfo) onDecline;
  final Function(ContractInfo) onAccept;
  final VoidCallback? onClick;

  const SwapBlankWidget({
    super.key,
    required this.info,
    required this.onDecline,
    required this.onAccept,
    this.onClick
  });

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
                      onPressed: (){
                        onDecline(info);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, 
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Decline')
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onAccept(info);
                      },
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
    return "ContractID: ${info.contractId}.\nUser ${info.senderId} proposes swap of user's tokens: ${info.senderTokens.map((token) => token.Name).join(', ')} for your tokens: ${info.targetTokens.map((token) => token.Name).join(', ')}.";
  }
}