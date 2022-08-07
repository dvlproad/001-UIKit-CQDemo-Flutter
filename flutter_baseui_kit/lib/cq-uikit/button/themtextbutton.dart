import 'package:flutter/material.dart';
import '../../base-uikit/button/textbutton.dart';
import './button_child_widget.dart';
import './buttontheme.dart';

class RowPaddingButton extends StatelessWidget {
  double? leftRightPadding;
  double? height;
  double? cornerRadius;
  ThemeBGType bgColorType;
  String title;
  TextStyle? titleStyle;
  void Function() onPressed;

  RowPaddingButton({
    Key? key,
    this.leftRightPadding,
    this.height,
    this.cornerRadius,
    required this.bgColorType,
    required this.title,
    this.titleStyle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(
        left: leftRightPadding ?? 0,
        right: leftRightPadding ?? 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ThemeBGButton(
              height: height,
              cornerRadius: cornerRadius,
              bgColorType: bgColorType,
              title: title,
              titleStyle: titleStyle,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

/// 以主题色为背景的按钮
class ThemeBGButton extends CJStateTextButton {
  ThemeBGButton({
    Key? key,
    double? width,
    double? height,
    ThemeBGType? bgColorType,
    Color? bgColor, // 不设置 bgColor 的时候要设置 bgColorType
    Color? textColor, // 不设置 textColor 的时候要设置 bgColorType
    bool needHighlight = false, // 是否需要高亮样式(默认false)
    required String title,
    TextStyle? titleStyle,
    Image? imageWidget, // 图片
    double? imageTitleGap, // 图片和文字之间的距离(imageWidget存在的时候才有效)
    double? cornerRadius,
    bool enable = true,
    VoidCallback? onPressed, // null时候会自动透传事件
  })  : assert(title != null),
        assert(bgColorType != null || bgColor != null),
        assert(bgColorType != null || textColor != null),
        super(
          key: key,
          width: width,
          height: height,
          childBuider: (bSelected) {
            return ButtonChildWidget(
              title: title,
              titleStyle: titleStyle,
              imageWidget: imageWidget,
              imageTitleGap: imageTitleGap,
            );
          },
          enable: enable,
          selected: false,
          onPressed: onPressed,
          cornerRadius: cornerRadius ?? 5.0,
          normalBGColor: bgColor != null ? bgColor : themeColor(bgColorType),
          normalTextColor:
              textColor != null ? textColor : themeOppositeColor(bgColorType),
          normalBorderWidth: 0.0,
          normalBorderColor:
              textColor != null ? textColor : themeOppositeColor(bgColorType),
          // normalHighlightColor: Colors.yellow,
          highlightOpacity: needHighlight ? 0.7 : 1.0,
        );
}

/// 以主题色为边框的按钮(①红色边框和文字，白色背景、②黑色边框和文字，白色背景)
class ThemeBorderButton extends CJStateTextButton {
  ThemeBorderButton({
    Key? key,
    double? width,
    double? height,
    required ThemeBGType borderColorType,
    bool needHighlight = false, // 是否需要高亮样式(默认false)
    required String title,
    TextStyle? titleStyle,
    Image? imageWidget, // 图片
    double? imageTitleGap, // 图片和文字之间的距离(imageWidget存在的时候才有效)
    double cornerRadius = 5.0,
    bool enable = true,
    required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          width: width,
          height: height,
          childBuider: (bSelected) {
            return ButtonChildWidget(
              title: title,
              titleStyle: titleStyle,
              imageWidget: imageWidget,
              imageTitleGap: imageTitleGap,
            );
          },
          enable: enable,
          selected: false,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: themeOppositeColor(borderColorType),
          normalTextColor: themeColor(borderColorType),
          normalBorderWidth: 0.5,
          normalBorderColor: themeColor(borderColorType),
          // normalHighlightColor: Colors.pink,
          highlightOpacity: needHighlight ? 0.7 : 1.0,
        );
}
