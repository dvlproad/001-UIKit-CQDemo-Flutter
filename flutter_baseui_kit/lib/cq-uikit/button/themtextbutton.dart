import 'package:flutter/material.dart';
import '../../base-uikit/button/textbutton.dart';
import './buttontheme.dart';

/// 以主题色为背景的按钮
class ThemeBGButton extends CJStateTextButton {
  ThemeBGButton({
    Key key,
    double width,
    double height,
    @required ThemeBGType bgColorType,
    @required String title,
    TextStyle titleStyle,
    double cornerRadius = 5.0,
    bool enable = true,
    @required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          width: width,
          height: height,
          normalTitle: title,
          textStyle: titleStyle,
          enable: enable,
          selected: false,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: themeColor(bgColorType),
          normalTextColor: themeOppositeColor(bgColorType),
          normalBorderWidth: 0.0,
          normalBorderColor: themeOppositeColor(bgColorType),
          // normalHighlightColor: Colors.yellow,
        );
}

/// 以主题色为边框的按钮(①红色边框和文字，白色背景、②黑色边框和文字，白色背景)
class ThemeBorderButton extends CJStateTextButton {
  ThemeBorderButton({
    Key key,
    double width,
    double height,
    @required ThemeBGType borderColorType,
    @required String title,
    TextStyle titleStyle,
    double cornerRadius = 5.0,
    bool enable = true,
    @required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          width: width,
          height: height,
          normalTitle: title,
          textStyle: titleStyle,
          enable: enable,
          selected: false,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: themeOppositeColor(borderColorType),
          normalTextColor: themeColor(borderColorType),
          normalBorderWidth: 1.0,
          normalBorderColor: themeColor(borderColorType),
          // normalHighlightColor: Colors.pink,
        );
}
