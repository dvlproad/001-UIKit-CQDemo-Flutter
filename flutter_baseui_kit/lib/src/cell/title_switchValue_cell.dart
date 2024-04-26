/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-24 17:47:22
 * @Description: 包含标题文本title，值开关boolValue、箭头类型固定为向右 的视图
 */
// import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './title_commonValue_cell.dart';

import '../../flutter_baseui_kit_adapt.dart';

class ImageTitleSwitchValueCell extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final String title; // 标题
  final bool boolValue; // bool值
  final void Function(bool bSwtichValue) onChanged; // swtich值改变的事件

  ImageTitleSwitchValueCell({
    Key? key,
    this.padding,
    required this.title,
    this.boolValue = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageTitleCommonValueTableViewCell(
      padding: this.padding,
      title: this.title,
      valueWidgetBuilder: (BuildContext context, {bool canExpanded = false}) =>
          _switchValueWidget(),
      arrowImageType: TableViewCellArrowImageType.none,
    );
  }

  Widget? _switchValueWidget() {
    Widget swth = CupertinoSwitch(
      value: this.boolValue,
      onChanged: onChanged,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [swth],
    );
  }
}
