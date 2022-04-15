import 'dart:ui';
import 'package:flutter/material.dart';

class AdaptCJHelper {
  static var _ratio;

  static init(int number) {
    int uiwidth = number is int ? number : 375;

    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    double _width = mediaQuery.size.width;
    _ratio = _width / uiwidth;
  }

  static setWidth(number) {
    if (!(_ratio is double || _ratio is int)) {
      AdaptCJHelper.init(375);
    }
    return number * _ratio;
  }
}

extension CJSizeExtension on num {
  double get w_pt_cj => AdaptCJHelper.setWidth(this);
  double get h_pt_cj => AdaptCJHelper.setWidth(this);
}
