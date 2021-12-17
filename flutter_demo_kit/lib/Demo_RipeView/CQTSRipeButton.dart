import 'package:flutter/material.dart';
import 'dart:math';

class CQTSRipeButton {
  static Widget tsRipeButtonIndex(index) {
    Color randomColor = Color.fromRGBO(
      Random().nextInt(256), // 需要引入 import 'dart:math';
      Random().nextInt(256),
      Random().nextInt(256),
      1,
    );

    String title = '按钮${index}';
    return Container(
      color: randomColor,
      height: 40,
      child: GestureDetector(
        onTap: () {
          print('你点击了${title}');
        },
        child: Text(title),
      ),
    );
  }
}
