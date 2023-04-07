/*
 * @Author: dvlproad
 * @Date: 2023-03-21 17:53:28
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-03 14:12:00
 * @Description: 
 */
// 图片+文字:图片在上，文字显示在图片下边
import 'package:flutter/material.dart';

class EmptyWithImageAboveTextWidget extends StatefulWidget {
  final Color? color; // 背景颜色，用于有些页面有设置背景图片，需要对此视图设成透明色
  final ImageProvider? image;
  // image: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // image: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),
  final String mainTitle;
  final String subTitle;
  final Widget? buttonWidget;

  const EmptyWithImageAboveTextWidget({
    Key? key,
    this.color,
    this.image,
    this.mainTitle = '很抱歉，您暂无相关数据',
    this.subTitle = '去其他逛逛吧',
    this.buttonWidget,
  }) : super(key: key);

  @override
  _EmptyWithImageAboveTextWidgetState createState() =>
      _EmptyWithImageAboveTextWidgetState();
}

class _EmptyWithImageAboveTextWidgetState
    extends State<EmptyWithImageAboveTextWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnWidgets = [
      Image(
        image: widget.image ??
            AssetImage(
              'assets/empty/empty_aboveText_default.png',
              package: 'flutter_effect',
            ),
        width: 130,
        height: 102,
        fit: BoxFit.cover,
      ),
      Container(height: 24),
      Text(
        widget.mainTitle,
        style: TextStyle(
          color: Color(0xffafafaf),
          fontSize: 13,
        ),
      ),
      // Text(
      //   widget.subTitle,
      //   style: TextStyle(
      //     color: Color(0xff9a9a9a),
      //     fontFamily: 'PingFang SC',
      //     fontWeight: FontWeight.w400,
      //     fontSize: 13,
      //   ),
      // ),
      Container(height: 28),
    ];

    if (widget.buttonWidget != null) {
      columnWidgets.add(widget.buttonWidget!);
    } else {
      columnWidgets.add(Container(height: 35));
    }

    return Container(
      color: widget.color ?? Color(0xFFF0F0F0),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: columnWidgets,
      ),
    );
  }
}
