import 'package:flutter/material.dart';
import '../bg_border_widget.dart';

/// 文本框行 Row 的 Container (可定制背景色、圆角、弧度的 TextField)
class CJTextFieldContainer extends StatelessWidget {
  final double height; // 文本框的高度
  final Color backgroundColor; // 文本框的背景颜色

  final Widget prefixWidget;
  final Widget suffixWidget;
  @required
  final Widget textFieldWidget;

  final double cornerRadius; // 边的圆角
  final double borderWidth; // 边宽
  final Color borderColor; // 边的颜色

  CJTextFieldContainer({
    Key key,
    this.height = 44,
    this.backgroundColor,
    this.prefixWidget,
    this.suffixWidget,
    this.textFieldWidget,
    this.cornerRadius = 0,
    this.borderWidth = 0,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> textFieldComponents = [];

    // prefixWidget
    if (this.prefixWidget != null) {
      textFieldComponents.add(this.prefixWidget);
    } else {
      textFieldComponents.add(SizedBox(width: 5));
    }

    // textField
    textFieldComponents.add(
      Expanded(
        child: this.textFieldWidget,
      ),
    );

    // suffixWidget
    if (this.suffixWidget != null) {
      textFieldComponents.add(this.suffixWidget);
    } else {
      textFieldComponents.add(SizedBox(width: 5));
    }

    return CJBGBorderWidget(
      height: this.height,
      backgroundColor: this.backgroundColor,
      cornerRadius: this.cornerRadius,
      borderColor: this.borderColor,
      borderWidth: this.borderWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        // textBaseline: TextBaseline.alphabetic,
        children: textFieldComponents,
      ),
    );
  }
}
