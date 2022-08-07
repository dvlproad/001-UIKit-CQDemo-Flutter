/*
 * @Author: dvlproad
 * @Date: 2022-04-16 19:19:30
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-27 00:31:16
 * @Description: dio的日志输出工具
 */
import 'dart:convert' as convert;
import 'package:meta/meta.dart';

class DioLogUtil {
  /// 临时打印
  static void debugApiWithLog(String url, String message) {
    String debugApi = 'user/account/get_city';
    if (url.contains(debugApi)) {
      String dateTimeString = DateTime.now().toString().substring(0, 19);
      print('这是要调试的接口$debugApi:$dateTimeString:$message');
    }
  }
}
