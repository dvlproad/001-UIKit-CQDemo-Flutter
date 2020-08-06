import 'package:flutter/material.dart';

class ThemeShareChangeNotifier extends ChangeNotifier {
  String _themeString;
  ThemeShareChangeNotifier(this._themeString);

  void changeTheme(tempThemeString) {
    _themeString = tempThemeString;
    notifyListeners(); //通知所有监听的页面，如果写在runapp中那么通知所有页面重新加载
  }

  String get themeString => _themeString;
}
