/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-18 02:14:50
 * @Description: 追踪id生成工具
 */
import 'dart:math';
import 'package:flutter/foundation.dart';

class TraceUtil {
  static String traceId() {
    String timeStamp = DateTime.now().microsecondsSinceEpoch.toString();
    String randomString = TraceUtil.generateRandomString(10);
    String traceId = "$timeStamp/_$randomString";
    return traceId;
  }

  // Declare a fucntion for reusable purpose
  static String generateRandomString(int len) {
    final _random = Random();
    final result = String.fromCharCodes(
        List.generate(len, (index) => _random.nextInt(33) + 89));
    return result;
  }
}
