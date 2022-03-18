// 包含标题文本title，值文本textValue(文本前可设置是否添加点来突出)、箭头类型固定为向右 的视图
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './title_commonValue_cell.dart';
export './title_commonValue_cell.dart' show TableViewCellArrowImageType;
// import '../text/text.dart';

class BJHTitleTextValueCell extends StatelessWidget {
  final double height; // cell 的高度
  final double leftRightPadding; // cell 内容的左右间距

  final String title; // 标题
  final String textValue; // 值文本（此值为空时候，视图会自动隐藏）
  final double textValueFontSize; // 值文本的字体大小(默认30)
  bool textThemeIsRed = false; // 值文本是否是红色主题(不设置即默认灰色)
  bool addDotForValue = false; // 是否在value前添加·点(不设置即默认不添加，如果添加则点的颜色和文本颜色一直)
  final TableViewCellArrowImageType arrowImageType; // 箭头类型(默认none)

  final GestureTapCallback onTap; // 点击事件
  final GestureLongPressCallback onLongPress;

  BJHTitleTextValueCell({
    Key key,
    this.height,
    this.leftRightPadding,
    this.title,
    this.textValue,
    this.textValueFontSize,
    this.textThemeIsRed,
    this.addDotForValue,
    this.onTap,
    this.onLongPress,
    this.arrowImageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BJHTitleCommonValueTableViewCell(
      height: this.height,
      leftRightPadding: this.leftRightPadding,
      title: this.title,
      valueWidget: _valueWidget(),
      arrowImageType: arrowImageType ?? TableViewCellArrowImageType.arrowRight,
      clickCellCallback: (section, row, {bIsLongPress}) {
        if (bIsLongPress == true) {
          if (this.onLongPress != null) {
            this.onLongPress();
          }
        } else {
          if (this.onTap != null) {
            this.onTap();
          }
        }
      },
    );
  }

  Widget _valueWidget() {
    List<Widget> widgets = [];

    if (this.addDotForValue == true) {
      widgets.add(_dot(7));
      widgets.add(SizedBox(width: 20.w_cj));
    }

    Color textColor =
        this.textThemeIsRed == true ? Color(0xFFFF7F00) : Color(0xff999999);
    if (_textValueWidget(textColor) != null) {
      widgets.add(_textValueWidget(textColor));
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
          color: const Color(0xFFFF7F00),
          width: radius.w_cj,
          style: BorderStyle.solid,
        ),
      ),
    );
  }

  // 副文本
  Widget _textValueWidget(Color textColor) {
    // 判断是否添加副文本，存在才构建视图
    if (null == this.textValue || this.textValue.length == 0) {
      return null;
    }

    // // 自动缩小字体的组件
    // return FlutterAutoText(
    //   text: this.textValue ?? '',
    // );

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      constraints: BoxConstraints(maxWidth: 180),
      color: Colors.transparent,
      child: Text(
        this.textValue ?? '',
        textAlign: TextAlign.right,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontSize: this.textValueFontSize ?? 30.w_cj,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
