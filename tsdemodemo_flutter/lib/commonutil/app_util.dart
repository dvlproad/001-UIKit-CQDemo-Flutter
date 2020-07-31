/*
 * @Author: MrLiuYS
 * @Date: 2020-06-30 13:28:48
 * @LastEditors: linweixiang
 * @LastEditTime: 2020-07-27 20:47:11
 * @Description: 基础工具
 */

import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

class AppUtil {
  static String formatNumber(num count) {
    String str;
    if (count < 1000) {
      str = "$count";
    } else {
      str = "${_formatNumber(count / 1000, maxPoint: 1)}k";
    }
    return str;
  }

  static String _formatNumber(num num, {int minPoint = 2, int maxPoint = 2}) {
    var f = NumberFormat.decimalPattern();
    f.minimumFractionDigits = minPoint;
    f.maximumFractionDigits = maxPoint;
    return f.format(num);
  }

  //复制信息到粘贴板
  static copyData(String txt) {
    ClipboardData data = new ClipboardData(text: txt);
    Clipboard.setData(data);
  }
}
