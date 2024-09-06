import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_place/models/swap_info.dart';
import 'package:market_place/widgets/trade_widgets/nft_token_preview_box.dart';
import 'package:market_place/models/friend_info.dart';
import 'trade_drag_table.dart';
import '../../user_account.dart';
import '../general_purpose/rounded_container.dart';
import '../login/login_first_widget.dart';
import '../../settings/friends_info_list.dart';
import 'friend_box.dart';
import '../game_widgets/game_preview_widget.dart';
import '../../settings/game_info_list.dart';
import 'dart:collection';
import '../../models/nft_token.dart';

class SmallGameInfo extends StatelessWidget {
  final GameInfo _info;

  GameInfo get info => _info;

  const SmallGameInfo({super.key, required GameInfo info}) : _info = info;

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
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ]),
    );
  }
}

class TradeBox extends StatefulWidget {
  final SwapInfo _info;

  const TradeBox({super.key, required SwapInfo info}) : _info = info;

  @override
  _TradeBoxState createState() => _TradeBoxState();
}

class _TradeBoxState extends State<TradeBox> {
  FriendInfo? _selectedFriend;
  GameInfo _selectedGame = Games[0];
  String _selectedItemPickerName = "You";

  final TradeDragTableManager _manager = TradeDragTableManager();

  Map<String, List<NftToken>> _userTokens = {};
  Map<String, List<NftToken>> _selectedFriendTokens = {};

  List<NftToken> _equipmentItems = [];
  String _equipmentOwner = UserAccount().etherId;

  List<NftToken> _userSelectedItems = [];
  List<NftToken> _friendSelectedItems = [];

  NftToken? _previewItem;

  String _friendId = Friends[0].userId;

  @override
  Widget build(BuildContext context) {
    return LoginFirstWidget(child: _buildSelectFriendWidget(context));
  }

  void _updateOutContract() {
    widget._info.senderId = UserAccount().etherId;
    widget._info.targetTokens = _userSelectedItems;
    widget._info.senderTokens =
        _friendSelectedItems; // TODO: Fix this i swapped target and sender because it was swapped somewhere else
    widget._info.targetId = _selectedFriend!.userId;
  }

  @override
  void initState() {
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
              children: Friends.map((friendInfo) => FriendBox(
                    info: friendInfo,
                    onClick: () async {
                      print("Getting friend nfts");
                      HashMap<String, List<NftToken>> friendsTokens =
                          await friendInfo.GetOwnedNfts();
                      print("Getting user nfts");
                      HashMap<String, List<NftToken>> userTokens =
                          await UserAccount().GetOwnedNfts();
                      setState(() {
                        _selectedFriend = friendInfo;
                        _selectedFriendTokens = friendsTokens;

                        _userSelectedItems = [];
                        _friendSelectedItems = [];
                        _userTokens = userTokens;

                        _selectedGame = Games[0];
                        _selectedItemPickerName = "You";

                        _equipmentOwner = UserAccount().etherId;
                        _equipmentItems = [];

                        _friendId = friendInfo.userId;

                        _updateOutContract();

                        _setEq();
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
                  style: TextStyle(fontSize: 18, color: Colors.white),
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
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
              ),
            ),
          )
        : Flexible(child: NftTokenPreviewBox(token: _previewItem!));
  }

  Widget _buildPreviewWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedContainer(
          borderColor: Colors.white,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(8.0),
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTitleBar(context, "Your items"),
            Flexible(
              child: TradeDragTable(
                blockDrop: false,
                maxItems: 2,
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildTitleBar(context, "${_selectedFriend!.name}'s items"),
                Flexible(
                  child: TradeDragTable(
                    blockDrop: false,
                    maxItems: 2,
                    onCardClick: _update_preview,
                    OwnerId: _friendId,
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
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
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

  void _setEq() {
    if (_selectedItemPickerName == "You") {
      _equipmentOwner = UserAccount().etherId;
      _equipmentItems = _userTokens.containsKey(_selectedGame.name)
          ? _userTokens[_selectedGame.name]!
          : [];
    } else {
      _equipmentItems = _selectedFriendTokens.containsKey(_selectedGame.name)
          ? _selectedFriendTokens[_selectedGame.name]!
          : [];
      _equipmentOwner = _selectedFriend!.userId;
    }
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
              child: CupertinoSlidingSegmentedControl<String>(
                backgroundColor: CupertinoColors.systemGrey2,
                groupValue: _selectedItemPickerName,
                onValueChanged: (String? value) {
                  setState(() {
                    if (value != null) {
                      _selectedItemPickerName = value;
                      _setEq();
                    }
                  });
                },
                children: <String, Widget>{
                  "You": const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'You',
                      style: TextStyle(color: CupertinoColors.black),
                    ),
                  ),
                  _selectedFriend!.name: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _selectedFriend!.name,
                      style: const TextStyle(color: CupertinoColors.black),
                    ),
                  )
                },
              ),
            ),
            const SizedBox(height: 12.0),
            SizedBox(
              width: double.infinity,
              child: DropdownButton<GameInfo>(
                dropdownColor: Colors.black54,
                value: _selectedGame,
                hint: const Text('Select a game'),
                items: Games.map<DropdownMenuItem<GameInfo>>((GameInfo game) {
                  return DropdownMenuItem<GameInfo>(
                    value: game,
                    child: SmallGameInfo(info: game),
                  );
                }).toList(),
                onChanged: (GameInfo? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedGame = newValue;
                      _setEq();
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
              child: TradeDragTable(
                blockDrop: false,
                maxItems: 9999,
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
