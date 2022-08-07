/*
 * @Author: dvlproad
 * @Date: 2022-04-02 04:24:14
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 00:52:50
 * @Description: 弹出视图的事件
 */
import 'package:flutter/material.dart';

class PopupUtil {
  static void popupInBottom(
    BuildContext context, {
    required Widget Function(BuildContext context) popupViewBulider,
  }) {
    showDialog(
      context: context,
      useSafeArea: false, // 要设成false，否则底部有间隙
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          popupViewBulider(context),
        ],
      ),
    );
  }
}
