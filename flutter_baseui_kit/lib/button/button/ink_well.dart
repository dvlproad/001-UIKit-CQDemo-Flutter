/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 13:21:25
 * @Description: 已添加防抖的按钮
 */
import 'package:flutter/material.dart';
import '../opt/click_optimization.dart';

class BJHInkWell extends InkWell {
  BJHInkWell({
    Key? key,
    Widget? child,
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
  }) : super(
          key: key,
          child: child,
          onTap: throttle(() async {
            if (onTap != null) {
              onTap();
            }
          }),
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
        );
}
