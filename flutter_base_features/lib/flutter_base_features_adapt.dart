// ignore_for_file: annotate_overrides, overridden_fields

/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-21 15:56:34
 * @Description: 宽高等适配
 */
import 'dart:ui';
import 'dart:math'; // min
import 'package:flutter/material.dart';

class AdaptCJHelper {
  static bool _hasInit = false;

  static Size uiSize = const Size(375, 812);
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _stautsBarHeight;
  static late double _screenBottomHeight;
  static late double _scaleWidth;
  static late double _scaleHeight;

  static init() {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _stautsBarHeight = mediaQuery.padding.top;

    /// 疑难杂症:这里为什么有时候会等于0，常见于点击搜索后，弹窗键盘,回来发现
    _screenBottomHeight = mediaQuery.padding.bottom;

    _scaleWidth = _screenWidth / uiSize.width;
    _scaleHeight = _screenHeight / uiSize.height;

    _hasInit = true;
  }

  static double get stautsBarHeight {
    if (_hasInit != true) {
      AdaptCJHelper.init();
    }

    return _stautsBarHeight;
  }

  static double get screenBottomHeight {
    if (_hasInit != true) {
      AdaptCJHelper.init();
    }

    return _screenBottomHeight;
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

  static const bool _minTextAdapt = false;
  static double get scaleText =>
      _minTextAdapt ? min(scaleWidth, scaleHeight) : scaleWidth;

  ///字体大小适配方法
  ///- [fontSize] UI设计上字体的大小,单位dp.
  ///Font size adaptation method
  ///- [fontSize] The size of the font on the UI design, in dp.
  static double setSp(num fontSize) => fontSize * scaleText;
}

extension CJSizeExtension on num {
  // ignore: non_constant_identifier_names
  double get w_pt_cj => AdaptCJHelper.setWidth(this);
  // ignore: non_constant_identifier_names
  double get h_pt_cj => AdaptCJHelper.setWidth(this);
  // ignore: non_constant_identifier_names
  double get f_pt_cj => AdaptCJHelper.setSp(this);
}

extension CJFeatureTextStyle on TextStyle {
  TextStyle get regular {
    return TextStyle(
      fontFamily: 'PingFang SC',
      fontWeight: FontWeight.w400,
      overflow: overflow,
      decoration: decoration,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      color: color,
      height: height,
      decorationColor: decorationColor,
      textBaseline: textBaseline,
    );
  }

  TextStyle get medium {
    return TextStyle(
      fontFamily: 'PingFang SC',
      fontWeight: FontWeight.w500,
      overflow: overflow,
      decoration: decoration,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      color: color,
      height: height,
      decorationColor: decorationColor,
      textBaseline: textBaseline,
    );
  }

  TextStyle get bold {
    return TextStyle(
      fontFamily: 'PingFang SC',
      fontWeight: FontWeight.bold,
      overflow: overflow,
      decoration: decoration,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      color: color,
      height: height,
      decorationColor: decorationColor,
      textBaseline: textBaseline,
    );
  }
}

// Regular 的文本样式
class RegularTextStyle extends TextStyle {
  final double fontSize;
  final Color? color;
  final double? height;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterSpacing;

  const RegularTextStyle({
    required this.fontSize,
    this.color,
    this.height,
    this.overflow,
    this.decoration,
    this.letterSpacing,
  }) : super(
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w400,
          overflow: overflow,
          decoration: decoration,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          color: color,
          height: height,
          // backgroundColor: Colors.red,
        );
}

// bold 的文本样式
class BoldTextStyle extends TextStyle {
  final double fontSize;
  final Color? color;
  final double? height;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final Color? decorationColor;
  final TextBaseline? textBaseline;

  const BoldTextStyle({
    required this.fontSize,
    this.color,
    this.height,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.decorationColor,
    this.textBaseline,
  }) : super(
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.bold,
          overflow: overflow,
          decoration: decoration,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          color: color,
          height: height,
          decorationColor: decorationColor,
          textBaseline: textBaseline,
        );
}

// medium 的文本样式
class MediumTextStyle extends TextStyle {
  final double? fontSize;
  final Color? color;
  final double? height;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final Color? decorationColor;
  final TextBaseline? textBaseline;

  const MediumTextStyle({
    this.fontSize, // 临时去掉require 后续确实的地方需要补充回来
    this.color,
    this.height,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.decorationColor,
    this.textBaseline,
  }) : super(
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w500,
          overflow: overflow,
          decoration: decoration,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          color: color,
          height: height,
          decorationColor: decorationColor,
          textBaseline: textBaseline,
        );
}
