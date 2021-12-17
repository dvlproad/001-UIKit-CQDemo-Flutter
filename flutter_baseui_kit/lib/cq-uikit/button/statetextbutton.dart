import 'package:flutter/material.dart';
import '../../base-uikit/button/textbutton.dart';
import './theme.dart';

/// 以主题色为背景或边框的按钮(selected 属性的值会影响 ui 样式, 即可通过 selected 属性来自动变更样式)
class ThemeStateButton extends CJReverseThemeStateTextButton {
  ThemeStateButton({
    Key key,
    double width,
    double height,
    @required ThemeBGType normalBGColorType,
    double cornerRadius = 5.0,
    @required String normalTitle,
    String selectedTitle,
    TextStyle titleStyle,
    bool enable = true,
    bool selected = false,
    @required VoidCallback onPressed,
  })  : assert(normalTitle != null),
        assert(onPressed != null),
        super(
          key: key,
          width: width,
          height: height,
          normalTitle: normalTitle,
          selectedTitle: selectedTitle,
          textStyle: titleStyle,
          enable: enable,
          selected: selected,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          themeColor: themeColor(normalBGColorType),
          themeOppositeColor: themeOppositeColor(normalBGColorType),
          normalBorderWidth: 0.0,
          selectedBorderWidth: 1.0,
          normalHighlightColor: Colors.yellow,
          selectedHighlightColor: Colors.pink,
        );
}
