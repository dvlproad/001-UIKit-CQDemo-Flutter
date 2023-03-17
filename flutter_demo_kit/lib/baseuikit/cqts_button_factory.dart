import 'package:flutter/material.dart';
import './textbutton.dart';
import './buttontheme.dart';
export './buttontheme.dart' show CQTSThemeBGType;

// themetextbutton
/// 以主题色为背景的按钮
class CQTSThemeBGButton extends CJStateTextButton {
  CQTSThemeBGButton({
    Key? key,
    double? width,
    double? height,
    required CQTSThemeBGType bgColorType,
    bool needHighlight = false, // 是否需要高亮样式(默认false)
    required String title,
    TextStyle? titleStyle,
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
            return Text(
              title,
              style: titleStyle ?? TextStyle(fontSize: 13.0),
            );
          },
          enable: enable,
          selected: false,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: themeColor(bgColorType),
          normalTextColor: themeOppositeColor(bgColorType),
          normalBorderWidth: 0.0,
          normalBorderColor: themeOppositeColor(bgColorType),
          // normalHighlightColor: Colors.yellow,
          highlightOpacity: needHighlight ? 0.7 : 1.0,
        );
}

/// 以主题色为边框的按钮(①红色边框和文字，白色背景、②黑色边框和文字，白色背景)
class CQTSThemeBorderButton extends CJStateTextButton {
  CQTSThemeBorderButton({
    Key? key,
    double? width,
    double? height,
    required CQTSThemeBGType borderColorType,
    bool needHighlight = false, // 是否需要高亮样式(默认false)
    required String title,
    TextStyle? titleStyle,
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
            return Text(
              title,
              style: titleStyle ?? TextStyle(fontSize: 13.0),
            );
          },
          enable: enable,
          selected: false,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: themeOppositeColor(borderColorType),
          normalTextColor: themeColor(borderColorType),
          normalBorderWidth: 1.0,
          normalBorderColor: themeColor(borderColorType),
          // normalHighlightColor: Colors.pink,
          highlightOpacity: needHighlight ? 0.7 : 1.0,
        );
}

// statetextbutton
/// 以主题色为背景或边框的按钮(selected 属性的值会影响 ui 样式, 即可通过 selected 属性来自动变更样式)
class CQTSThemeStateButton extends CJReverseThemeStateTextButton {
  CQTSThemeStateButton({
    Key? key,
    double? width,
    double? height,
    required CQTSThemeBGType normalBGColorType,
    bool needHighlight = false, // 是否需要高亮样式(默认false)
    double cornerRadius = 5.0,
    required String normalTitle,
    String? selectedTitle,
    TextStyle? titleStyle,
    bool enable = true,
    bool selected = false,
    required void Function() onPressed,
  })  : assert(normalTitle != null),
        assert(onPressed != null),
        super(
          key: key,
          width: width,
          height: height,
          childBuider: (bSelected) {
            String _currentTitle = normalTitle;
            if (selected) {
              _currentTitle = selectedTitle ?? normalTitle;
            }

            return Text(
              _currentTitle,
              style: titleStyle ?? TextStyle(fontSize: 13.0),
            );
          },
          enable: enable,
          selected: selected,
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            }
          },
          cornerRadius: cornerRadius,
          themeColor: themeColor(normalBGColorType),
          themeOppositeColor: themeOppositeColor(normalBGColorType),
          normalBorderWidth: 0.0,
          selectedBorderWidth: 1.0,
          // normalBackgroundHighlightColor: Colors.yellow,
          // selectedBackgroundHighlightColor: Colors.pink,
          highlightOpacity: needHighlight ? 0.7 : 1.0,
        );
}
