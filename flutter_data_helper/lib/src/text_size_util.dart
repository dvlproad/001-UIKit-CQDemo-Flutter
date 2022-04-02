import 'dart:math' show min;
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' show TextPainter, Size, Localizations;

// TODO：待确认难道宽高的计算已经是pt单位了（所以不能再缩放，遇到过再缩放有问题)？？
class TextSizeUtil {
  static double lastTextWidth(
    String text,
    TextStyle style, {
    BuildContext context,
    int maxLines = 2 ^ 31,
    double maxWidth = double.infinity,
  }) {
    Size textSize = boundingTextSize(
      text,
      style,
      context: context,
      maxLines: maxLines,
      maxWidth: maxWidth,
    );

    double realTextWidth = textSize.width;
    double lastTextWidth = min(realTextWidth, maxWidth);
    return lastTextWidth;
  }

  static Size boundingTextSize(
    String text,
    TextStyle style, {
    BuildContext context,
    int maxLines = 2 ^ 31,
    double maxWidth = double.infinity,
  }) {
    if (text == null || text.isEmpty) {
      return Size.zero;
    }

    Locale locale = null;
    if (context != null) {
      locale = Localizations.localeOf(context);
    }

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      locale: locale,
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);

    double textWidth = textPainter.size.width + 4; // +4是为了容错
    double textHeight = textPainter.size.height;

    return Size(textWidth, textHeight);
  }
}

class TextSizeWidget extends StatelessWidget {
  Color backgroundColor;

  String textString;
  TextStyle textStyle;
  BuildContext context;
  int maxLines;
  double maxWidth;

  TextSizeWidget({
    Key key,
    this.backgroundColor,
    @required this.textString,
    @required this.textStyle,
    this.context,
    this.maxLines = 2 ^ 31,
    @required this.maxWidth = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textString ??= '';
    Size textSize = TextSizeUtil.boundingTextSize(
      textString,
      textStyle,
      maxLines: maxLines,
      maxWidth: maxWidth,
    );

    return Container(
      width: textSize.width,
      color: this.backgroundColor ?? Colors.transparent,
      child: Text(
        textString,
        maxLines: maxLines,
        style: textStyle,
      ),
    );
  }
}
