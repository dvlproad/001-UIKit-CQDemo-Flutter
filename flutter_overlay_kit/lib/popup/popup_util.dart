/*
 * @Author: dvlproad
 * @Date: 2022-04-02 04:24:14
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-09-01 17:13:59
 * @Description: 弹出视图的事件
 */
import 'package:flutter/material.dart';

class PopupUtil {
  static Future<T?> popupInBottom<T>(BuildContext context, {
    required Widget Function(BuildContext context) popupViewBulider,
    bool isScrollControlled = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet(
      context: context,
      enableDrag: enableDrag,
      // useSafeArea: false, // 要设成false，否则底部有间隙
      // backgroundColor: Colors.black.withOpacity(0.3),
      backgroundColor: Colors.transparent,
      // 背景色
      // barrierColor: Colors.blue, // 遮盖背景颜色
      isScrollControlled: isScrollControlled,
      // 解决 showDialog/showModalBottomSheet时高度限制问题
      builder: (BuildContext context) {
        return popupViewBulider(context);
      },
    );
  }
}
