/*
 * @Author: dvlproad
 * @Date: 2022-12-08 16:46:22
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-12-09 19:01:28
 * @Description: 环境库中的按钮
 */
import 'package:flutter/material.dart';

class EnvButtonFactory {
  // 提交按钮
  static TextButton submitButton({
    required String buttonText,
    required void Function()? onPressed,
  }) {
    return TextButton(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      style: ButtonStyle(
        //背景颜色
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          //设置按下时的背景颜色
          if (states.contains(MaterialState.pressed)) {
            return Color(0xff1393d7);
          }
          //默认不使用背景颜色
          return Color(0xff01adfe);
        }),
        shape: MaterialStateProperty.resolveWith(
          (states) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              // side: BorderSide(
              //   width: _currentBorderWidth,
              //   color: _currentBorderColor,
              // ),
            );
          },
        ),
      ),
      onPressed: onPressed,
    );
  }
}
