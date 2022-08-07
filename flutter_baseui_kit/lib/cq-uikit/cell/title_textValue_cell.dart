// 包含标题文本title，值文本textValue(文本前可设置是否添加点来突出)、箭头类型固定为向右 的视图
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './title_commonValue_cell.dart';
export './title_commonValue_cell.dart' show TableViewCellArrowImageType;
// import '../text/text.dart';
import './title_commonValueWithHolder_cell.dart';

class ImageTitleTextValueCell extends StatelessWidget {
  final double? height; // cell 的高度
  final double? leftRightPadding; // cell 内容的左右间距(未设置时候，默认20)
  final double? leftMaxWidth;
  final double? rightMaxWidth;
  final double? leftRightSpacing;

  // 左侧-图片
  final ImageProvider? imageProvider; // 图片(默认null时候，imageWith大于0时候才有效)
  final double? imageWith; // 图片宽高(默认null，非大于0时候，图片没位置)
  final double? imageTitleSpace; // 图片与标题间距(图片存在时候才有效)
  // 左侧-标题
  final String title; // 标题
  // 右侧-值文本
  final String? textValue; // 值文本（此值为空时候，视图会自动隐藏）
  final int? textValueMaxLines; // 值文本的最大行数(为null时候，默认1)
  final double? textValueFontSize; // 值文本的字体大小(默认30)
  bool textThemeIsRed; // 值文本是否是红色主题(不设置即默认灰色)
  bool addDotForValue; // 是否在value前添加·点(不设置即默认不添加，如果添加则点的颜色和文本颜色一直)
  final String? textSubValue; // 值文本的副文本（此值为空时候，视图会自动隐藏）
  final int? textSubValueMaxLines; // 值文本的副文本的最大行数(为null时候，默认1)
  // 右侧-值文本占位符
  final String? textValuePlaceHodler; // 值文本占位符(默认null，不显示)

  final TableViewCellArrowImageType? arrowImageType; // 箭头类型(默认none)

  final GestureTapCallback? onTap; // 点击事件
  final GestureTapCallback? onDoubleTap; // 双击事件
  final GestureLongPressCallback? onLongPress; // 长按事件

  ImageTitleTextValueCell({
    Key? key,
    this.height,
    this.leftRightPadding,
    this.leftMaxWidth, // 限制左侧的最大宽度(左右两侧都未设置最大宽度时候，请自己保证两边不会重叠)
    this.rightMaxWidth, // 限制右侧的最大宽度(左右两侧都未设置最大宽度时候，请自己保证两边不会重叠)
    this.leftRightSpacing, // 左右两侧视图的间距(默认未未设置时候为0)
    this.imageProvider,
    this.imageWith,
    this.imageTitleSpace,
    required this.title,
    this.textValue,
    this.textValueMaxLines,
    this.textValueFontSize,
    this.textThemeIsRed = false,
    this.addDotForValue = false,
    this.textSubValue,
    this.textSubValueMaxLines,
    this.textValuePlaceHodler,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.arrowImageType,
  }) : //assert(leftMaxWidth > 0 || rightMaxWidth > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageTitleCommonValueWithHolderTableViewCell(
      height: this.height,
      leftRightPadding: this.leftRightPadding ?? 20.w_pt_cj,
      leftMaxWidth: this.leftMaxWidth,
      rightMaxWidth: this.rightMaxWidth,
      imageProvider: this.imageProvider,
      imageWith: this.imageWith,
      imageTitleSpace: this.imageTitleSpace,
      title: this.title,
      valuePlaceHodler: this.textValuePlaceHodler,
      valueWidgetBuilder: (BuildContext bContext, {bool canExpanded = false}) =>
          _valueWidget(bContext, canExpanded: canExpanded),
      arrowImageType: arrowImageType ?? TableViewCellArrowImageType.arrowRight,
      onTapCell: ({row, section}) {
        if (this.onTap != null) {
          this.onTap!();
        }
      },
      onLongPressCell: ({row, section}) {
        if (this.onLongPress != null) {
          this.onLongPress!();
        }
      },
      onDoubleTapCell: ({row, section}) {
        if (this.onDoubleTap != null) {
          this.onDoubleTap!();
        }
      },
    );
  }

  Widget? _valueWidget(BuildContext bContext, {bool canExpanded = false}) {
    bool hasContent = this.textValue != null && this.textValue!.isNotEmpty;
    if (hasContent == false) {
      return null;
    }
    List<Widget> widgets = [];

    if (this.addDotForValue == true) {
      widgets.add(_dot(7));
      widgets.add(SizedBox(width: 10.w_pt_cj));
    }

    if (canExpanded == true) {
      widgets.add(Expanded(child: _textValueWidget()));
    } else {
      widgets.add(_textValueWidget());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
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
    // // 自动缩小字体的组件
    // return FlutterAutoText(
    //   text: this.textValue ?? '',
    // );

    Color showTextColor = Color(0xff333333);
    if (this.textThemeIsRed == true) {
      showTextColor = Color(0xFFFF7F00);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 右边文本的上面主文本
          Text(
            this.textValue ?? '',
            textAlign: TextAlign.right,
            maxLines: textValueMaxLines ?? 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: showTextColor,
              fontFamily: 'PingFang SC',
              fontSize: this.textValueFontSize ?? 16.f_pt_cj,
              fontWeight: FontWeight.w400,
              // height: 1, // 设置height=1的时候，尝试设置backgroundColor很明显能够看出文本被截断了
              // backgroundColor: Colors.red,
            ),
          ),
          // 右边文本的下面副文本
          (textSubValue == null || textSubValue!.isEmpty)
              ? Container()
              : Text(
                  textSubValue!,
                  textAlign: TextAlign.right,
                  maxLines: textSubValueMaxLines ?? 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: showTextColor,
                    fontFamily: 'PingFang SC',
                    fontSize: this.textValueFontSize ?? 10.f_pt_cj,
                    fontWeight: FontWeight.w400,
                    // height: 1,
                  ),
                ),
        ],
      ),
    );
  }
}
