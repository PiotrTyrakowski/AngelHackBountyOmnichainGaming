import 'package:flutter/material.dart';
import 'drag_table.dart';
import 'user_account.dart';
import 'rounded_container.dart';
import 'login_first_widget.dart';
import 'friends.dart';
import 'friend_widget.dart';
import 'games/game_blank_widget.dart';
import 'games/game_widgets.dart';

class SmallGameInfo extends StatelessWidget {
  final BlankGameInfo _info;

  BlankGameInfo get info => _info;

  const SmallGameInfo({super.key, required BlankGameInfo info}) : _info = info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(children: [
        Image.asset(
          _info.path,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          width: 20,
          height: 32,
        ),
        Text(
          _info.name,
          style: const TextStyle(fontSize: 12),
        ),
      ]),
    );
  }
}

class TradeWidget extends StatefulWidget {
  const TradeWidget({super.key});

  @override
  _TradeWidgetState createState() => _TradeWidgetState();
}

class _TradeWidgetState extends State<TradeWidget> {
  String? _selectedFriendName;
  String _selectedItemPickerName = "You";
  BlankGameInfo _selectedGame = Games[0];
  final DraggableTableManager _manager = DraggableTableManager();

  @override
  Widget build(BuildContext context) {
    return LoginFirstWidget(child: _buildSelectFriendWidget(context));
  }

  Widget _buildSelectFriendWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: Friends.map((friendInfo) => FriendWidget(
                    info: friendInfo,
                    onClick: () {
                      setState(() {
                        _selectedFriendName = friendInfo.name;
                      });
                    },
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
                child: _buildTradeItemsWrapperWidget(context),
              ))
        ],
      ),
    );
  }

  Widget _buildTradeItemsWrapperWidget(BuildContext context) {
    return Center(
        child: _selectedFriendName == null
            ? const RoundedContainer(
                width: null,
                height: null,
                padding: EdgeInsets.all(16),
                borderColor: Colors.white,
                child: Text(
                  "Select your friend first!",
                  style: TextStyle(fontSize: 18),
                ))
            : _buildTradeItemsWidget(context));
  }

  final Widget blankBlue = Container(
    color: Colors.blue,
    width: double.infinity,
    height: double.infinity,
  );

  final Widget blankWhite = Container(
    color: Colors.white,
    width: double.infinity,
    height: double.infinity,
  );

  Widget _buildPreviewWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedContainer(
          borderColor: Colors.white,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [_buildTitleBar(context, "Item preview")],
          )),
    );
  }

  Widget _buildMyChosenItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedContainer(
        borderColor: Colors.white,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTitleBar(context, "Your items"),
            Flexible(
              child: DraggableTableWidget(
                items: [
                  'Item 1',
                  'Item 2',
                  'Item 3',
                  'Item 1',
                  'Item 2',
                  'Item 3',
                  'Item 1',
                  'Item 2',
                  'Item 3',
                  'Item 1',
                  'Item 2',
                  'Item 3',
                  'Item 1',
                  'Item 2',
                  'Item 3',
                  'Item 1',
                  'Item 2',
                  'Item 3',
                  'Item 1',
                  'Item 2',
                  'Item 3'
                ],
                columnsCount: 3,
                onItemsChanged: (updatedItems) {
                  print('First table updated: $updatedItems');
                },
                manager: _manager,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendItems(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RoundedContainer(
            borderColor: Colors.white,
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildTitleBar(context, "$_selectedFriendName's items"),
                Flexible(
                  child: DraggableTableWidget(
                    items: ['Item A', 'Item B', 'Item C'],
                    columnsCount: 3,
                    onItemsChanged: (updatedItems) {
                      print('Second table updated: $updatedItems');
                    },
                    manager: _manager,
                  ),
                ),
              ],
            )));
  }

  Column _buildTitleBar(BuildContext context, String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(
            height: 12,
            width: null,
            child: Divider(
              color: Colors.white,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ))
      ],
    );
  }

  Widget _buildItemPicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedContainer(
        borderColor: Colors.white,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTitleBar(context, "Equipment"),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'You', label: Text('You')),
                  ButtonSegment(value: 'Johny', label: Text('Johny')),
                ],
                selected: <String>{_selectedItemPickerName},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedItemPickerName = newSelection.first;
                  });
                },
              ),
            ),
            const SizedBox(height: 12.0),
            SizedBox(
              width: double.infinity,
              child: DropdownButton<BlankGameInfo>(
                value: _selectedGame,
                hint: const Text('Select a game'),
                items: Games.map<DropdownMenuItem<BlankGameInfo>>(
                    (BlankGameInfo game) {
                  return DropdownMenuItem<BlankGameInfo>(
                    value: game,
                    child: SmallGameInfo(info: game),
                  );
                }).toList(),
                onChanged: (BlankGameInfo? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedGame = newValue;
                    });
                  }
                },
              ),
            ),
            const SizedBox(
              height: 12,
              width: double.infinity,
              child: Divider(
                color: Colors.white,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
            ),
            Flexible(
              child: DraggableTableWidget(
                items: ['Item A1', 'Item A2', 'Item A3'],
                columnsCount: 3,
                onItemsChanged: (updatedItems) {
                  print('Second table updated: $updatedItems');
                },
                manager: _manager,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeItemsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedContainer(
        width: double.infinity,
        height: double.infinity,
        borderColor: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildItemPicker(context),
                  ),
                  Expanded(
                    flex: 4,
                    child: _buildMyChosenItems(context),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildPreviewWidget(context),
                  ),
                  Expanded(
                    flex: 4,
                    child: _buildFriendItems(context),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
