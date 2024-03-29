import 'package:flutter/material.dart';
import './tui_theme.dart';

class SharedThemeWidget extends InheritedWidget {
  final TUITheme theme;

  const SharedThemeWidget(
      {Key? key, required Widget child, required this.theme})
      : super(key: key, child: child);

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static SharedThemeWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SharedThemeWidget>();
  }

  @override
  bool updateShouldNotify(covariant SharedThemeWidget oldWidget) {
    return oldWidget.theme != theme;
  }
}
