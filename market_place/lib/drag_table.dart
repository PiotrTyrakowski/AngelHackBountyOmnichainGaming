import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:market_place/animated_gradient.dart';
import 'package:market_place/rounded_container.dart';

import 'nft_token.dart';

class DraggableTableManager {
  final List<_DraggableTableWidgetState> _tables = [];

  void registerTable(_DraggableTableWidgetState table) {
    _tables.add(table);
  }

  void unregisterTable(_DraggableTableWidgetState table) {
    _tables.remove(table);
  }

  void moveItem(NftToken item, _DraggableTableWidgetState sourceTable,
      _DraggableTableWidgetState targetTable) {
    if (sourceTable != targetTable) {
      sourceTable.removeItem(item);
      targetTable.addItem(item);
    }
  }
}

class DraggableTableWidget extends StatefulWidget {
  final List<NftToken> items;
  final int columnsCount;
  final Function(List<NftToken>) onItemsChanged;
  final DraggableTableManager manager;
  final String OwnerId;
  final Function(NftToken) onCardClick;

  const DraggableTableWidget(
      {super.key,
      required this.OwnerId,
      required this.items,
      required this.columnsCount,
      required this.onItemsChanged,
      required this.manager,
      required this.onCardClick});

  @override
  _DraggableTableWidgetState createState() => _DraggableTableWidgetState();
}

class _DraggableTableWidgetState extends State<DraggableTableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    widget.manager.registerTable(this);

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    widget.manager.unregisterTable(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cellWidth = constraints.maxWidth / widget.columnsCount;
        double cellHeight = 100;

        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: DragTarget<NftToken>(
            builder: (context, candidateData, rejectedData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    for (int rowIndex = 0;
                        rowIndex <
                            (widget.items.length / widget.columnsCount).ceil();
                        rowIndex++)
                      Row(
                        children: [
                          for (int columnIndex = 0;
                              columnIndex < widget.columnsCount &&
                                  (rowIndex * widget.columnsCount +
                                          columnIndex) <
                                      widget.items.length;
                              columnIndex++)
                            _buildDraggableItem(
                                widget.items[rowIndex * widget.columnsCount +
                                    columnIndex],
                                cellWidth,
                                cellHeight),
                        ],
                      ),
                  ],
                ),
              );
            },
            onAccept: (draggedItem) {
              _handleItemDrop(draggedItem);
            },
          ),
        );
      },
    );
  }

  static Widget _getCommonText(double fontSize) {
    return Text(
      "Common",
      style: TextStyle(fontSize: fontSize),
    );
  }

  static Widget _getRareText(double fontSize) {
    return Text(
      "Rare",
      style: TextStyle(fontSize: fontSize, color: Colors.blue),
    );
  }

  static Widget _getMegaRareText(double fontSize) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.purple.shade300,
          Colors.purple.shade700,
        ],
      ).createShader(bounds),
      child: Text(
        "Mega Rare",
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _getLegendary(double font) {
    return AnimatedGradientFont(text: "Legendary", fontSize: font);
  }

  static const Map<String, Widget Function(double)> _rarityMap = {
    "COMMON": _getCommonText,
    "RARE": _getRareText,
    "MEGA RARE": _getMegaRareText,
    "LEGENDARY": _getLegendary
  };

  Widget _getTokenColoredText(NftToken token, double fontSize) {
    return _rarityMap[token.Rarity.toUpperCase()]!(fontSize);
  }

  static const Map<String, Color> _colors = {
    "BLUE": Colors.blue,
    "GREEN": Colors.green,
    "ORANGE": Colors.orange,
    "PINK": Colors.pink,
    "PURPLE": Colors.purple,
    "RED": Colors.red,
    "YELLOW": Colors.yellow
  };

  Color _getTokenColor(NftToken token) {
    String first = token.Name.split(' ')[0].toUpperCase();

    if (!_colors.containsKey(first)) {
      return Colors.red;
    }

    return _colors[first]!;
  }

  Widget _buildTokenCard(NftToken token, double cellWidth, double cellHeight) {
    return GestureDetector(
      onTap: () {
        widget.onCardClick(token);
      },
      child: Container(
          width: cellWidth,
          height: cellHeight,
          padding: const EdgeInsets.all(1.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 40,
                          height: 40,
                          child: Container(
                              decoration: BoxDecoration(
                            color: _getTokenColor(token),
                            borderRadius: BorderRadius.circular(8),
                          ))),
                      const SizedBox(
                        height: 40,
                        width: 16,
                        child:
                            VerticalDivider(thickness: 2, color: Colors.black),
                      ),
                      Text(
                        token.Name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Center(
                      child: _getTokenColoredText(token, 28),
                    ),
                  ))
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildDraggableItem(
      NftToken item, double cellWidth, double cellHeight) {
    return Draggable<NftToken>(
      data: item,
      feedback: Material(
        elevation: 4.0,
        child: _buildTokenCard(item, cellWidth, cellHeight),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildTokenCard(item, cellWidth, cellHeight),
      ),
      child: _buildTokenCard(item, cellWidth, cellHeight),
    );
  }

  void _handleItemDrop(NftToken draggedItem) {
    // if (widget.OwnerId == "" || draggedItem.OwnerId != widget.OwnerId) {
    //   return;
    // }

    final sourceTable = widget.manager._tables
        .firstWhere((table) => table.widget.items.contains(draggedItem));
    if (sourceTable != this) {
      widget.manager.moveItem(draggedItem, sourceTable, this);
      setState(() {
        widget.onItemsChanged(widget.items);
      });
    }
  }

  void removeItem(NftToken item) {
    setState(() {
      widget.items.remove(item);
      widget.onItemsChanged(widget.items);
    });
  }

  void addItem(NftToken item) {
    setState(() {
      widget.items.add(item);
      widget.onItemsChanged(widget.items);
    });
  }

  List<String> getItems() {
    return List.from(widget.items);
  }
}
