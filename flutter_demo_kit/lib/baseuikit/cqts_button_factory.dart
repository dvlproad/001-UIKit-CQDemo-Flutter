import 'package:flutter/material.dart';
import './button.dart';

/// 以主题色为背景的按钮
class CQTSThemeBGButton extends CJStateButton {
  CQTSThemeBGButton({
    Key key,
    double width,
    double height,
    @required String title,
    @required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          width: width,
          height: height,
          child: Text(title, style: TextStyle(fontSize: 16.0)),
          enable: true,
          selected: false,
          onPressed: onPressed,
          cornerRadius: 5.0,
          normalBGColor: Colors.pink,
          normalTextColor: Colors.white,
        );
}
