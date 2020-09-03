import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/base-uikit/button/textbutton.dart';

/// 以白色为背景的按钮
class CQWhiteThemeBGButton extends StatelessWidget {
  final String text;
  final bool enable;
  final VoidCallback onPressed;

  CQWhiteThemeBGButton({
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

/// 透明背景，白色字的按钮( selected 属性的值无法影响 ui 样式)
class CQTransparentBGButton extends CJStateTextButton {
  CQTransparentBGButton({
    Key key,
    @required String title,
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
          normalBGColor: Colors.transparent,
          normalTextColor: Colors.white,
          // normalBorderWidth: 0.0,
          // normalBorderColor: themeOppositeColor,
        );
}
