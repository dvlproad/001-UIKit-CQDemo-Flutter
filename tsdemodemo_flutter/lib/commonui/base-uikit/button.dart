import 'package:flutter/material.dart';

/// 文本按钮(未配置 Normal 和 Selected 风格的主题色按钮)
class TextButton extends FlatButton {
  TextButton({
    Key key,
    String text,
    double radius = 5.0,
    bool enable = true,
    @required VoidCallback onPressed,
    Color themeColor,
    Color themeDisabledColor,
  }) : super(
          key: key,
          child: Text(text,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
//          color: Colors.white,
                fontSize: 18.0,
              )),
          onPressed: enable
              ? onPressed ?? () {}
              : null, // 这里是用 onPressed 的是否为空，来内部设置 enable 属性的
          splashColor: Colors.transparent,
          color: themeColor,
          textColor: themeDisabledColor,
          highlightColor: themeColor,
          disabledColor: themeDisabledColor,
          disabledTextColor: themeColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
        );
}
