import 'package:flutter/material.dart';
import '../../base-uikit/button/textbutton.dart';
import './button_child_widget.dart';
import './buttontheme.dart';

/// 以主题色为背景或边框的按钮(selected 属性的值会影响 ui 样式, 即可通过 selected 属性来自动变更样式)
class ThemeStateButton extends CJReverseThemeStateTextButton {
  ThemeStateButton({
    Key key,
    double width,
    double height,
    @required ThemeBGType normalBGColorType,
    bool needHighlight = false, // 是否需要高亮样式(默认false)
    double cornerRadius = 5.0,
    @required String normalTitle,
    String selectedTitle,
    TextStyle titleStyle,
    Image imageWidget, // 图片
    double imageTitleGap, // 图片和文字之间的距离(imageWidget存在的时候才有效)
    bool enable = true,
    @required bool selected = false,
    @required void Function() onPressed,
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

            return ButtonChildWidget(
              title: _currentTitle,
              titleStyle: titleStyle,
              imageWidget: imageWidget,
              imageTitleGap: imageTitleGap,
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
