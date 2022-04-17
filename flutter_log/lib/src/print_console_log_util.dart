/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-18 00:24:55
 * @Description: 控制台日志的打印工具(已考虑太长本来会截端的问题)
 */
import './string_format_util/long_string_print_util.dart';

class PrintConsoleLogUtil {
  static const String _TAG_DEFAULT = "###qianqianqian###\n";
  static bool _hasInit = false;
  static void printConsoleLog(String tag, String stag, Object object) {
    if (_hasInit != true) {
      // 参数可选 isDebug默认true limitLength默认800
      LongStringPrintUtil.init(title: "来自LogUtil", limitLength: 800);
      _hasInit = true;
    }

    if (object is String) {
      // print(object);
      LongStringPrintUtil.newPrint(object);
      return;
    }

    StringBuffer sb = StringBuffer();
    sb.write((tag == null || tag.isEmpty) ? _TAG_DEFAULT : tag);
    sb.write('\n');
    sb.write(stag);
    sb.write('\n');
    sb.write(object);
    // print(sb.toString());
    LongStringPrintUtil.newPrint(sb.toString());
  }
}
