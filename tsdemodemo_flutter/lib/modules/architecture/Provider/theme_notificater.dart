import 'package:flutter/material.dart';

class ThemeChangeNotifier extends ChangeNotifier {
  String _themeString;
  ThemeChangeNotifier(this._themeString);

  void changeTheme(tempThemeString) {
    _themeString = tempThemeString;
    notifyListeners(); //通知所有监听的页面，如果写在runapp中那么通知所有页面重新加载
  }

  String get themeString => _themeString;
}
