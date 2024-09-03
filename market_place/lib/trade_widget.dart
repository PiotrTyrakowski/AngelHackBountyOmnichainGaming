import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:market_place/contract_info.dart';
import 'package:market_place/item_preview_widget.dart';
import 'drag_table.dart';
import 'user_account.dart';
import 'rounded_container.dart';
import 'login_first_widget.dart';
import 'friends.dart';
import 'friend_widget.dart';
import 'games/game_blank_widget.dart';
import 'games/game_widgets.dart';
import 'dart:collection';
import 'nft_token.dart';

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
  final ContractInfo _info;

  const TradeWidget({super.key, required ContractInfo info}) : _info = info;

  @override
  _TradeWidgetState createState() => _TradeWidgetState();
}

class _TradeWidgetState extends State<TradeWidget> {
  FriendInfo _selectedFriend = Friends[0];
  BlankGameInfo _selectedGame = Games[0];
  String _selectedItemPickerName = "You";

  final DraggableTableManager _manager = DraggableTableManager();

  HashMap<String, List<NftToken>> _userTokens = UserAccount().GetOwnedNfts();
  HashMap<String, List<NftToken>> _selectedFriendTokens =
      Friends[0].GetOwnedNfts();

  List<NftToken> _equipmentItems = [];
  String _equipmentOwner = UserAccount().etherId;

  List<NftToken> _userSelectedItems = [];
  List<NftToken> _friendSelectedItems = [];

  NftToken? _previewItem;

  @override
  Widget build(BuildContext context) {
    return LoginFirstWidget(child: _buildSelectFriendWidget(context));
  }

  @override
  void initState() {
    widget._info.senderId = UserAccount().etherId;
    widget._info.targetTokens = _friendSelectedItems;
    widget._info.senderTokens = _userSelectedItems;
    widget._info.targetId = _selectedFriend.userId;

    super.initState();
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
                        _selectedFriend = friendInfo;
                        _selectedFriendTokens = friendInfo.GetOwnedNfts();

                        _userSelectedItems = [];
                        _friendSelectedItems = [];
                        _userTokens = UserAccount().GetOwnedNfts();

                        _selectedGame = Games[0];
                        _selectedItemPickerName = "You";

                        _equipmentOwner = UserAccount().etherId;
                        _equipmentItems = [];

                        widget._info.targetTokens = _friendSelectedItems;
                        widget._info.senderTokens = _userSelectedItems;
                        widget._info.targetId = _selectedFriend.userId;
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
        child: _selectedFriend == null
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

  void _update_preview(NftToken token) {
    setState(() {
      _previewItem = token;
    });
  }

  Widget _buildPreviewWidgetInner(BuildContext context) {
    return _previewItem == null
        ? const Flexible(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: RoundedContainer(
                    width: null,
                    height: null,
                    padding: EdgeInsets.all(16),
                    borderColor: Colors.white,
                    child: Text(
                      "Click on any item first!",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
          )
        : Flexible(child: NftTokenPreview(token: _previewItem!));
  }

  Widget _buildPreviewWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedContainer(
          borderColor: Colors.white,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTitleBar(context, "Item preview"),
              _buildPreviewWidgetInner(context)
            ],
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
                onCardClick: _update_preview,
                OwnerId: UserAccount().etherId,
                items: _friendSelectedItems,
                columnsCount: 2,
                onItemsChanged: (updatedItems) {},
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
                _buildTitleBar(context, "${_selectedFriend!.name}'s items"),
                Flexible(
                  child: DraggableTableWidget(
                    onCardClick: _update_preview,
                    OwnerId: _selectedFriend.userId,
                    items: _userSelectedItems,
                    columnsCount: 2,
                    onItemsChanged: (updatedItems) {},
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
                segments: [
                  const ButtonSegment(value: 'You', label: Text('You')),
                  ButtonSegment(
                      value: _selectedFriend.name,
                      label: Text(_selectedFriend.name)),
                ],
                selected: <String>{_selectedItemPickerName},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedItemPickerName = newSelection.first;

                    if (_selectedItemPickerName == "You") {
                      _equipmentOwner = UserAccount().etherId;
                      _equipmentItems =
                          _userTokens.containsKey(_selectedGame.name)
                              ? _userTokens[_selectedGame.name]!
                              : [];
                    } else {
                      _equipmentItems =
                          _selectedFriendTokens.containsKey(_selectedGame.name)
                              ? _selectedFriendTokens[_selectedGame.name]!
                              : [];
                      _equipmentOwner = _selectedFriend.userId;
                    }
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

                      if (_selectedItemPickerName == "You") {
                        _equipmentItems =
                            _userTokens.containsKey(_selectedGame.name)
                                ? _userTokens[_selectedGame.name]!
                                : [];
                      } else {
                        _equipmentItems = _selectedFriendTokens
                                .containsKey(_selectedGame.name)
                            ? _selectedFriendTokens[_selectedGame.name]!
                            : [];
                      }
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
                onCardClick: _update_preview,
                OwnerId: _equipmentOwner,
                items: _equipmentItems,
                columnsCount: 2,
                onItemsChanged: (updatedItems) {
                  _userTokens[_selectedGame.name] = updatedItems;
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
