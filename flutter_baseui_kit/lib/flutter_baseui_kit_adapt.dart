import 'dart:ui';
import 'package:flutter/material.dart';

class AdaptCJHelper {
  static var _ratio;

  static init(int number) {
    int uiwidth = number is int ? number : 750;

    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    double _width = mediaQuery.size.width;
    _ratio = _width / uiwidth;
  }

  static setWidth(number) {
    if (!(_ratio is double || _ratio is int)) {
      AdaptCJHelper.init(750);
    }
    return number * _ratio;
  }
}

extension CJSizeExtension on num {
  double get w_cj => AdaptCJHelper.setWidth(this);
  double get h_cj => AdaptCJHelper.setWidth(this);
}

