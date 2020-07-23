import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/base-uikit/button.dart';

/// 主题背景按钮
class ThemeBGButton extends StatefulWidget {
  final String text;
  final bool enable;
  @required VoidCallback enableOnPressed;

  ThemeBGButton({
    Key key, this.text, this.enable, this.enableOnPressed
  }) : super(
      key: key,
  );


  @override
  State<StatefulWidget> createState() {
    return _ThemeBGButtonState();
  }
}

class _ThemeBGButtonState extends State<ThemeBGButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      text: widget.text,
      enable: widget.enable,
      enableOnPressed: widget.enableOnPressed,
      themeColor: Color(0xFFF56C6C),
      themeDisabledColor: Colors.white,
    );
  }
}