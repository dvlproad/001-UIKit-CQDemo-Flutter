import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import './bottomwidget.dart';

class ItemPickerWidget extends StatefulWidget {
  final String title;
  final void Function() onCancel;
  final void Function(int selectedIndex) onConfirm;

  final List<String> itemTitles;
  final int currentSelectedIndex;
  final void Function(int selectedIndex) onItemTap;

  ItemPickerWidget({
    Key key,
    this.title,
    this.onCancel,
    @required this.onConfirm,
    @required this.itemTitles,
    this.onItemTap,
    this.currentSelectedIndex = 0,
  }) : super(key: key);

  @override
  _ItemPickerWidgetState createState() => _ItemPickerWidgetState();
}

class _ItemPickerWidgetState extends State<ItemPickerWidget> {
  double itemExtent = 40;
  double extralHeight = 30; // 为了让滚轮能显示，额外自己添加的高度

  int _selectedIndex;
  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.currentSelectedIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    double itemWidgetsHeight = widget.itemTitles.length * itemExtent;

    return BottomWidget(
      title: widget.title,
      middleContentWidget: _itemsWidget_useList,
      middleContentWidgetHeight: itemWidgetsHeight,
      onCancel: widget.onCancel,
      // onConfirm: () {
      //   if (widget.onConfirm != null) {
      //     widget.onConfirm(_selectedIndex);
      //   }
      // },
    );
  }

  Widget get _itemsWidget_userPicker {
    List<Widget> itemWidgets = [];
    int count = widget.itemTitles.length;
    for (int i = 0; i < count; i++) {
      Widget itemWidget = _createItem(i);
      itemWidgets.add(itemWidget);
    }

    return CupertinoPicker(
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
    );
  }

  Widget get _itemsWidget_useList {
    return ListView.builder(
      padding: EdgeInsets.zero, // 保证可以滚回
      itemCount: widget.itemTitles.length,
      itemExtent: itemExtent,
      itemBuilder: (BuildContext context, int index) {
        return _createItem(index);
      },
    );
  }

  Widget _createItem(int index) {
    String title = widget.itemTitles[index];
    return GestureDetector(
      onTap: () {
        if (widget.onItemTap != null) {
          widget.onItemTap(index);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            title ?? "",
            style: TextStyle(
              color: Color(0xFF222222),
              fontFamily: 'PingFang SC',
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
