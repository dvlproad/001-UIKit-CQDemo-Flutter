import 'package:flutter/material.dart';

class EnvironmentCellComponentsFactory {
  // 主文本
  static Widget mainText(text) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        text ?? '',
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }

  // 副文本
  static Widget subText(text) {
    // return Container(
    //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    //   color: Colors.transparent,
    //   child: Text(
    //     text ?? '',
    //     textAlign: TextAlign.left,
    //     overflow: TextOverflow.ellipsis,
    //     style: TextStyle(
    //       color: Colors.white70,
    //       fontSize: 16.0,
    //     ),
    //   ),
    // );
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: TextField(
        // keyboardType: keyboardType,
        // controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          // hintText: placeholder,
        ),
        // inputFormatters: this.inputFormatters,
      ),
    );
  }

  // 箭头
  static Widget arrowImage() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
      color: Colors.transparent,
      child: Icon(Icons.check_box, color: Colors.white, size: 14),
    );
  }
}
