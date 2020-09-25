import 'package:flutter/material.dart';

class DottedLineWidget extends StatelessWidget {
  final Axis axis; // 虚线的方向
  final double width; // 整个虚线的宽度
  final double height; // 整个虚线的高度
  final double lineWidth; // 每根虚线的宽度
  final double lineHeight; // 每根虚线的高度
  final int count; // 虚线内部实线的个数
  final Color color; // 虚线的颜色(默认红色)

  DottedLineWidget({
    Key key,
    @required this.axis,
    this.width,
    this.height,
    this.lineWidth,
    this.lineHeight,
    this.count,
    this.color = const Color(0xffff0000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Flex(
            direction: this.axis,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(this.count, (int index) {
              return SizedBox(
                width: this.lineWidth,
                height: this.lineHeight,
                child:
                    DecoratedBox(decoration: BoxDecoration(color: this.color)),
              );
            }),
          );
        },
      ),
    );
  }
}
