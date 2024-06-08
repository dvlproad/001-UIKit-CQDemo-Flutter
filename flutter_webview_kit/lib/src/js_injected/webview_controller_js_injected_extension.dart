// ignore_for_file: non_constant_identifier_names, camel_case_extensions
// 使用方法1: controller.injectedJs()
// 使用方法2: AddJSChannel_InjectedJS.testJSInjectedButton AddJSChannel_InjectedJS.testJSRunButton()

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../js_add_check_run/webview_controller_add_check_run_js.dart';

extension AddJSChannel_InjectedJS on WebViewController {
  Future<bool> injectedJs({
    required String execJSMethod,
    required Map<String, dynamic> execJSParams,
    String injectedUIPosition = 'none',
  }) async {
    bool injectedSuccess = await _injectedJavaScript(jsMethod: execJSMethod);

    if (['top', 'bottom', 'overlay'].contains(injectedUIPosition)) {
      // 如果不需要在html中注入UI来执行Js，而是原生按钮执行JS，请使用 testJSRunButton
      injectedJavaScript_UI_execJSWhenClick(
        addPosition: injectedUIPosition,
        execJSMethod: execJSMethod,
        execJSParams: execJSParams,
      );
    }

    return injectedSuccess;
  }

  Future<bool> _injectedJavaScript({required String jsMethod}) async {
    String addJavaScript = """
    // 定义showToast方法
    window.showToastNone = function() {
      message = "【没接收参数】"
      alert(message);
    };
    window.showToastAAA = function(message) {
      message = "【原始fromText】" + message
      alert(message);
    };
    window.showToastAAAForMap = function(message) {
      var arguments = JSON.parse(message);
      var message = arguments['message'];
      var callbackMethod = arguments['callbackMethod'];
      message = "【原始fromJson】" + message
      // alert(message);
      // return;

      if (callbackMethod === undefined || callbackMethod === null) {
        var errorMessage = "【原始fromJson】缺少 callbackMethod 参数";
        alert(errorMessage);
        return;
      }
      var sendMessage = {
        "h5Title": "这是h5的标题",
        "h5Message": "这是h5的描述信息",
      };
      var sendMessageString = JSON.stringify(sendMessage)
      eval("showToastAAA(sendMessageString)");
    };

    showToastBBB = function(message) {
      alert(message);
    };

    // 测试方法带回调
    // 方法一：
    // window.testInjectedMethod_showJsonWithCallbackMethod = function(json) {
    // 方法二：使用变量。📢:注意js中使用 外部变量 和 使用内部变量 的写法区别
    // var injectedJSMethod = "testInjectedMethod_showJsonWithCallbackMethod"
    var injectedJSMethod = `$jsMethod`;
    window[`\${injectedJSMethod}`] = function(json) {
      console.log(`正在执行:\${injectedJSMethod}`)
      var arguments = JSON.parse(json);
      var callbackMethod = arguments['callbackMethod'];
      if (callbackMethod === undefined || callbackMethod === null) {
        var errorMessage = "缺少 callbackMethod 参数";
        alert(errorMessage);
        return;
      }
      delete arguments.callbackMethod; // 删除键为 'callbackMethod' 的属性

      var sendMessage = {
        "h5Title": "这是h5内部返回的标题",
        "h5Message": "这是h5内部返回的描述信息",
        "message": "这是h5内部返回的描述信息message",
      };
      var sendMessageString = JSON.stringify(sendMessage)
      var execMessage = `正在执行app调用h5，并返回回调:`
      execMessage += `\n执行js方法:\${injectedJSMethod}`
      execMessage += `\n执行js参数:\${JSON.stringify(arguments)}`
      execMessage += `\n回调方法:\${callbackMethod}`
      execMessage += `\n回调值:\${sendMessageString}`
      console.log(execMessage)
      alert(execMessage);
      var funName = callbackMethod;
      var sendMessage = sendMessageString;
      try {
        eval(funName).postMessage(sendMessage);
      } catch (err) {
        var evalErrorMessage = `【执行错误如下】\n方法：\${funName} \n原因：\${err}`;
        console.log(evalErrorMessage);
        alert(evalErrorMessage);
      }
    };
  """;

    await runJavaScript(addJavaScript);

    return true;
  }

  Future<void> injectedJavaScript_UI_execJSWhenClick({
    String addPosition = 'top', // top(默认) \ bottom \ overlay
    required String execJSMethod,
    required Map<String, dynamic> execJSParams,
  }) async {
    String execJSJsonParams = json.encode(execJSParams);

    String injectedUIHtml = """
          // 创建一个新的按钮元素
          var newButton = document.createElement("button");
          // 设置按钮的样式
          newButton.style.height = '200px';
          newButton.style.width = '320px'; // 可以根据需要设置宽度
          newButton.style.backgroundColor = '#4CAF50'; // 设置背景颜色
          newButton.style.color = 'white'; // 设置文字颜色
          newButton.style.border = 'none'; // 去除边框
          newButton.style.cursor = 'pointer'; // 鼠标悬停时显示指针 
          // 设置按钮的文本
          newButton.textContent = '点击我';
          var jsMethod2 = `$execJSMethod`
          newButton.textContent = `点击我\n执行\${jsMethod2}`;
          // 添加点击事件处理器
          newButton.onclick = function() {
            // alert(`按钮被点击了！！！`);
            // 这里可以添加按钮点击时想要执行的逻辑

            // 原始代码
            // window.testInjectedMethod_showJsonWithCallbackMethod(JSON.stringify({
            //   "callbackMethod": "h5CallBridgeAction_showAppToast",
            //   "message": "这是测试运行注入的js",
            // }));

            // 内部变量代码
            // var jsMethod = "testInjectedMethod_showJsonWithCallbackMethod"
            // var jsParams = {
            //   // "callbackMethod": "alert",
            //   "callbackMethod": "h5CallBridgeAction_showAppToast",
            //   "message": "这是测试运行注入的js",
            //   "dialogSubjectId": "1234567890",
            //   "dialogType": "user",
            // };
            // var sendMessageString = JSON.stringify(jsParams)
            
            // 外部变量代码
            var jsMethod = `$execJSMethod`
            var sendMessageString = `$execJSJsonParams`; // 外部的map无法传到内部，需要转为string
            // alert(`按钮被点击了！\${sendMessageString}`);
            window[`\${jsMethod}`](sendMessageString);
          };

          // 📢:使用外部变量 `$addPosition`
          // 📢:使用内部变量 `\${myContentPosition}`
          var myContentPosition = `$addPosition`
          if (`\${myContentPosition}` == 'bottom') {
            // 将按钮添加到body中，可以根据需要添加到其他位置
            document.body.appendChild(newButton);
          } else if (`\${myContentPosition}` == 'overlay') {
            newButton.style.position = 'fixed'; // 固定位置，不随页面滚动
            newButton.style.top = '0'; // 定位到页面顶部
            newButton.style.left = '0'; // 定位到页面左侧
            newButton.style.zIndex = '1000'; // 确保按钮在页面最上层
            newButton.innerHTML = '<div style="padding: 20px; text-align: center;">点击我啊</div>';
            document.body.insertAdjacentElement('afterbegin', newButton);
          } else {
            // 将按钮添加到body的第一个子元素，使其成为页面内容的顶部
            document.body.insertBefore(newButton, document.body.firstChild);
          }
      """;

    return runJavaScript(injectedUIHtml);
  }

  /// 测试 js 注入/重写/覆盖 的按钮
  static Widget testJSInjectedButton({
    double width = 100,
    double height = 40,
    required WebViewController? Function() webViewControllerGetBlock,
    required String execJSMethod,
  }) {
    return FutureBuilder<bool>(
      future: webViewControllerGetBlock()?.cj_exsitJsMethodName(execJSMethod),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 请求未结束，显示loading
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        // 请求已结束，但是请求失败，显示错误
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        // 请求已结束，且请求成功，显示数据
        // return Text("Contents: ${snapshot.data}");
        bool hasInjectedJS = snapshot.data ?? false;
        String title = hasInjectedJS ? "进行重新注入js" : "进行首次注入js";
        return _testJSButton(
          width: width,
          height: height,
          title: title,
          onTap: () async {
            WebViewController? webViewController = webViewControllerGetBlock();
            if (webViewController == null) {
              return;
            }

            webViewController._injectedJavaScript(jsMethod: execJSMethod);
          },
        );
      },
    );
  }

  /// 测试 js 执行的按钮
  static Widget testJSRunButton({
    double width = 100,
    double height = 40,
    required bool hasInjectedJS,
    required WebViewController? Function() webViewControllerGetBlock,
    required String execJSMethod,
    required Map<String, dynamic> execJSParams,
  }) {
    return FutureBuilder<bool>(
      future: webViewControllerGetBlock()?.cj_exsitJsMethodName(execJSMethod),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 请求未结束，显示loading
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        // 请求已结束，但是请求失败，显示错误
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        // 请求已结束，且请求成功，显示数据
        // return Text("Contents: ${snapshot.data}");
        bool hasInjectedJS = snapshot.data ?? false;
        String title = "测试js(${hasInjectedJS ? "已注入" : "未注入"})";
        return _testJSButton(
          width: width,
          height: height,
          title: title,
          onTap: () async {
            WebViewController? webViewController = webViewControllerGetBlock();
            if (webViewController == null) {
              return;
            }
            // 原始的代码
            // bool isExsit = await cj_exsitJsMethodName(execJSMethod);
            // String exsitMessage = "${isExsit ? '✅存在' : '❌不存在'} $execJSMethod 方法";
            // webViewController.runJavaScript("alert('$exsitMessage');");

            // 变量方法的代码
            // String jsMessage = jsonEncode(execJSParams);
            // String callJavaScriptFunction = "alert('$jsMessage');";
            // String callJavaScriptFunction = "window.testInjectedMethod_showJsonWithCallbackMethod('$jsMessage');";
            // webViewController.runJavaScript(callJavaScriptFunction);

            // 封装方法的代码
            // webViewController.cj_runJsMethodWithParamString("alert", jsParamJsonString: "测试原生执行js");
            webViewController.cj_runJsMethodWithParamMap(execJSMethod,
                params: execJSParams);
          },
        );
      },
    );
  }

  /// 按钮
  static Widget _testJSButton({
    double width = 100,
    double height = 40,
    required String title,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2.0),
          color: Colors.blue,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'PingFang SC',
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
