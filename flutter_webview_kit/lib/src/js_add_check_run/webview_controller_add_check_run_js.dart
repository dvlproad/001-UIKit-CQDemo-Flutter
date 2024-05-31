// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-27 01:44:59
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-16 16:42:57
 * @Description: 
 */
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:webview_flutter/webview_flutter.dart';
import './h5_call_bridge_response_model.dart';

// WebViewController js 的【添加、检查、运行】方法
extension AddCheckRunJS on WebViewController {
  static void Function({
    required bool runSuccess,
    required Map<dynamic, dynamic> shortMap,
    required Map<dynamic, dynamic> detailMap,
  })? tryCallLogHandle;
  static void Function({
    required Map<dynamic, dynamic> shortMap,
    required Map<dynamic, dynamic> detailMap,
  })? callingLogHandle;

  cjjs_init({
    required void Function({
      required bool runSuccess,
      required Map<dynamic, dynamic> shortMap,
      required Map<dynamic, dynamic> detailMap,
    })
        tryCallLogHandle, // 尝试调用js方法（可能会发生 js 方法不存在，或者调用失败)
    required void Function({
      required Map<dynamic, dynamic> shortMap,
      required Map<dynamic, dynamic> detailMap,
    })
        callingLogHandle, // js 方法存在，成功调用时候的日志
  }) {
    AddCheckRunJS.tryCallLogHandle = tryCallLogHandle;
    AddCheckRunJS.callingLogHandle = callingLogHandle;
  }

  Future<void> cj2_addJavaScriptChannel(
    String name, {
    // 执行回调的 webViewController 是哪一个(场景：一个页面上画了两个 webView， webView1点击时候，希望webView2数字+1)
    required WebViewController? Function() callBackWebViewControllerGetBlock,
    required JSResponseModel? Function(Map<String, dynamic>? h5Params)
        onMessageReceived,
  }) {
    return cj_addJavaScriptChannel(
      name,
      onMessageReceived: (JavaScriptMessage javaScriptMessage) {
        String jsonString = javaScriptMessage.message.toString();
        Map<String, dynamic>? h5Params;
        try {
          h5Params = jsonDecode(jsonString);
        } catch (e) {
          // 字符串不是有效的 JSON，处理错误情况
          debugPrint('h5CallBridgeAction: Invalid JSON string');
        }
        JSResponseModel? jsResponseModel = onMessageReceived(h5Params);
        if (h5Params != null) {
          WebViewController? webViewController =
              callBackWebViewControllerGetBlock(); // 避免另一个 controller 在某个时刻销毁了
          String? jsMethodName = h5Params["callbackMethod"];
          if (webViewController != null &&
              jsMethodName != null &&
              jsMethodName.isNotEmpty) {
            // 此处假设执行的还是当前的 webViewController
            Map<String, dynamic>? jsCallbackMap = jsResponseModel?.toMap();
            webViewController.cj_runJsMethodWithParamMap(
              jsMethodName,
              params: jsCallbackMap,
            );
          }
        }
      },
    );
  }

  Future<void> cj2_addJavaScriptChannel_asyncReceived(
    String name, {
    // 执行回调的 webViewController 是哪一个(场景：一个页面上画了两个 webView， webView1点击时候，希望webView2数字+1)
    required WebViewController? Function() callBackWebViewControllerGetBlock,
    required Future<JSResponseModel>? Function(Map<String, dynamic>? h5Params)
        onMessageReceived,
  }) {
    return cj1_addJavaScriptChannel_callbackMap(
      name,
      callBackWebViewControllerGetBlock: callBackWebViewControllerGetBlock,
      onMessageReceived: (
        Map<String, dynamic>? h5Params,
        void Function(Map<String, dynamic> jsCallbackMap) callbackMapHandle,
      ) async {
        JSResponseModel? jsResponseModel = await onMessageReceived(h5Params);
        if (jsResponseModel != null) {
          callbackMapHandle(jsResponseModel.toMap());
        }
      },
    );
  }

  /// 用于处理所执行动作需要跨页面的事件（如实名认证、头像认证）--仅返回map中的result部分
  Future<void> cj1_addJavaScriptChannel_callbackResult(
    String name, {
    // 执行回调的 webViewController 是哪一个(场景：一个页面上画了两个 webView， webView1点击时候，希望webView2数字+1)
    required WebViewController? Function() callBackWebViewControllerGetBlock,
    required void Function(
      Map<String, dynamic>? h5Params,
      void Function(dynamic jsCallbackResult) callbackResultHandle,
    )
        onMessageReceived,
  }) {
    return cj1_addJavaScriptChannel_callbackMap(
      name,
      callBackWebViewControllerGetBlock: callBackWebViewControllerGetBlock,
      onMessageReceived: (
        Map<String, dynamic>? h5Params,
        void Function(Map<String, dynamic> jsCallbackMap) callbackMapHandle,
      ) {
        onMessageReceived(h5Params, (dynamic jsCallbackResult) {
          JSResponseModel jsResponseModel = JSResponseModel.success(
            isSuccess: true,
            result: jsCallbackResult,
          );

          callbackMapHandle(jsResponseModel.toMap());
        });
      },
    );
  }

  /// 用于处理所执行动作需要跨页面的事件（如实名认证、头像认证）--返回整个map(code、message、result)
  Future<void> cj1_addJavaScriptChannel_callbackMap(
    String name, {
    // 执行回调的 webViewController 是哪一个(场景：一个页面上画了两个 webView， webView1点击时候，希望webView2数字+1)
    required WebViewController? Function() callBackWebViewControllerGetBlock,
    required void Function(
      Map<String, dynamic>? h5Params,
      void Function(Map<String, dynamic> jsCallbackMap) callbackMapHandle,
    )
        onMessageReceived,
  }) {
    return cj1_addJavaScriptChannel(
      name,
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        callbackMapHandle(Map<String, dynamic> jsCallbackMap) {
          WebViewController? webViewController =
              callBackWebViewControllerGetBlock(); // 避免另一个 controller 在某个时刻销毁了
          if (webViewController == null) {
            return;
          }

          String? jsMethodName = h5Params?["callbackMethod"];
          if (jsMethodName == null || jsMethodName.isEmpty) {
            tryCallLogHandle?.call(
              runSuccess: false,
              shortMap: {
                "reason": '调用app方法 $name 时缺少接收返回值的方法的参数 callbackMethod'
              },
              detailMap: {
                "app_method": name,
                "argsFromH5Params": h5Params,
                "message":
                    '您通过js调用app方法，需要返回值。但传递给 $name 的参数中缺少接收返回值的方法参数 callbackMethod',
              },
            );
            return;
          }
          webViewController.cj_runJsMethodWithParamMap(
            jsMethodName,
            params: jsCallbackMap,
          );
        }

        onMessageReceived(h5Params, callbackMapHandle);
      },
    );
  }

  Future<void> cj1_addJavaScriptChannel(
    String name, {
    required void Function(Map<String, dynamic>? h5Params) onMessageReceived,
  }) {
    return cj_addJavaScriptChannel(
      name,
      onMessageReceived: (JavaScriptMessage javaScriptMessage) {
        String jsonString = javaScriptMessage.message.toString();
        Map<String, dynamic>? h5Params;
        try {
          h5Params = jsonDecode(jsonString);
        } catch (e) {
          // 字符串不是有效的 JSON，处理错误情况
          debugPrint('h5CallBridgeAction: Invalid JSON string');
        }
        onMessageReceived(h5Params);
      },
    );
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

  /// 检查 js 方法是否存在
  Future<bool> cj_exsitJsMethodName(
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

  /// 执行 js 方法
  Future<void> cj_runJsMethodWithParamString(
    String jsMethodName, {
    String? jsParamJsonString,
  }) async {
    // ignore: no_leading_underscores_for_local_identifiers
    _logRunJsError(String errorMessage) {
      tryCallLogHandle?.call(
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
      tryCallLogHandle?.call(
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

    bool exsitJSMethod = await cj_exsitJsMethodName(
      jsMethodName,
      onError: (error) {
        _logRunJsError(error.toString());
      },
    );
    if (!exsitJSMethod) {
      _logRunJsError("您调用了一个不存在的js方法:$jsMethodName"); // 先统一调用，至于外部要不要打印，再根据信息判断
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
