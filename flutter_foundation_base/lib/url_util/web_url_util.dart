/*
 * @Author: dvlproad
 * @Date: 2023-01-13 18:54:24
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-13 17:05:01
 * @Description: url操作的方法(从url中获取参数、对url添加参数)
 */
import 'dart:convert';

class WebUrlUtil {
  static bool? getBoolFromArguments(
      Map<String, dynamic> arguments, String key) {
    bool? boolValue;
    if (arguments[key] != null) {
      if (arguments[key] is String) {
        if (arguments[key] == "true") {
          boolValue = true;
        } else if (arguments[key] == "false") {
          boolValue = false;
        }
      } else {
        boolValue = arguments[key];
      }
    }
    return boolValue;
  }

  static String addH5CustomParams(
    String newString,
    Map<String, dynamic> h5Params,
  ) {
    for (String h5ParamKey in h5Params.keys) {
      var h5ParamValue = h5Params[h5ParamKey]; // 类型不一定是String
      if (h5ParamValue == null) {
        continue;
      }
      late String h5ParamEncodeValue;
      if (h5ParamValue is String) {
        // h5ParamEncodeValue = h5ParamValue;
        h5ParamEncodeValue =
            Uri.encodeComponent(h5ParamValue); // 要编码，否则即使是字符串，但是含中文时候，也会出错
      } else {
        // String h5ParamParamString = h5ParamValue.toString();
        // String h5ParamParamString =
        //     FormatterUtil.convert(h5ParamValue, 0); // 使用此行来修复json字符串没有引号的问题
        String h5ParamParamString = jsonEncode(
            h5ParamValue); // 使用此行来修复json字符串没有引号的问题，且避免使用FormatterUtil.convert时候的换行问题
        h5ParamEncodeValue = Uri.encodeComponent(
            h5ParamParamString); // 要编码，否则url，在app中的webView无法识别(虽然在goole chrome或safari上可以识别)
      }

      String extraString = "$h5ParamKey=$h5ParamEncodeValue";
      if (newString.contains('?')) {
        newString += "&$extraString";
      } else {
        newString += "?$extraString";
      }
    }
    return newString;
  }

  /// 拆分url中传递的参数
  static mapFromMapParamString(String mapParamString) {
    // 根据 & 进行拆分
    List<String> paramComponents = mapParamString.split('&');
    // 根据 = 进行拆分
    Map<String, dynamic> arguments = {};
    for (var paramComponent in paramComponents) {
      List<String> paramKeyValueComponents = paramComponent.split('=');
      if (paramKeyValueComponents.length == 2) {
        String key = paramKeyValueComponents[0];
        String value = paramKeyValueComponents[1];
        value = Uri.decodeComponent(value);
        arguments[key] = value;
      }
    }
    return arguments;
  }
}
