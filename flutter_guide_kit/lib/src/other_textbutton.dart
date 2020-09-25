import 'package:flutter/material.dart';
import './textbutton.dart';

/// 以白色为背景的按钮
/// 来源于 cq-uikit/button/other_textbutton/CQWhiteThemeBGButton 
class GuideOKButton extends StatelessWidget {
  final String text;
  final bool enable;
  final VoidCallback onPressed;

  GuideOKButton({
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