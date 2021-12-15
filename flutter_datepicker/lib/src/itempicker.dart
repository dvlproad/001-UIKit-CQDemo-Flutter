import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import './pickerheader.dart';

class ItemPickerWidget extends StatefulWidget {
  final String title;
  final void Function() onCancel;
  final void Function(int selectedIndex) onConfirm;

  final List<String> itemTitles;
  final int currentSelectedIndex;

  ItemPickerWidget({
    Key key,
    this.title,
    this.onCancel,
    @required this.onConfirm,
    @required this.itemTitles,
    this.currentSelectedIndex = 0,
  }) : super(key: key);

  @override
  _ItemPickerWidgetState createState() => _ItemPickerWidgetState();
}

class _ItemPickerWidgetState extends State<ItemPickerWidget> {
  int _selectedIndex;
  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.currentSelectedIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> itemWidgets = [];
    for (String itemTitle in widget.itemTitles) {
      Widget itemWidget = _createItem(itemTitle);
      // Widget itemWidget = Container(
      //   color: Colors.red,
      //   child: _createItem(itemTitle),
      // );
      itemWidgets.add(itemWidget);
    }
    double headerHeight = 60;

    double itemExtent = 40;
    double itemWidgetsHeight = widget.itemTitles.length * itemExtent;

    double extralHeight = 30; // 为了让滚轮能显示，额外自己添加的高度

    // MediaQueryData mediaQuery =
    //     MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    // double bottomHeight = mediaQuery.padding.bottom; //这个就是底部的高度
    double bottomHeight = MediaQuery.of(context).padding.bottom;

    return Container(
      height: headerHeight + itemWidgetsHeight + extralHeight + bottomHeight,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          PickerHeader(
            height: headerHeight,
            title: widget.title,
            onCancel: widget.onCancel,
            onConfirm: () {
              if (widget.onConfirm != null) {
                widget.onConfirm(_selectedIndex);
              }
            },
          ),
          Container(
            // width: Adapt.screenW(),
            height: itemWidgetsHeight,
            alignment: Alignment.center,
            child: CupertinoPicker(
              diameterRatio: 1,
              itemExtent: itemExtent,
              selectionOverlay: Container(
                height: itemExtent,
                decoration: const BoxDecoration(
                  color: Color(0x20FF4587),
                ),
              ),
              onSelectedItemChanged: (position) {
                setState(() {
                  _selectedIndex = position;
                });
              },
              children: itemWidgets,
            ),
          )
        ],
      ),
    );
  }

  Widget _createItem(String title) {
    return Center(
      child: Text(
        title ?? "",
        style: TextStyle(
          color: Color(0xFF222222),
          fontFamily: 'PingFang SC',
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
