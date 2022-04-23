import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import './images_presuf_badge_base_list.dart';

class FixGridView extends StatefulWidget {
  final double width;
  final double height;
  final bool dragEnable;
  final void Function(int oldIndex, int newIndex) dragCompleteBlock;
  final int itemCount;
  final Widget Function({BuildContext context, int index}) itemBuilder;
  final Widget prefixWidget;
  final Widget suffixWidget;

  final double columnSpacing;
  final double rowSpacing;

  /**< 通过每行可显示的最多列数来设置每个cell的宽度*/
  final int cellWidthFromPerRowMaxShowCount;

  /**< 宽高比（默认1:1,即1/1.0，请确保除数有小数点，否则1/2会变成0，而不是0.5） */
  final double widthHeightRatio;

  FixGridView({
    Key key,
    this.width,
    this.height,
    this.dragEnable, // 是否可以拖动
    this.dragCompleteBlock,
    this.columnSpacing, //水平列间距
    this.rowSpacing, // 竖直行间距
    this.cellWidthFromPerRowMaxShowCount,
    this.widthHeightRatio,
    @required this.itemCount,
    @required this.itemBuilder,
    this.prefixWidget,
    this.suffixWidget,
  })  : assert(itemBuilder != null),
        super(key: key);

  @override
  FixGridViewState createState() => FixGridViewState();
}

class FixGridViewState extends State<FixGridView> {
  List<Widget> _widgets = [];
  bool _isUpdateByDragAction = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (widget.dragCompleteBlock != null) {
      widget.dragCompleteBlock(oldIndex, newIndex);
    }
    // setState(() {
    //   Widget row = _widgets.removeAt(oldIndex);
    //   _widgets.insert(newIndex, row);

    //   _isUpdateByDragAction = true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    double width = widget.width;
    double height = widget.height;

    double mainSpacing = widget.columnSpacing ?? 10;
    double crossSpacing = widget.rowSpacing ?? 10;
    int columnCount = widget.cellWidthFromPerRowMaxShowCount ?? 5;
    // columnCount*itemWidth + (columnCount-1)*mainSpacing = width;
    double itemsWidth = width - (columnCount - 1) * mainSpacing;
    double itemWidth = itemsWidth / columnCount;
    itemWidth = itemWidth.truncateToDouble(); //3.0 //向下取整(返回double)

    double widthHeightRatio = widget.widthHeightRatio ?? 1.0;
    double itemHeight = itemWidth / widthHeightRatio;
    itemHeight = itemHeight.truncateToDouble(); //3.0 //向下取整(返回double)

    if (_isUpdateByDragAction != true) {
      _widgets = [];
      for (var index = 0; index < widget.itemCount; index++) {
        // Widget item = Container(
        //   color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
        //       Random().nextInt(256), 1),
        //   child: Center(child: Text("第$i个")),
        // );
        Widget itemWidget = Container(
          // color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          //     Random().nextInt(256), 1),
          width: itemWidth,
          height: itemHeight,
          // child: Center(child: Text("第$index个")),
          child: widget.itemBuilder(context: context, index: index),
        );
        _widgets.add(itemWidget);
      }
    } else {
      _isUpdateByDragAction = false;
    }

    if (widget.dragEnable == true) {
      var wrap = ReorderableWrap(
        needsLongPressDraggable: true,
        spacing: mainSpacing,
        runSpacing: crossSpacing,
        padding: const EdgeInsets.all(0),
        children: _widgets,
        onReorder: _onReorder,
        onNoReorder: (int index) {
          //this callback is optional
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
        },
        onReorderStarted: (int index) {
          //this callback is optional
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
        },
        footer: widget.suffixWidget == null
            ? null
            : Container(
                // color: Colors.pink,
                width: itemWidth,
                height: itemHeight,
                child: widget.suffixWidget,
              ),
      );

      var column = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          wrap,
          Container(), // 为了让铺满宽
          // ButtonBar(
          //   alignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     IconButton(
          //       iconSize: 50,
          //       icon: Icon(Icons.add_circle),
          //       color: Colors.deepOrange,
          //       padding: const EdgeInsets.all(0.0),
          //       onPressed: () {
          //         var newTile = Icon(Icons.filter_9_plus, size: 22);
          //         setState(() {
          //           _widgets.add(newTile);
          //         });
          //       },
          //     ),
          //     IconButton(
          //       iconSize: 50,
          //       icon: Icon(Icons.remove_circle),
          //       color: Colors.teal,
          //       padding: const EdgeInsets.all(0.0),
          //       onPressed: () {
          //         setState(() {
          //           _widgets.removeAt(0);
          //         });
          //       },
          //     ),
          //   ],
          // ),
        ],
      );

      return Container(
        // color: Colors.green,
        child: column,
      );
    } else {
      return ImagesPreSufBadgeBaseList(
        customGridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          mainAxisSpacing: mainSpacing,
          crossAxisSpacing: crossSpacing,
        ),
        imageCount: widget.itemCount,
        imageItemBuilder: ({context, imageIndex}) {
          return widget.itemBuilder(context: context, index: imageIndex);
        },
        suffixWidget: widget.suffixWidget,
      );
    }
  }
}
