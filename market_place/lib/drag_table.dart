import 'package:flutter/material.dart';

class DraggableTableManager {
  final List<_DraggableTableWidgetState> _tables = [];

  void registerTable(_DraggableTableWidgetState table) {
    _tables.add(table);
  }

  void unregisterTable(_DraggableTableWidgetState table) {
    _tables.remove(table);
  }

  void moveItem(String item, _DraggableTableWidgetState sourceTable, _DraggableTableWidgetState targetTable) {
    if (sourceTable != targetTable) {
      sourceTable.removeItem(item);
      targetTable.addItem(item);
    }
  }
}

class DraggableTableWidget extends StatefulWidget {
  final List<String> items;
  final int columnsCount;
  final Function(List<String>) onItemsChanged;
  final DraggableTableManager manager;

  const DraggableTableWidget({
    Key? key,
    required this.items,
    required this.columnsCount,
    required this.onItemsChanged,
    required this.manager,
  }) : super(key: key);

  @override
  _DraggableTableWidgetState createState() => _DraggableTableWidgetState();
}

class _DraggableTableWidgetState extends State<DraggableTableWidget> {
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
    widget.manager.registerTable(this);
  }

  @override
  void dispose() {
    widget.manager.unregisterTable(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cellWidth = constraints.maxWidth / widget.columnsCount;
        double cellHeight = 50;

        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: DragTarget<String>(
            builder: (context, candidateData, rejectedData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    for (int rowIndex = 0; rowIndex < (_items.length / widget.columnsCount).ceil(); rowIndex++)
                      Row(
                        children: [
                          for (int columnIndex = 0; columnIndex < widget.columnsCount && (rowIndex * widget.columnsCount + columnIndex) < _items.length; columnIndex++)
                            _buildDraggableItem(_items[rowIndex * widget.columnsCount + columnIndex], cellWidth, cellHeight),
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

  Widget _buildDraggableItem(String item, double cellWidth, double cellHeight) {
    return Draggable<String>(
      data: item,
      child: Container(
        width: cellWidth,
        height: cellHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Text(item),
      ),
      feedback: Material(
        elevation: 4.0,
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.blue.withOpacity(0.5),
          child: Text(item),
        ),
      ),
      childWhenDragging: Container(
        color: Colors.grey.withOpacity(0.5),
      ),
    );
  }

  void _handleItemDrop(String draggedItem) {
    final sourceTable = widget.manager._tables.firstWhere((table) => table._items.contains(draggedItem));
    if (sourceTable != this) {
      widget.manager.moveItem(draggedItem, sourceTable, this);
      setState(() {
        widget.onItemsChanged(_items);
      });
    }
  }

  void removeItem(String item) {
    setState(() {
      _items.remove(item);
      widget.onItemsChanged(_items);
    });
  }

  void addItem(String item) {
    setState(() {
      _items.add(item);
      widget.onItemsChanged(_items);
    });
  }

  List<String> getItems() {
    return List.from(_items);
  }
}
