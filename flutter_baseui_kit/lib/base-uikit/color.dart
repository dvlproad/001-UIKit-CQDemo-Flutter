/*
 * color.dart
 *
 * @Description: 颜色创建方法
 *
 * @author      ciyouzen
 * @email       dvlproad@163.com
 * @date        2020/7/31 09:59
 *
 * Copyright (c) dvlproad. All rights reserved.
 */
import 'dart:ui';

class CJColor {
  /// - [colorString] 颜色值(可以输入多种格式的颜色代码，如: 0x000000,0xff000000,#000000)
  /// - [alpha] 透明度(默认1，0-1)
  static Color colorFromString(String colorString, {double alpha = 1.0}) {
    String colorStr = colorString;
// colorString未带0xff前缀并且长度为6
    if (!colorStr.startsWith('0xff') && colorStr.length == 6) {
      colorStr = '0xff' + colorStr;
    }
// colorString为8位，如0x000000
    if (colorStr.startsWith('0x') && colorStr.length == 8) {
      colorStr = colorStr.replaceRange(0, 2, '0xff');
    }
// colorString为7位，如#000000
    if (colorStr.startsWith('#') && colorStr.length == 7) {
      colorStr = colorStr.replaceRange(0, 1, '0xff');
    }
// 先分别获取色值的RGB通道
    Color color = Color(int.parse(colorStr));
    int red = color.red;
    int green = color.green;
    int blue = color.blue;
// 通过fromRGBO返回带透明度和RGB值的颜色
    return Color.fromRGBO(red, green, blue, alpha);
  }

  static Color colorFromHexString(String hexString, {double alpha = 1.0}) {
    int hex = _hexToInt(hexString);
    return Color(hex);
  }

  static int _hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        val = 255; // 兼容模拟的异常数据
        continue;
        // throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }
}
