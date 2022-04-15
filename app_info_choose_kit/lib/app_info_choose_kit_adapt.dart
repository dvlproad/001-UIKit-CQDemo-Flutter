import 'dart:ui';
import 'dart:math'; // min
import 'package:flutter/material.dart';

class AdaptCJHelper {
  static bool _hasInit = false;

  static Size uiSize = const Size(375, 812);
  static double _screenWidth;
  static double _screenHeight;
  static double _scaleWidth;
  static double _scaleHeight;
  static init() {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;

    _scaleWidth = _screenWidth / uiSize.width;
    _scaleHeight = _screenHeight / uiSize.height;

    _hasInit = true;
  }

  /// 实际尺寸与UI设计的比例
  static double get scaleWidth {
    if (_hasInit != true) {
      AdaptCJHelper.init();
    }

    return _scaleWidth;
  }

  static double get scaleHeight {
    if (_hasInit != true) {
      AdaptCJHelper.init();
    }

    return _scaleHeight;
  }

  /// 根据UI设计的设备宽度适配
  static double setWidth(num width) => width * scaleWidth;
  static double setHeight(num height) => height * scaleHeight;

  static bool _minTextAdapt = false;
  static double get scaleText =>
      _minTextAdapt ? min(scaleWidth, scaleHeight) : scaleWidth;

  ///字体大小适配方法
  ///- [fontSize] UI设计上字体的大小,单位dp.
  ///Font size adaptation method
  ///- [fontSize] The size of the font on the UI design, in dp.
  static double setSp(num fontSize) => fontSize * scaleText;
}

extension CJSizeExtension on num {
  double get w_pt_cj => AdaptCJHelper.setWidth(this);
  double get h_pt_cj => AdaptCJHelper.setWidth(this);
  double get f_pt_cj => AdaptCJHelper.setSp(this);
}
