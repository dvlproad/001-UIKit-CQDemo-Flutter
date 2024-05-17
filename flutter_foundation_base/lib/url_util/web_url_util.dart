// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2023-01-13 18:54:24
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-13 17:05:01
 * @Description: 
 */
import 'dart:convert';

import 'package:flutter/foundation.dart';

extension WebUrlExtension on String {
  /// 为当前的 web url 添加其他额外参数（参数的值如果是对象，则会自动 jsonEncode)
  String? cj_addCustomParams(Map<String, dynamic> addParams) {
    String? addParamsString = WebUrlUtil.encodeParam(addParams);
    if (addParamsString == null || addParamsString.isEmpty) {
      return this;
    }

    if (contains('?')) {
      return "$this&$addParamsString";
    } else {
      return "$this?$addParamsString";
    }
  }

  /// 获取 url host: String getUrlHostFromWebUrl(String webUrl);
  String cj_getUrlHostFromWebUrl() {
    Uri uri = Uri.parse(this);
    return uri.host;
  }

  /// 获取 all params: Map<String, dynamic>? getAllParamsFromWebUrl(String webUrl, {required bool paramToObjectIfOK})
  Map<String, dynamic>? cj_getAllParamsFromWebUrl({
    required bool paramToObjectIfOK,
  }) {
    Uri uri = Uri.parse(this);
    Map<String, dynamic>? params = uri.queryParameters;
    // ignore: unnecessary_null_comparison
    if (params == null) {
      return null;
    }

    if (paramToObjectIfOK) {
      params.forEach((key, value) {
        if (value is String) {
          params[key] = jsonDecode(value);
        }
      });
    }

    return params;
  }
}

class WebUrlUtil {
  /// 为当前的 web url 添加其他额外参数（参数的值如果是对象，则会自动 jsonEncode)
  ///
  /// PS1: 获取 url host: String getUrlHostFromWebUrl(String webUrl);
  /// PS2: 获取 all params: Map<String, dynamic>? getAllParamsFromWebUrl(String webUrl, {required bool paramToObjectIfOK})
  static String getNewWebUrlByAddParams(
    String currentWebUrl,
    Map<String, dynamic> addParams,
  ) {
    String? addParamsString = encodeParam(addParams);
    if (addParamsString == null || addParamsString.isEmpty) {
      return currentWebUrl;
    }
    if (currentWebUrl.contains('?')) {
      return "$currentWebUrl&$addParamsString";
    } else {
      return "$currentWebUrl?$addParamsString";
    }
  }

  static String? encodeParam(Map<String, dynamic> h5Params) {
    if (h5Params.isEmpty) {
      return null;
    }
    List<String> addParamArray = [];
    for (String h5ParamKey in h5Params.keys) {
      var h5ParamValue = h5Params[h5ParamKey]; // 类型不一定是String
      String? h5ParamEncodeValue = encodeParamValue(h5ParamValue);
      if (h5ParamEncodeValue == null) {
        continue;
      }

      String extraString = "$h5ParamKey=$h5ParamEncodeValue";
      addParamArray.add(extraString);
    }

    String addParamsString = addParamArray.join('&');
    return addParamsString;
  }

  /// 将对象转化为web url可识别的字符串参数（对且仅对第一层转化）
  ///
  /// [h5ParamValue]：要获取参数的对象。
  ///
  /// 返回web url可识别的字符串参数。
  ///
  /// 例如：{'shouldHideNavBar': true}
  /// 返回："%7B%22shouldHideNavBar%22%3Atrue%7D"
  static String? encodeParamValue(dynamic h5ParamValue) {
    if (h5ParamValue == null) {
      return null;
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

    return h5ParamEncodeValue;
  }

  /// 获取指定web地址的 url host
  ///
  /// 例如：https://www.baidu.com/?a=1&b=2
  /// 返回：https://www.baidu.com
  static String getUrlHostFromWebUrl(String webUrl) {
    var paramStartIndex = webUrl.indexOf('?');
    if (paramStartIndex == -1) {
      return webUrl;
    }

    var str = webUrl.substring(0, paramStartIndex);
    return str;
  }

  /// 获取指定web地址的所有参数
  ///
  /// [webUrl]：要获取参数的地址。
  ///
  /// [paramToObjectIfOK]：一个布尔值，指示是否将参数值转换为对象（如果可能）。PS:怕外部不知道此方法所以此处不设置默认值
  ///
  /// 返回包含地址参数的Map对象，其中参数名作为键，参数值作为值。
  ///
  /// 例如：https://www.baidu.com/?a=1&b=2
  /// 返回：{a: 1, b: 2}
  static Map<String, dynamic>? getAllParamsFromWebUrl(
    String webUrl, {
    required bool paramToObjectIfOK,
  }) {
    var paramStartIndex = webUrl.indexOf('?');
    if (paramStartIndex == -1) {
      return null;
    }

    Map<String, dynamic> paramMap = {};
    var str = webUrl.substring(paramStartIndex + 1);
    var strs = str.split('&');

    for (var i = 0; i < strs.length; i++) {
      var keyValueComponent = strs[i].split('=');
      var key = keyValueComponent[0];
      String value = keyValueComponent[1];
      dynamic element = getValueFromWebParamValueString(
        value,
        paramToObjectIfOK: paramToObjectIfOK,
      );

      paramMap[key] = element;
    }

    return paramMap;
  }

  /// 将字符串value按需求转成 string 或者 object(如果可以转的情况下)
  ///
  /// [value]：要处理的参数的值。
  ///
  /// [paramToObjectIfOK]：一个布尔值，指示是否将参数值转换为对象（如果可能）。默认为false。
  ///
  /// 返回参数值的处理结果。
  static dynamic getValueFromWebParamValueString(
    String? value, {
    bool paramToObjectIfOK = false,
  }) {
    if (value == null) return null;
    try {
      value = Uri.decodeComponent(value);
    } catch (error) {
      // value = value;
      debugPrint("不用解码");
    }

    if (paramToObjectIfOK != true) {
      return value;
    }

    dynamic element; // 如果 json.decode 成功，返回类型会变化，所以需另声明变量
    try {
      element = json.decode(value!);
    } catch (error) {
      element = value;
    }
    return element;
  }

  /*
  static Map? getMapFromArguments(Map<String, dynamic> arguments, String key) {
    if (arguments[key] == null) {
      return null;
    }

    var element = arguments[key];
    if (element is String) {
      return getValueFromWebParamValueString(element, paramToObjectIfOK: true);
    } else if (element is Map) {
      return element;
    } else {
      return null;
    }
  }

  static List<String>? getStringListFromArguments(
      Map<String, dynamic> arguments, String key) {
    if (arguments[key] == null) {
      return null;
    }

    List taskIdMaps = [];
    if (arguments[key] is List) {
      taskIdMaps = arguments[key];
    } else if (arguments[key] is String) {
      String pTaskIds = arguments[key];
      if (pTaskIds.startsWith("[") && pTaskIds.endsWith("]")) {
        pTaskIds = pTaskIds.substring(1, pTaskIds.length - 1);
      }
      taskIdMaps = pTaskIds.split(",");
    }

    List<String> taskIds = [];
    for (var element in taskIdMaps) {
      if (element is int) {
        taskIds.add(element.toString()); // 避免后台传int
      } else {
        taskIds.add(element);
      }
    }

    return taskIds;
  }

  static List? getListFromArguments(
      Map<String, dynamic> arguments, String key) {
    if (arguments[key] == null) {
      return null;
    }

    if (arguments[key] is List) {
      return arguments[key];
    } else if (arguments[key] is String) {
      String elementsString = arguments[key];
      return getValueFromWebParamValueString(elementsString,
          paramToObjectIfOK: true);
    }
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
        try {
          value = Uri.decodeComponent(value);
        } catch (e) {
          //
        }

        arguments[key] = value;
      }
    }
    return arguments;
  }
  */
}
