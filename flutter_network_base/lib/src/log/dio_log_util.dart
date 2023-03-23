/*
 * @Author: dvlproad
 * @Date: 2022-04-16 19:19:30
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 17:01:09
 * @Description: dio的日志输出工具
 */
import 'package:flutter/foundation.dart';

class DioLogUtil {
  /// 临时打印
  static void debugApiWithLog(String url, String message) {
    String debugApi = 'user/account/get_city';
    if (url.contains(debugApi)) {
      String dateTimeString = DateTime.now().toString().substring(0, 19);
      debugPrint('这是要调试的接口$debugApi:$dateTimeString:$message');
    }
  }
}
