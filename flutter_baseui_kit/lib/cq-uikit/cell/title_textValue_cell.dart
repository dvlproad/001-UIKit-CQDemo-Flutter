// 包含标题文本title，值文本textValue(文本前可设置是否添加点来突出)、箭头类型固定为向右 的视图
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './title_commonValue_cell.dart';
export './title_commonValue_cell.dart' show TableViewCellArrowImageType;
// import '../text/text.dart';

class BJHTitleTextValueCell extends StatelessWidget {
  final double height; // cell 的高度
  final double leftRightPadding; // cell 内容的左右间距(未设置时候，默认20)
  final double leftMaxWidth;
  final double rightMaxWidth;

  // 左侧-图片
  final ImageProvider imageProvider; // 图片(默认null时候，imageWith大于0时候才有效)
  final double imageWith; // 图片宽高(默认null，非大于0时候，图片没位置)
  final double imageTitleSpace; // 图片与标题间距(图片存在时候才有效)
  // 左侧-标题
  final String title; // 标题
  // 右侧-值文本
  final String textValue; // 值文本（此值为空时候，视图会自动隐藏）
  final double textValueFontSize; // 值文本的字体大小(默认30)
  bool textThemeIsRed = false; // 值文本是否是红色主题(不设置即默认灰色)
  bool addDotForValue = false; // 是否在value前添加·点(不设置即默认不添加，如果添加则点的颜色和文本颜色一直)
  // 右侧-值文本占位符
  final String textValuePlaceHodler; // 值文本占位符(默认null，不显示)
  final Color textValuePlaceHodlerColor; // 值文本占位符文字颜色

  final TableViewCellArrowImageType arrowImageType; // 箭头类型(默认none)

  final GestureTapCallback onTap; // 点击事件
  final GestureLongPressCallback onLongPress;

  BJHTitleTextValueCell({
    Key key,
    this.height,
    this.leftRightPadding,
    this.leftMaxWidth, // 限制左侧的最大宽度(左右两侧都未设置最大宽度时候，请自己保证两边不会重叠)
    this.rightMaxWidth, // 限制右侧的最大宽度(左右两侧都未设置最大宽度时候，请自己保证两边不会重叠)
    this.imageProvider,
    this.imageWith,
    this.imageTitleSpace,
    @required this.title,
    this.textValue,
    this.textValueFontSize,
    this.textThemeIsRed,
    this.addDotForValue,
    this.textValuePlaceHodler,
    this.textValuePlaceHodlerColor,
    this.onTap,
    this.onLongPress,
    this.arrowImageType,
  }) : //assert(leftMaxWidth > 0 || rightMaxWidth > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BJHTitleCommonValueTableViewCell(
      height: this.height,
      leftRightPadding: this.leftRightPadding,
      leftMaxWidth: this.leftMaxWidth,
      rightMaxWidth: this.rightMaxWidth,
      imageProvider: this.imageProvider,
      imageWith: this.imageWith,
      imageTitleSpace: this.imageTitleSpace,
      title: this.title,
      valueWidgetBuilder: (BuildContext bContext, {bool canExpanded}) =>
          _valueWidget(bContext, canExpanded: canExpanded),
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

  Widget _valueWidget(BuildContext bContext, {bool canExpanded}) {
    List<Widget> widgets = [];

    if (this.addDotForValue == true) {
      widgets.add(_dot(7));
      widgets.add(SizedBox(width: 10.w_pt_cj));
    }

    if (_textValueWidget() != null) {
      if (canExpanded == true) {
        widgets.add(Expanded(child: _textValueWidget()));
      } else {
        widgets.add(_textValueWidget());
      }
    }

    return Row(
      children: widgets,
    );
  }

  // 文本前面的点(一般不添加)
  Widget _dot(double radius) {
    return Container(
      width: 2 * radius.w_pt_cj,
      height: 2 * radius.h_pt_cj,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius.w_pt_cj)),
        border: Border.all(
          color: const Color(0xFFFF7F00),
          width: radius.w_pt_cj,
          style: BorderStyle.solid,
        ),
      ),
    );
  }

  // 副文本
  Widget _textValueWidget() {
    // 判断是否添加副文本，存在才构建视图
    bool existTextValue = this.textValue != null && this.textValue.isNotEmpty;
    bool existTextValuePlaceHodler = this.textValuePlaceHodler != null &&
        this.textValuePlaceHodler.isNotEmpty;
    if (existTextValue == false && existTextValuePlaceHodler == false) {
      return null;
    }

    // // 自动缩小字体的组件
    // return FlutterAutoText(
    //   text: this.textValue ?? '',
    // );

    String showText;
    Color showTextColor = Color(0xff333333);
    if (existTextValue == true) {
      showText = this.textValue;
      if (this.textThemeIsRed == true) {
        showTextColor = Color(0xFFFF7F00);
      }
    } else {
      if (textValuePlaceHodler != null) {
        showText = textValuePlaceHodler;
        showTextColor = textValuePlaceHodlerColor ?? Color(0xC1C1C1);
      } else {
        showText = "";
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      constraints: BoxConstraints(maxWidth: 180),
      color: Colors.transparent,
      child: Text(
        showText,
        textAlign: TextAlign.right,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: showTextColor,
          fontFamily: 'PingFang SC',
          fontSize: this.textValueFontSize ?? 16.f_pt_cj,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      ),
    );
  }
}
