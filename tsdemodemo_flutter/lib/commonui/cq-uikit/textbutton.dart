import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/base-uikit/button.dart';

/// 主题背景按钮
class ThemeBGButton extends StatelessWidget {
  final String text;
  final bool enable;

  @required
  final VoidCallback onPressed;

  ThemeBGButton({Key key, this.text, this.enable = true, this.onPressed})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      text: this.text,
      enable: this.enable,
      onPressed: this.onPressed,
      themeColor: Color(0xFFF56C6C),
      themeDisabledColor: Colors.white,
    );
  }
}

/// 白色主题背景按钮
class WhiteThemeBGButton extends StatelessWidget {
  final String text;
  final bool enable;

  @required
  final VoidCallback onPressed;

  WhiteThemeBGButton({Key key, this.text, this.enable = true, this.onPressed})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return TextButton(
      text: this.text,
      radius: height / 2,
      enable: this.enable,
      onPressed: this.onPressed,
      themeColor: Colors.white,
      themeDisabledColor: Colors.black,
    );
  }
}
