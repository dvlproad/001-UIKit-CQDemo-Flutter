// toolbar 上 的左右两侧按钮视图
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

import '../../flutter_baseui_kit_adapt.dart';

// 右侧按钮视图
class ToolBarActionWidget extends StatelessWidget {
  final double width;
  final Color bgColor;
  final String text;
  final Color textColor; // 导航栏标题颜色能影响到其他按钮的颜色
  // final AppBarTextColorType textColorType;
  // final ThemeBGType textColorType;

  final ImageProvider image;
  // image: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // image: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),
  final bool needUpdateImageColor; // 是否需要根据 textColorType 来自动更新图片的颜色(默认false)
  final VoidCallback onPressed;

  const ToolBarActionWidget({
    Key key,
    this.width, // 宽度(高度固定32)
    this.bgColor,
    this.text,
    this.textColor,
    this.image,
    this.needUpdateImageColor = false,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Color textColor = Color(0xFF222222);
    // if (textColorType == AppBarTextColorType.default_black) {
    //   textColor = Color(0xFF222222);
    // } else if (textColorType == AppBarTextColorType.white) {
    //   textColor = Colors.white;
    // } else if (textColorType == AppBarTextColorType.theme) {
    //   textColor = Colors.black;
    // } else if (textColorType == AppBarTextColorType.pink) {
    //   textColor = Color(0xFFFF7F00);
    // }

    if (this.text != null) {
      return ThemeBGButton(
        // bgColorType: ThemeBGType.theme,
        bgColor: bgColor,
        textColor: textColor,
        height: 32,
        width: width ?? 67,
        cornerRadius: 16,
        title: this.text,
        titleStyle: TextStyle(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
        enable: true,
        onPressed: this.onPressed,
      );
      return TextButton(
        child: Container(
          color: bgColor,
          height: 32,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(
            this.text,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
        onPressed: this.onPressed,
      );
    } else {
      Color imageColor = null;
      if (needUpdateImageColor == true) {
        imageColor = textColor;
      }

      // [Flutter Image 参数详解](https://blog.csdn.net/chenlove1/article/details/84111554)
      //BoxFit.cover:以原图填满Image为目的，如果原图size大于Image的size，按比例缩小，居中显示在Image上。如果原图size小于Image的size，则按比例拉升原图的宽和高，填充Image居中显示。
      return IconButton(
        iconSize: 36.w_pt_cj,
        icon: Image(
          image: this.image ??
              AssetImage(
                'assets/appbar/navback.png',
                package: 'flutter_effect',
              ),
          // width: 36.w_pt_cj,
          // height: 36.h_pt_cj,
          fit: BoxFit.cover,
          color: imageColor,
        ),
        onPressed: this.onPressed,
      );
    }
  }
}
