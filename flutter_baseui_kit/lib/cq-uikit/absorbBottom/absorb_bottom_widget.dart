/*
 * @Author: dvlproad
 * @Date: 2022-04-15 14:41:42
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-05 14:47:27
 * @Description: 吸底视图
 */
import 'dart:ui' show window;
import 'package:flutter/material.dart';
import '../../flutter_baseui_kit_adapt.dart';

class AbsorbBottomContainer extends StatelessWidget {
  final Color? color;
  final double height;
  final Widget? child;
  final EdgeInsetsGeometry? childPadding;

  AbsorbBottomContainer({
    Key? key,
    this.color,
    required this.height, // 此高度为扣除底部screenBottomHeight后的高度
    this.child, // child会从bottom布局
    this.childPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    double _width = mediaQuery.size.width;
    double _height = mediaQuery.size.height;
    double screenBottomHeight = mediaQuery.padding.bottom;
    if (screenBottomHeight == 0) {
      print("///TODO:疑难杂症:这里为什么有时候会等于0，常见于点击搜索后，弹窗键盘,回来发现");
      screenBottomHeight = AdaptCJHelper.screenBottomHeight;
    }

    return Container(
      width: _width,
      height: height + mediaQuery.padding.bottom,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x339AADC8),
            offset: Offset(0.0, -5.0), //阴影xy轴偏移量
            blurRadius: 15, //阴影模糊程度
            spreadRadius: 0.5, //阴影扩散程度
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: childPadding,
            child: child,
          ),
          Container(height: screenBottomHeight),
        ],
      ),
    );
  }
}
