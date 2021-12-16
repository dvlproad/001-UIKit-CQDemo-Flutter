import 'package:flutter/material.dart';
import '../../base-uikit/button/textbutton.dart';
import './theme.dart';

/// 以主题色为背景的按钮
class PinkThemeBGButton extends CJStateTextButton {
  PinkThemeBGButton({
    Key key,
    String title,
    TextStyle titleStyle,
    double cornerRadius = 5.0,
    bool enable = true,
    @required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          normalTitle: title,
          textStyle: titleStyle,
          enable: enable,
          selected: false,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: themeColor,
          normalTextColor: themeOppositeColor,
          normalBorderWidth: 0.0,
          normalBorderColor: themeOppositeColor,
          // normalHighlightColor: Colors.yellow,
        );
}

/// 以主题色为边框的按钮
class PinkThemeBorderButton extends CJStateTextButton {
  PinkThemeBorderButton({
    Key key,
    String title,
    TextStyle titleStyle,
    double cornerRadius = 5.0,
    bool enable = true,
    @required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          normalTitle: title,
          textStyle: titleStyle,
          enable: enable,
          selected: false,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: themeOppositeColor,
          normalTextColor: themeColor,
          normalBorderWidth: 1.0,
          normalBorderColor: themeColor,
          // normalHighlightColor: Colors.pink,
        );
}

/// 以主题色(黑色)为边框的按钮：黑色边框和文字，白色背景
class BlackThemeBorderButton extends CJStateTextButton {
  BlackThemeBorderButton({
    Key key,
    String title,
    TextStyle titleStyle,
    double cornerRadius = 5.0,
    bool enable = true,
    @required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          normalTitle: title,
          textStyle: titleStyle,
          enable: enable,
          selected: false,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: blackOppositeColor,
          normalTextColor: blackColor,
          normalBorderWidth: 1.0,
          normalBorderColor: blackColor,
          // normalHighlightColor: Colors.pink,
        );
}
