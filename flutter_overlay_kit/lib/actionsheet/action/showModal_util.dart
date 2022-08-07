/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 01:29:40
 * @Description: 
 */
import 'package:flutter/material.dart';

class ShowModalUtil {
  static Future<T?> showInBottom<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet(
      context: context, //state.context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent, // 未设置会是白色，这里设成透明来修复弹出视图圆角的显示
      builder: builder,
    );
  }
}
