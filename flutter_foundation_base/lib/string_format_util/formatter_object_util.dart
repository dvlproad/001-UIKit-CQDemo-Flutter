/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 19:02:56
 * @Description: object转格式化的字符串的工具类
 */

// import './object2StringExtension.dart';

class FormatterUtil {
  ///获取缩进空白符
  static String getDeepSpace(int deep) {
    var tab = StringBuffer();
    for (int i = 0; i < deep; i++) {
      // tab.write("\t"); // \t 占用位置太大，改用一个空格
      tab.write(" ");
    }

    return tab.toString();
  }

  ///[object] 解析的对象
  ///[deep]递归的深度，用来获取缩进的空白长度
  ///[isObject]用来区分当前map或list是不是来自某个字段，则不用显示缩进。单纯的map或list需要添加缩进
  static String convert(dynamic object, int deep, {bool isObject = false}) {
    // if (!_isDebug()) {
    //   return object.toString();
    // }
    /*
    String responseStr = '';
    if (object is Map) {
      responseStr += object.mapToStructureString();
    } else if (object is List) {
      responseStr += object.listToStructureString();
    } else {
      responseStr += object.toString();
    }
    return responseStr;
    */
    var buffer = StringBuffer();
    var nextDeep = deep + 1;
    if (object is Map) {
      var keyList = object.keys.toList();
      if (!isObject) {
        //如果map来自某个字段，则不需要显示缩进
        buffer.write(getDeepSpace(deep));
      }
      buffer.write("{");
      if (keyList.isEmpty) {
        //当map为空，不用操作，等下回在尾部补充右大括号}
      } else {
        buffer.write("\n");
        for (int i = 0; i < keyList.length; i++) {
          String keyString = keyList[i];
          buffer.write("${getDeepSpace(nextDeep)}\"$keyString\":");
          buffer.write(convert(object[keyString], nextDeep, isObject: true));
          if (i < keyList.length - 1) {
            buffer.write(",");
            buffer.write("\n");
          }
        }
      }
      buffer.write("\n");
      buffer.write("${getDeepSpace(deep)}}");
    } else if (object is List) {
      if (!isObject) {
        //如果list来自某个字段，则不需要显示缩进
        buffer.write(getDeepSpace(deep));
      }
      buffer.write("[");
      if (object.isEmpty) {
        //当list为空，直接返回T
        buffer.write("]");
      } else {
        buffer.write("\n");
        for (int i = 0; i < object.length; i++) {
          buffer.write(convert(object[i], nextDeep));
          if (i < object.length - 1) {
            buffer.write(",");
            buffer.write("\n");
          }
        }
        buffer.write("\n");
        buffer.write("${getDeepSpace(deep)}]");
      }
    } else if (object is String) {
      //为字符串时，需要添加双引号并返回当前内容
      buffer.write("\"$object\"");
    } else if (object is num || object is bool) {
      //为数字或者布尔值时，返回当前内容
      buffer.write(object);
    } else {
      //如果对象为空，则返回null字符串
      buffer.write("null");
    }
    return buffer.toString();
  }

  /*
  /// 判断是否为Debug模式
  static bool _isDebug() {
    bool inDebug = false;
    assert(inDebug =
        true); // 根据模式的介绍，可以知道Release模式关闭了所有的断言，assert的代码在打包时不会打包到二进制包中。因此我们可以借助断言，写出只在Debug模式下生效的代码
    return inDebug;
  }
  */
}
