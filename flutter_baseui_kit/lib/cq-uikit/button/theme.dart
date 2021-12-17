import 'package:flutter/material.dart';
// import 'dart:ui';

// final Color themeColor = Color(0xFFCD3F49); // 粉红色 pink
// final Color themeOppositeColor = Colors.white;

// final Color blackColor = Color(0xFF222222); // 黑色 black
// final Color blackOppositeColor = Colors.white;

final Map theme = {
  "pink": {
    "themeColor": Color(0xFFCD3F49), // 粉红色 pink
    "themeOppositeColor": Colors.white,
  },
  "black": {
    "themeColor": Color(0xFF222222), // 黑色 black,
    "themeOppositeColor": Colors.white,
  },
};

enum ThemeBGType {
  pink,
  black,
  white,
}

Color themeColor(ThemeBGType type) {
  type = type ?? ThemeBGType.pink;
  return theme[type.toString().split('.').last]['themeColor'];
}

Color themeOppositeColor(ThemeBGType type) {
  type = type ?? ThemeBGType.pink;
  return theme[type.toString().split('.').last]['themeOppositeColor'];
}

TextStyle PingFang_Bold_FontSize(double fontSize) {
  return TextStyle(
    fontFamily: 'PingFang SC',
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
  );
}

TextStyle PingFang_Medium_FontSize(double fontSize) {
  return TextStyle(
    fontFamily: 'PingFang SC',
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );
}

// class Theme {
//   Color themeColor = Color(0xFFCD3F49); // 粉红色 pink
//   Color themeOppositeColor = Colors.white;

//   Color blackColor = Color(0xFF222222); // 黑色 black
// }

// const Map<String, Map<String, Color>> CJTSThemeDefault = {
//   'style': {
//     'themeColor': Color(0xFFCD3F49),
//     'themeOppositeColor': Colors.white,
//     'blackColor': Color(0xFF222222),
//   }
// };