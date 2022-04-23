/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-19 15:57:02
 * @Description: 包含标题文本title，值开关boolValue、箭头类型固定为向右 的视图
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './title_commonValue_cell.dart';

class BJHTitleSwitchValueCell extends StatelessWidget {
  final String title; // 标题
  final bool boolValue; // bool值
  void Function(bool bSwtichValue) onChanged; // swtich值改变的事件

  BJHTitleSwitchValueCell({
    Key key,
    @required this.title,
    @required this.boolValue = false,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BJHTitleCommonValueTableViewCell(
      title: this.title,
      valueWidgetBuilder: (BuildContext context, {bool canExpanded}) =>
          _switchValueWidget(),
      arrowImageType: TableViewCellArrowImageType.none,
    );
  }

  Widget _switchValueWidget() {
    Widget swth = CupertinoSwitch(
      value: this.boolValue,
      onChanged: onChanged,
    );

    return Row(
      children: [swth],
    );
  }
}
