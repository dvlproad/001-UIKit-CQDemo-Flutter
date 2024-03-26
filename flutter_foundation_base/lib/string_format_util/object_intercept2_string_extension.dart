// ignore_for_file: constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-13 11:05:05
 * @Description: object 截取转 string 的方法
 */
import 'dart:math';
import 'formatter_object_util.dart';

class MapsIntercept2StringUtil {
  /// 将maps数组转换为string，并设置截取的最大长度
  static String maps2String(
    List<Map<String, dynamic>> maps, {
    List<String>? onlyKeys, // 只获取哪些key
    int? maxLength,
  }) {
    String mapsString = '';

    int mapCount = maps.length;
    for (int i = 0; i < mapCount; i++) {
      Map<String, dynamic> item = maps[i];
      String mapString = item.map2StringWithoutKey(
        keyLineBreakString: " ",
        onlyKeys: onlyKeys,
      );

      if (maxLength != null && maxLength > 0) {
        mapString = mapString.substring(0, min(mapString.length, maxLength));
      }
      if (i < mapCount) {
        mapString += '\n';
      }
      mapsString += '${i + 1}:$mapString';
    }
    return mapsString;
  }
}

extension MapIntercept2StringExtension on Map {
  /// 只提取map中的value值(key值没需要)
  String map2StringWithoutKey({
    String keyLineBreakString = "\n", // 换行符
    List<String> withoutkeys = const [], // 不获取哪些key
    List<String>? onlyKeys, // 只获取哪些key
  }) {
    Map<dynamic, dynamic> logJsonMap = this;
    if (logJsonMap.isEmpty) {
      return '';
    }
    String logJsonString = '';
    Iterable requestKeys = logJsonMap.keys;
    if (onlyKeys != null) {
      requestKeys = onlyKeys;
    }
    for (var key in requestKeys) {
      if (withoutkeys.contains(key)) {
        continue;
      }
      Object keyValue = logJsonMap[key];
      String keyValueString = keyValue.toString();

      logJsonString += "$keyValueString$keyLineBreakString";
    }
    logJsonString = logJsonString.substring(
        0, logJsonString.length - keyLineBreakString.length);
    return logJsonString;
  }

  String map2StringWitKey({
    String keyLineBreakString = "\n", // 换行符
  }) {
    Map<dynamic, dynamic> logJsonMap = this;
    if (logJsonMap.isEmpty) {
      return '';
    }
    String logJsonString = '';

    // if (detailLogJsonMap["METHOD"] == "GET") {
    //   // debug;
    // }
    // int keyCount = logJsonMap.keys.length;
    // for (var i = 0; i < keyCount; i++) {
    //   String key = logJsonMap.keys[i];
    for (var key in logJsonMap.keys) {
      Object keyValue = logJsonMap[key];
      String keyValueString =
          FormatterUtil.convert(keyValue, 0, isObject: true);
      // if (i > 0) {
      //   logJsonString += "\n";
      // }
      logJsonString += "- $key:\n$keyValueString\n";
      logJsonString += keyLineBreakString;
    }
    logJsonString = logJsonString.substring(
        0, logJsonString.length - keyLineBreakString.length - 1);
    return logJsonString;
  }
}
