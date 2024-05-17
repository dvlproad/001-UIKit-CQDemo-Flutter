/*
 * @Author: dvlproad
 * @Date: 2024-05-17 12:43:00
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-17 12:58:07
 * @Description: 将数值转为指定的格式（常用于解析后台接口返回的值）
 */

class ValueConvertUtil {
  // 将 value 转化为 string （避免后台传int）
  static String stringFrom(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is int) {
      return value.toString();
    } else if (value is double) {
      return value.toString();
    } else if (value is bool) {
      return value.toString();
    } else if (value is List) {
      return value.toString();
    } else if (value is Map) {
      return value.toString();
    } else {
      return value.toString();
    }
  }

  // 将 value 转化为 bool （避免后台传 string）
  static bool? boolFrom(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      if (value == "true") {
        return true;
      } else if (value == "false") {
        return false;
      } else {
        return null;
      }
    } else if (value is bool) {
      return value;
    } else {
      return null;
    }
  }
}
