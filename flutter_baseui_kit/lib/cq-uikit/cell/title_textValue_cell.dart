// 包含标题文本title，值文本textValue(文本前可设置是否添加点来突出)、箭头类型固定为向右 的视图
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './title_commonValue_cell.dart';

class BJHTitleTextValueCell extends StatelessWidget {
  final String title; // 标题
  final String textValue; // 值文本（此值为空时候，视图会自动隐藏）
  bool textThemeIsRed = false; // 值文本是否是红色主题(不设置即默认灰色)
  bool addDotForValue = false; // 是否在value前添加·点(不设置即默认不添加，如果添加则点的颜色和文本颜色一直)
  void Function() onTap; // 点击事件

  BJHTitleTextValueCell({
    Key key,
    this.title,
    this.textValue,
    this.textThemeIsRed,
    this.addDotForValue,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BJHTitleCommonValueTableViewCell(
      title: this.title,
      valueWidget: _textValueWidget(),
      arrowImageType: TableViewCellArrowImageType.arrowRight,
      clickCellCallback: (section, row) {
        this.onTap();
      },
    );
  }

  Widget _textValueWidget() {
    List<Widget> widgets = [];

    if (this.addDotForValue == true) {
      widgets.add(_dot(7));
      widgets.add(SizedBox(width: AdaptCJHelper.setWidth(20)));
    }

    Color textColor =
        this.textThemeIsRed == true ? Color(0xffCD3F49) : Color(0xff999999);
    if (_subText(textColor) != null) {
      widgets.add(_subText(textColor));
    }

    return Row(
      children: widgets,
    );
  }

  // 文本前面的点(一般不添加)
  Widget _dot(double radius) {
    return Container(
      width: 2 * radius.w_cj,
      height: 2 * radius.h_cj,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius.w_cj)),
        border: Border.all(
          color: const Color(0xffCD3F49),
          width: radius.w_cj,
          style: BorderStyle.solid,
        ),
      ),
    );
  }

  // 副文本
  Widget _subText(Color textColor) {
    // 判断是否添加副文本，存在才构建视图
    if (null == this.textValue || this.textValue.length == 0) {
      return null;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        this.textValue ?? '',
        textAlign: TextAlign.right,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontSize: AdaptCJHelper.setWidth(30),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
