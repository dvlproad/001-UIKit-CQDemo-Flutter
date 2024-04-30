// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-27 01:44:59
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 12:03:48
 * @Description: 
 */
import 'dart:async';
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

// class CJJSInit {
//   static void Function({
//     required Map<dynamic, dynamic> shortMap,
//     required Map<dynamic, dynamic> detailMap,
//   })? callingLogHandle;

//   static void Function({
//     required bool runSuccess,
//     required Map<dynamic, dynamic> shortMap,
//     required Map<dynamic, dynamic> detailMap,
//   })? resutlLogHandle;
// }

// WebViewController js 的【添加、检查、运行】方法
extension AddCheckRunJS on WebViewController {
  static void Function({
    required Map<dynamic, dynamic> shortMap,
    required Map<dynamic, dynamic> detailMap,
  })? callingLogHandle;

  static void Function({
    required bool runSuccess,
    required Map<dynamic, dynamic> shortMap,
    required Map<dynamic, dynamic> detailMap,
  })? resutlLogHandle;

  cjjs_init({
    required void Function({
      required Map<dynamic, dynamic> shortMap,
      required Map<dynamic, dynamic> detailMap,
    })
        callingLogHandle,
    required void Function({
      required bool runSuccess,
      required Map<dynamic, dynamic> shortMap,
      required Map<dynamic, dynamic> detailMap,
    })
        resutlLogHandle,
  }) {
    AddCheckRunJS.callingLogHandle = callingLogHandle;
    AddCheckRunJS.resutlLogHandle = resutlLogHandle;
  }

  Future<void> cj_addJavaScriptChannel(
    String name, {
    required void Function(JavaScriptMessage) onMessageReceived,
  }) {
    return addJavaScriptChannel(
      name,
      onMessageReceived: (JavaScriptMessage javaScriptMessage) {
        Map<dynamic, dynamic> shortMap = {
          'name': 'h5调app: $name',
        };
        Map<dynamic, dynamic> detailMap = {
          'name': 'h5调app: $name',
          'message': javaScriptMessage.message,
        };
        callingLogHandle?.call(
          shortMap: shortMap,
          detailMap: detailMap,
        );
        onMessageReceived(javaScriptMessage);
      },
    );
  }

  Future<void> cj_runJsMethodWithParamMap(
    String jsMethodName, {
    Map? params,
  }) async {
    String jsParamJsonString = json.encode(params);
    cj_runJsMethodWithParamString(
      jsMethodName,
      jsParamJsonString: jsParamJsonString,
    );
  }

  Future<void> cj_runJsMethodWithParamString(
    String jsMethodName, {
    String? jsParamJsonString,
  }) async {
    runJsMethodWithParamString(
      jsMethodName,
      jsParamJsonString: jsParamJsonString,
      logHandle: ({
        required bool runSuccess,
        required Map<dynamic, dynamic> shortMap,
        required Map<dynamic, dynamic> detailMap,
      }) {
        resutlLogHandle?.call(
          runSuccess: runSuccess,
          shortMap: shortMap,
          detailMap: detailMap,
        );
      },
    );
  }

  /// 检查 js 方法是否存在
  Future<bool> exsitJsMethodName(
    String jsMethodName, {
    void Function(Object error)? onError,
  }) async {
    try {
      var value = await runJavaScriptReturningResult(
          "typeof $jsMethodName === 'function'");

      //兼容多个WebViewController版本result
      List list = ['1', 'true', true, 1];
      bool exsit = list.contains(value);
      return exsit;
    } catch (error) {
      onError?.call(error);
      return false;
    }
  }

  /// 执行 js 方法
  Future<void> runJsMethodWithParamString(
    String jsMethodName, {
    String? jsParamJsonString,
    required void Function({
      required bool runSuccess,
      required Map<dynamic, dynamic> shortMap,
      required Map<dynamic, dynamic> detailMap,
    })
        logHandle,
  }) async {
    // ignore: no_leading_underscores_for_local_identifiers
    _logRunJsError(String errorMessage) {
      logHandle(
        runSuccess: false,
        shortMap: {
          "app_call_js_method": 'app调h5: $jsMethodName',
          "app_call_js_args": jsParamJsonString,
        },
        detailMap: {
          "app_call_js_method": jsMethodName,
          "app_call_js_args": jsParamJsonString,
          "message": errorMessage,
        },
      );
    }

    // ignore: no_leading_underscores_for_local_identifiers
    _logRunJsSuceess(String javaScript) {
      logHandle(
        runSuccess: true,
        shortMap: {
          "app_call_js_method": 'app调h5: $jsMethodName',
          "app_call_js_args": jsParamJsonString,
        },
        detailMap: {
          "app_call_js_method": jsMethodName,
          "app_call_js_args": jsParamJsonString,
          "javaScriptString": javaScript,
        },
      );
    }

    bool exsitJSMethod = await exsitJsMethodName(
      jsMethodName,
      onError: (error) {
        _logRunJsError(error.toString());
      },
    );
    if (!exsitJSMethod) {
      return;
    }

    String javaScript = "$jsMethodName()";
    if (jsParamJsonString is String) {
      javaScript = "$jsMethodName('$jsParamJsonString')";
    }

    _logRunJsSuceess(javaScript);
    try {
      runJavaScript(javaScript).onError(
        (error, stackTrace) {
          _logRunJsError(error.toString());
        },
      );
    } catch (err) {
      _logRunJsError(err.toString());
    }
  }
}
