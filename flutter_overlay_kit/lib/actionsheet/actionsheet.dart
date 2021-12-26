import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import './bottomwidget.dart';
import './components/actionsheet_item.dart';

class ActionSheetWidget extends StatefulWidget {
  final String title;
  final void Function() onCancel;
  final void Function(int selectedIndex) onConfirm;

  final List<String> itemTitles;
  final int currentSelectedIndex;
  final void Function(int selectedIndex) onItemTap;

  ActionSheetWidget({
    Key key,
    this.title,
    this.onCancel,
    @required this.onConfirm,
    @required this.itemTitles,
    this.onItemTap,
    this.currentSelectedIndex = 0,
  }) : super(key: key);

  @override
  _ActionSheetWidgetState createState() => _ActionSheetWidgetState();
}

class _ActionSheetWidgetState extends State<ActionSheetWidget> {
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

  Widget get _itemsWidget_useList {
    return ListView.builder(
      padding: EdgeInsets.zero, // 保证可以滚回
      physics: const NeverScrollableScrollPhysics(), // 禁止上下滑动
      itemCount: widget.itemTitles.length,
      itemExtent: itemExtent,
      itemBuilder: (BuildContext context, int index) {
        return _createItem(index);
      },
    );
  }

  Widget _createItem(int index) {
    String title = widget.itemTitles[index];
    return CJStateTextButton(
      normalTitle: title ?? "",
      onPressed: () {
        if (widget.onItemTap != null) {
          widget.onItemTap(index);
        }
      },
    );
  }
}
