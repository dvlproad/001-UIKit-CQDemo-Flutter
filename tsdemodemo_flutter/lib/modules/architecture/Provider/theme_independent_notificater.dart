import 'dart:math';

import 'package:flutter/material.dart';

class ThemeIndependentChangeNotifier extends ChangeNotifier {
  String _themeString;
  ThemeIndependentChangeNotifier(this._themeString);

  void changeTheme(tempThemeString) {
    var rng = new Random();
    int iRandom = rng.nextInt(100);
    tempThemeString += iRandom.toString();

    _themeString = tempThemeString;
    print('主题更改为' + tempThemeString);
    notifyListeners(); //通知所有监听的页面，如果写在runapp中那么通知所有页面重新加载
  }

  String get themeString => _themeString;
}
