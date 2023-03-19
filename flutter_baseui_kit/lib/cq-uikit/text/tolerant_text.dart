import 'package:flutter/material.dart';
import './skeleton.dart';

class LazyText extends StatelessWidget {
  final String? data;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign textAlign;
  final TextOverflow? overflow;
  final double lazyWidth;
  final double lazyHeight;

  LazyText(
    this.data, {
    Key? key,
    this.textAlign = TextAlign.left,
    this.style,
    this.maxLines,
    this.overflow,
    required this.lazyWidth,
    required this.lazyHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    if (data == null) {
      backgroundColor = const Color(0xFFF0F0F0);

      return Skeleton(
        width: lazyWidth,
        height: lazyHeight,
        cornerRadius: 4,
      );
      /*
      return Container(
        width: lazyWidth ?? 10,
        height: lazyHeight ?? 10,
        color: const Color(0xFFF0F0F0),
      );
      */
    }

    return DefaultTextStyle(
      style: TextStyle(
        // 创建 paint 对象，设置 color 属性为想要的颜色
        // background: Paint()..color = backgroundColor,
        backgroundColor: backgroundColor,
        // color: style..color,
      ),
      child: TolerantText(
        data,
        maxLines: maxLines,
        textAlign: textAlign,
        style: style,
        overflow: overflow,
      ),
    );
  }
}

class TolerantText extends StatelessWidget {
  final double? height;
  final String? data;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign textAlign;
  final TextOverflow? overflow;
  // Color backgroundColor; // 文本框背景色(请在 style 中设置)

  TolerantText(
    this.data, {
    Key? key,
    this.height,
    this.textAlign = TextAlign.left,
    this.style,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;
    if (textAlign == TextAlign.left) {
      crossAxisAlignment = CrossAxisAlignment.start;
    }

    // 不用 Center 来处理竖直居中的原因是为了避免外部 Expanded
    // [flutter中如何让文本水平居中并且垂直居中？](http://findsrc.com/flutter/detail/8762)
    // child: Center(
    //     child: Text(
    //         "Hello World",
    //         textAlign: TextAlign.center,
    //     ),
    // ),
    return Container(
      // color: Colors.green,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
          // Text('我是一个垂直居中的文本'),
          Text(
            data ?? '',
            maxLines: maxLines,
            textAlign: textAlign,
            style: style,
            overflow: overflow ?? TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
