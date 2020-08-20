import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/base-uikit/button.dart';

Color themeColor = Color(0xFFF56C6C);
Color themeOppositeColor = Colors.white;

/// 以主题色为背景的按钮
class CQPinkThemeBGButton extends CJTextButton {
  CQPinkThemeBGButton({
    Key key,
    String title,
    bool enable = true,
    bool selected = false,
    @required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          normalTitle: title,
          enable: enable,
          selected: selected,
          onPressed: onPressed,
          normalBGColor: themeColor,
          normalTextColor: themeOppositeColor,
          normalBorderWidth: 0.0,
          normalBorderColor: themeOppositeColor,
        );
}

/// 以主题色为边框的按钮
class CQPinkThemeBorderButton extends CJTextButton {
  CQPinkThemeBorderButton({
    Key key,
    String title,
    bool enable = true,
    bool selected = false,
    @required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          normalTitle: title,
          enable: enable,
          selected: selected,
          onPressed: onPressed,
          normalBGColor: themeOppositeColor,
          normalTextColor: themeColor,
          normalBorderWidth: 1.0,
          normalBorderColor: themeOppositeColor,
        );
}

/// 以主题色为背景或边框的按钮(可通过 selected 属性来设置)
class CQPinkThemeStateButton extends CJStateThemeButton {
  CQPinkThemeStateButton({
    Key key,
    String normalTitle,
    String selectedTitle,
    bool enable = true,
    bool selected = false,
    @required VoidCallback onPressed,
  })  : assert(normalTitle != null),
        assert(onPressed != null),
        super(
          key: key,
          normalTitle: normalTitle,
          selectedTitle: selectedTitle,
          enable: enable,
          selected: selected,
          onPressed: onPressed,
          themeColor: themeColor,
          themeOppositeColor: Colors.white,
          normalBorderWidth: 0.0,
          selectedBorderWidth: 1.0,
        );
}
