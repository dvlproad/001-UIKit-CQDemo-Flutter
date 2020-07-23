import 'package:flutter/material.dart';

/// 文本按钮(未配置 Normal 和 Selected 风格的主题色按钮)
class TextButton extends FlatButton {
  TextButton({
    Key key,
    String text,
    bool enable,
    @required VoidCallback enableOnPressed,
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
        )
    ),
    onPressed: enable ?  enableOnPressed : null,
    splashColor: Colors.transparent,
    color: themeColor,
    textColor: themeDisabledColor,
    highlightColor: themeColor,
    disabledColor: themeDisabledColor,
    disabledTextColor: themeColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
    ),
  );
}