/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-25 16:13:14
 * @Description: 将数字 number 转为有单位的 string 的方法
 */

// print("${221234.toUnitString(wUnitString: "w", kUnitString: "k")}");
// print("${220000.toUnitString(wUnitString: "w", kUnitString: "k")}");
// print("${10001.toUnitString(wUnitString: "w", kUnitString: "k")}");
// print("${9001.toUnitString(wUnitString: "w", kUnitString: "k")}");
// print("${801.toUnitString(wUnitString: "w", kUnitString: "k")}");

extension Number2UnitString on num {
  /// 将数字转为含单位的字符串，如 221234 = 22.1w
  String toUnitString({
    String? wUnitString, // 万的单位(如 w 、万 等，为空表示不处理万级别)
    int wDecimalDigits = 1, // 万的小数个数(默认保存小数后一位)
    String? kUnitString,
    int kDecimalDigits = 1, // 万的小数个数(默认保存小数后一位)
  }) {
    String countValueString;
    String countUnitString;

    // 是否处理 万 级别
    if (this > 10000 && wUnitString != null) {
      double countvalue = this / 10000;
      int dotIndex = countvalue.toString().lastIndexOf("."); // 小数点的位置
      countValueString =
          countvalue.toString().substring(0, dotIndex + 1 + wDecimalDigits);
      countUnitString = wUnitString;
      return '$countValueString$countUnitString';
    }

    // 是否处理 千 级别

    if (this > 1000 && kUnitString != null) {
      double countvalue = this / 1000;
      int dotIndex = countvalue.toString().lastIndexOf("."); // 小数点的位置
      countValueString =
          countvalue.toString().substring(0, dotIndex + 1 + kDecimalDigits);
      countUnitString = kUnitString;
      return '$countValueString$countUnitString';
    }

    countValueString = "$this";
    countUnitString = '';

    return '$countValueString$countUnitString';
  }
}
