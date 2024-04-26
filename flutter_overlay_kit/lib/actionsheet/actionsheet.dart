/*
 * @Author: dvlproad
 * @Date: 2022-07-25 19:38:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 13:54:02
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_button_base/flutter_button_base.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'; // 为了取button

import '../theme/overlay_sheet_theme_model.dart';
import '../theme/overlay_theme_manager.dart';
import './bottomwidget.dart';
// import './components/actionsheet_item.dart';

import '../../flutter_overlay_kit_adapt.dart';

class ActionSheetWidget extends StatefulWidget {
  final String? title;
  final TextStyle? titleTextStyle;
  final void Function()? onCancel;
  final void Function(int selectedIndex) onConfirm;

  final List<String> itemTitles;
  final int? currentSelectedIndex;
  final void Function(int selectedIndex)? onItemTap;

  ActionSheetWidget({
    Key? key,
    this.title,
    this.titleTextStyle,
    this.onCancel,
    required this.onConfirm,
    required this.itemTitles,
    this.onItemTap,
    this.currentSelectedIndex,
  }) : super(key: key);

  @override
  _ActionSheetWidgetState createState() => _ActionSheetWidgetState();
}

class _ActionSheetWidgetState extends State<ActionSheetWidget> {
  double itemExtent = 40;
  double extralHeight = 30; // 为了让滚轮能显示，额外自己添加的高度

  // ignore: unused_field
  late int _selectedIndex;
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
      titleTextStyle: widget.titleTextStyle,
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

  // ignore: non_constant_identifier_names
  Widget get _itemsWidget_useList {
    return ListView.builder(
      padding: EdgeInsets.zero, // 保证可以滚回
      physics: const NeverScrollableScrollPhysics(), // 禁止上下滑动
      itemCount: widget.itemTitles.length,
      itemExtent: itemExtent,
      itemBuilder: (BuildContext context, int index) {
        return _renderItem(index);
      },
    );
  }

  Widget _renderItem(int index) {
    String title = widget.itemTitles[index];

    CJOverlaySheetThemeModel sheetThemeModel =
        CJBaseOverlayThemeManager().sheetThemeModel;
    TextStyle titleStyle = TextStyle(
      fontFamily: 'PingFang SC',
      fontWeight: FontWeight.bold,
      fontSize: 15.f_pt_cj,
    );
    return CJButton(
      height: sheetThemeModel.cellRowHeight,
      childMainAxisAlignment: MainAxisAlignment.center,
      title: title,
      titleStyle: titleStyle,
      normalConfig: sheetThemeModel.itemButtonConfig,
      onPressed: () {
        widget.onItemTap?.call(index);
      },
    );
  }
}
