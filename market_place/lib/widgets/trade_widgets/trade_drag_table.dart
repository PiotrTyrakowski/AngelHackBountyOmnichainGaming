import 'package:flutter/material.dart';
import 'package:market_place/widgets/general_purpose/animated_gradient_text.dart';

import '../../models/nft_token.dart';

class TradeDragTableManager {
  final List<_TradeDragTableState> _tables = [];

  void registerTable(_TradeDragTableState table) {
    _tables.add(table);
  }

  void unregisterTable(_TradeDragTableState table) {
    _tables.remove(table);
  }

  void moveItem(NftToken item, _TradeDragTableState sourceTable,
      _TradeDragTableState targetTable) {
    if (sourceTable != targetTable) {
      sourceTable.removeItem(item);
      targetTable.addItem(item);
    }
  }
}

class TradeDragTable extends StatefulWidget {
  final List<NftToken> items;
  final int columnsCount;
  final Function(List<NftToken>) onItemsChanged;
  final TradeDragTableManager manager;
  final String OwnerId;
  final Function(NftToken) onCardClick;
  final bool blockDrop;
  final int maxItems;

  const TradeDragTable(
      {super.key,
      required this.OwnerId,
      required this.items,
      required this.columnsCount,
      required this.onItemsChanged,
      required this.manager,
      required this.onCardClick,
      required this.blockDrop,
      required this.maxItems});

  @override
  _TradeDragTableState createState() => _TradeDragTableState();
}

class _TradeDragTableState extends State<TradeDragTable>
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
            onAcceptWithDetails: (draggedItem) {
              _handleItemDrop(draggedItem.data);
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
    return AnimatedGradientText(text: "Legendary", fontSize: font);
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
                      ),
                      Text(
                        token.Name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: _getTokenColoredText(token, 28),
                  )
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
    if (widget.blockDrop ||
        draggedItem.OwnerId.toLowerCase() != widget.OwnerId.toLowerCase() ||
        widget.items.length >= widget.maxItems) {
      return;
    }

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
