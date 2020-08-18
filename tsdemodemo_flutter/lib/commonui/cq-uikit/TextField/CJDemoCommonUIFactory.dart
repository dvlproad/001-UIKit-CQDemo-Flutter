import 'package:flutter/material.dart';

// 文本框文本清除按钮
IconButton clearButtonWithOnPressed(VoidCallback onPressed) {
  return new IconButton(
      icon: new Icon(Icons.clear, color: Colors.black45),
      onPressed: onPressed
  );
}