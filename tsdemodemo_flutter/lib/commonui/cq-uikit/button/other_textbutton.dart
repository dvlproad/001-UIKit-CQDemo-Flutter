import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/base-uikit/button.dart';

Color themeColor = Color(0xFFF56C6C);
Color themeOppositeColor = Colors.white;

/// 以主题色为背景的按钮
class CQPinkThemeBGButton extends CJTextButton {
  CQPinkThemeBGButton({
    Key key,
    String title,
    bool enable = true,
    bool selected = false,
    @required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          normalTitle: title,
          enable: enable,
          selected: selected,
          onPressed: onPressed,
          normalBGColor: themeColor,
          normalTextColor: themeOppositeColor,
          normalBorderWidth: 0.0,
          normalBorderColor: themeOppositeColor,
        );
}

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

    return CJTextButton(
      normalTitle: this.text,
      cornerRadius: height / 2,
      enable: this.enable,
      onPressed: this.onPressed,
      normalBGColor: Colors.white,
      normalTextColor: Colors.black,
    );
  }
}
