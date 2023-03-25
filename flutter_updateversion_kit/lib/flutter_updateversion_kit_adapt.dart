/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-26 01:04:23
 * @Description: 
 */
import 'dart:ui';
import 'package:flutter/material.dart';

class AdaptCJHelper {
  // ignore: prefer_typing_uninitialized_variables
  static late var _ratio;

  static init(int number) {
    int uiwidth = number;

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
  // ignore: non_constant_identifier_names
  double get w_cj => AdaptCJHelper.setWidth(this);
  // ignore: non_constant_identifier_names
  double get h_cj => AdaptCJHelper.setWidth(this);
  // ignore: non_constant_identifier_names
  double get sp_cj => AdaptCJHelper().setSp(this);
}
