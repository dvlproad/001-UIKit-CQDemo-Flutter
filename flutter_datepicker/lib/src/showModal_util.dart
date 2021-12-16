import 'package:flutter/material.dart';

class ShowModalUtil {
  static Future<T> showInBottom<T>({
    @required BuildContext context,
    @required WidgetBuilder builder,
    bool isScrollControlled = false,
  }) {
    showModalBottomSheet(
      context: context, //state.context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent, // 未设置会是白色，这里设成透明来修复弹出视图圆角的显示
      builder: builder,
    );
  }
}
