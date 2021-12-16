import 'package:flutter/material.dart';
import '../../base-uikit/button/textbutton.dart';

Color themeColor = Color(0xFFCD3F49); // 粉红色 pink
Color themeOppositeColor = Colors.white;

/// 以主题色为背景的按钮
class CQPinkThemeBGButton extends CJStateTextButton {
  CQPinkThemeBGButton({
    Key key,
    String title,
    TextStyle titleStyle,
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
          normalBGColor: themeColor,
          normalTextColor: themeOppositeColor,
          normalBorderWidth: 0.0,
          normalBorderColor: themeOppositeColor,
          // normalHighlightColor: Colors.yellow,
        );
}

/// 以主题色为边框的按钮
class CQPinkThemeBorderButton extends CJStateTextButton {
  CQPinkThemeBorderButton({
    Key key,
    String title,
    TextStyle titleStyle,
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
          normalBGColor: themeOppositeColor,
          normalTextColor: themeColor,
          normalBorderWidth: 1.0,
          normalBorderColor: themeColor,
          // normalHighlightColor: Colors.pink,
        );
}

/// 以主题色为背景或边框的按钮(selected 属性的值会影响 ui 样式, 即可通过 selected 属性来自动变更样式)
class CQPinkThemeStateButton extends CJReverseThemeStateTextButton {
  CQPinkThemeStateButton({
    Key key,
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
          themeColor: themeColor,
          themeOppositeColor: Colors.white,
          normalBorderWidth: 0.0,
          selectedBorderWidth: 1.0,
          normalHighlightColor: Colors.yellow,
          selectedHighlightColor: Colors.pink,
        );
}
