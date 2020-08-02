import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_bean.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_setting_page4.dart';

class ThemeBloc {
  ThemeBean _themeBean = ThemeBean();
  StreamController<ThemeBean> _streamController;

  ThemeBloc() {
    _themeBean = ThemeBean();
    _streamController = StreamController.broadcast();
  }

  // Stream<ThemeBean> get data => _streamController.stream;

  Stream<ThemeBean> getStream() {
    return _streamController.stream;
  }

  ThemeBean getValue(themeString) {
    _themeBean.themeString = themeString;
    return _themeBean;
  }

  void goChangeTheme(BuildContext context, int themeType, String themeString) {
    _themeBean.themeString = themeString;
    _themeBean.themeType = themeType;

    _streamController.sink.add(_themeBean);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ThemeSettingPage4(themeString: themeString)));
  }

  void changeTheme(BuildContext context, int themeType, String themeString) {
    _themeBean.themeString = themeString;
    _themeBean.themeType = themeType;

    _streamController.sink.add(_themeBean);

    // Navigator.of(context).pop(context);
  }

  void dispose() {
    _streamController.close();
  }
}
