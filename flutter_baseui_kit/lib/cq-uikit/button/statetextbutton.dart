/*
 * @Author: dvlproad
 * @Date: 2022-06-24 23:54:10
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 19:11:19
 * @Description: 以主题色为背景或边框的按钮(selected 属性的值会影响 ui 样式, 即可通过 selected 属性来自动变更样式)
 */
import 'package:flutter/material.dart';
import '../../base-uikit/button/textbutton.dart';
import './button_child_widget.dart';
import './buttontheme.dart';

class ThemeStateButton extends CJReverseThemeStateTextButton {
  ThemeStateButton({
    Key? key,
    double? width,
    double? height,
    required ThemeStateBGType normalBGColorType,
    bool needHighlight = false, // 是否需要高亮样式(默认false)
    double cornerRadius = 5.0,
    required String normalTitle,
    String? selectedTitle,
    TextStyle? titleStyle,
    ButtonImagePosition? imagePosition,
    Image? imageWidget, // 图片
    double imageTitleGap = 5, // 图片和文字之间的距离(imageWidget存在的时候才有效)
    bool enable = true,
    bool selected = false,
    required void Function() onPressed,
  }) : super(
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
              imagePosition: imagePosition,
              imageWidget: imageWidget,
              imageTitleGap: imageTitleGap,
            );
          },
          enable: enable,
          selected: selected,
          onPressed: () {
            onPressed();
          },
          cornerRadius: cornerRadius,
          themeColor: stateThemeColor(normalBGColorType),
          themeOppositeColor: stateThemeOppositeColor(normalBGColorType),
          normalBorderWidth: 0.0,
          selectedBorderWidth: 1.0,
          // normalBackgroundHighlightColor: Colors.yellow,
          // selectedBackgroundHighlightColor: Colors.pink,
          highlightOpacity: needHighlight ? 0.7 : 1.0,
        );
}

class RichThemeStateButton extends CJStateTextButton {
  RichThemeStateButton({
    Key? key,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    required RichThemeStateBGType richBGColorType,
    bool needHighlight = false, // 是否需要高亮样式(默认false)
    double cornerRadius = 5.0,
    required String normalTitle,
    String? selectedTitle,
    TextStyle? titleStyle,
    ButtonImagePosition? imagePosition,
    Image? imageWidget, // 图片
    double imageTitleGap = 5, // 图片和文字之间的距离(imageWidget存在的时候才有效)
    bool enable = true,
    bool selected = false,
    required void Function() onPressed,
  }) : super(
          key: key,
          width: width,
          height: height,
          margin: margin,
          padding: padding,
          childBuider: (bSelected) {
            String _currentTitle = normalTitle;
            if (selected) {
              _currentTitle = selectedTitle ?? normalTitle;
            }
            double? childWidth = width;
            double? childHeight = height;
            if (childWidth != null && childHeight != null) {
              if (bSelected) {
                childWidth -=
                    richStateTheme_selectedBorderWidth(richBGColorType) * 2;
                childHeight -=
                    richStateTheme_selectedBorderWidth(richBGColorType) * 2;
              } else {
                childWidth -=
                    richStateTheme_normalBorderWidth(richBGColorType) * 2;
                childHeight -=
                    richStateTheme_normalBorderWidth(richBGColorType) * 2;
              }
            }
            return ButtonChildWidget(
              width: childWidth,
              height: childHeight,
              title: _currentTitle,
              titleStyle: titleStyle,
              imagePosition: imagePosition,
              imageWidget: imageWidget,
              imageTitleGap: imageTitleGap,
            );
          },
          enable: enable,
          selected: selected,
          onPressed: () {
            onPressed();
          },
          cornerRadius: cornerRadius,
          normalBGColor: richStateTheme_normalBGColor(richBGColorType),
          normalTextColor: richStateTheme_normalTextColor(richBGColorType),
          normalBorderWidth: richStateTheme_normalBorderWidth(richBGColorType),
          normalBorderColor: richStateTheme_normalBorderColor(richBGColorType),
          normalBackgroundHighlightColor:
              richStateTheme_normalBackgroundHighlightColor(richBGColorType),
          selectedBGColor: richStateTheme_selectedBGColor(richBGColorType),
          selectedTextColor: richStateTheme_selectedTextColor(richBGColorType),
          selectedBorderWidth:
              richStateTheme_selectedBorderWidth(richBGColorType),
          selectedBorderColor:
              richStateTheme_selectedBorderColor(richBGColorType),
          selectedBackgroundHighlightColor:
              richStateTheme_selectedBackgroundHighlightColor(richBGColorType),
          highlightOpacity: needHighlight ? 0.7 : 1.0,
        );
}
