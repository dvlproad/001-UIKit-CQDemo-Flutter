import 'package:flutter/material.dart';
import '../../base-uikit/button/textbutton.dart';
import './theme.dart';

/// 以主题色为背景或边框的按钮(selected 属性的值会影响 ui 样式, 即可通过 selected 属性来自动变更样式)
class PinkThemeStateButton extends CJReverseThemeStateTextButton {
  PinkThemeStateButton({
    Key key,
    double cornerRadius = 5.0,
    String normalTitle,
    String selectedTitle,
    TextStyle titleStyle,
    bool enable = true,
    bool selected = false,
    @required VoidCallback onPressed,
  })  : assert(normalTitle != null),
        assert(onPressed != null),
        super(
          key: key,
          normalTitle: normalTitle,
          selectedTitle: selectedTitle,
          textStyle: titleStyle,
          enable: enable,
          selected: selected,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          themeColor: themeColor,
          themeOppositeColor: Colors.white,
          normalBorderWidth: 0.0,
          selectedBorderWidth: 1.0,
          normalHighlightColor: Colors.yellow,
          selectedHighlightColor: Colors.pink,
        );
}
