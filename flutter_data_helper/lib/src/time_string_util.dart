import 'dart:math' show min;
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class TimeStringUtil {
  static String timeString(int targetMilliseconds) {
    String targetTimeString = "";

    var millisecondsSinceEpoch = new DateTime.now().millisecondsSinceEpoch;
    int i = (millisecondsSinceEpoch - targetMilliseconds) ~/ 1000;
    if (60 < i && i <= 3600) {
      targetTimeString = "${i ~/ 60}分钟前";
    } else if (3600 < i && i <= 86400) {
      targetTimeString = "${i ~/ 3600}小时前";
    } else if (86400 < i && i <= 604800) {
      targetTimeString = "${i ~/ 86400}天前";
    } else {
      DateTime targetDateTime =
          DateTime.fromMillisecondsSinceEpoch(targetMilliseconds);
      String targetDateTimeString = formatDate(targetDateTime, [
        yyyy,
        '-',
        mm,
        '-',
        dd,
      ]);
      targetTimeString = targetDateTimeString;
    }

    return targetTimeString;
  }
}
