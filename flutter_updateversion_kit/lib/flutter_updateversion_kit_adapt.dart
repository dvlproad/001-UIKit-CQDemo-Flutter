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

  ///字体大小适配方法
  double get scaleText {
    return 1;
  }

  double setSp(num fontSize) => fontSize * scaleText;
}

extension CJSizeExtension on num {
  double get w_cj => AdaptCJHelper.setWidth(this);
  double get h_cj => AdaptCJHelper.setWidth(this);
  double get sp_cj => AdaptCJHelper().setSp(this);
}
