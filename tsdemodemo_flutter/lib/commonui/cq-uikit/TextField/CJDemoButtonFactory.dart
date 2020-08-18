import 'package:flutter/material.dart';

/// 蓝色背景按钮(常用于：登录按钮)
class BlueButton extends FlatButton {
  BlueButton({
    Key key,
    String text,
    bool enable,
    @required VoidCallback enableOnPressed,
  }) : super(
    key: key,
    child: Text(text),
    onPressed: enable ?  enableOnPressed : null,
    splashColor: Colors.transparent,
    color: Color(0xff01adfe),
    textColor: Colors.white,
    highlightColor: Color(0xff1393d7),
    disabledColor: Color(0xffd3d3d5),
    disabledTextColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0)
    ),
    );
}