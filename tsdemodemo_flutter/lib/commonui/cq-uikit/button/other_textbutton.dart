import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/base-uikit/button.dart';

/// 以白色为背景的按钮
class WhiteThemeBGButton extends StatelessWidget {
  final String text;
  final bool enable;
  final VoidCallback onPressed;

  WhiteThemeBGButton({
    Key key,
    this.text,
    this.enable = true,
    @required this.onPressed,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return CJStateTextButton(
      normalTitle: this.text,
      cornerRadius: height / 2,
      enable: this.enable,
      onPressed: this.onPressed,
      normalBGColor: Colors.white,
      normalTextColor: Colors.black,
    );
  }
}
