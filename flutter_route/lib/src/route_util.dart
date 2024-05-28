/*
 * @Author: dvlproad
 * @Date: 2024-03-29 18:08:54
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-29 18:12:16
 * @Description: 
 */
import 'package:flutter/material.dart';

class CJRouteUtil {
  /// 关闭从哪开始的页面
  static closeFromRouteName(BuildContext context, String routeName) {
    // 错误的方法
    // Navigator.of(context).popUntil((route) => route.isFirst); // 会导致 [个人中心查看愿望详情时选择打卡，打卡发布动态成功之后直接返回个人中心的愿望单页面](https://chandao.xihuanwu.com/bug-view-1955.html)

    // 正确的方法
    Navigator.of(context).popUntil((route) => route.settings.name == routeName);
    Navigator.of(context).pop();
  }
}
