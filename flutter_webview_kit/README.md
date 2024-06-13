# flutter_webview_kit

[toc]



```shell
# app
flutter create tsbaseuidemo

# package
flutter create --template=package flutter_baseui_kit
flutter create --template=package tsdemo_baseui
```



## 一、JS





## 二、JS注入方法

可实现在原有网页上增加按钮，点击按钮后执行JS代码

```dart
// 使用方法1: 在网页上添加按钮
controller.injectedJs()

// 使用方法2: 在原生上添加按钮
AddJSChannel_InjectedJS.testJSInjectedButton
AddJSChannel_InjectedJS.testJSRunButton()
```

方法1的示例：

```dart
    Future<bool> injectedJs_demo() async {
    String addPosition = 'top';
    String execJSMethod = "testInjectedMethod_showJsonWithCallbackMethod";
    Map<String, dynamic> execJSParams = {
      // "callbackMethod": "alert",
      "callbackMethod": "h5CallBridgeAction_showAppToast",
      "message": "这是测试运行注入的js",
      "dialogSubjectId": "1234567890",
      "dialogType": "user",
    };

    return injectedJs(
      execJSMethod: execJSMethod,
      execJSParams: execJSParams,
      execJSCallBackMapGetHandle: () {
        var sendMessage = {
          "h5Title": "这是h5内部返回的标题1",
          "h5Message": "这是h5内部返回的描述信息2",
          "message": "这是h5内部返回的描述信息message3",
        };
        return sendMessage;
      },
      injectedUIPosition: addPosition,
    );
  }
```

方法2的示例：
```dart
        Container(
          color: Colors.amber,
          height: 2 * 40 + 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AddJSChannel_InjectedJS.testJSInjectedButton(
                execJSMethod: execJSMethod,
                webViewControllerGetBlock: () => _controller,
              ),
              AddJSChannel_InjectedJS.testJSRunButton(
                execJSMethod: execJSMethod,
                execJSParams: execJSParams,
                hasInjectedJS: hasInjectedJS,
                webViewControllerGetBlock: () => _controller,
              ),
            ],
          ),
        )
```



## 三、原理

### 1、注入点击按钮

1、创建要注入的元素/区域

```dart
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
      """;
```

设置按钮文本和点击事件

```dart
详见：下文【2、注入按钮要执行的js方法】中的【将注入的事件绑定到注入的按钮的点击事件上】
```

2、注入位置 top(默认) \ bottom \ overlay 

```dart
injectedUIHtml += """
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
```

3、注入时机 onload / now

```dart
injectedUIHtml += """
		if (injectedTime == 'onload') {
      injectedUIHtml = """
        window.addEventListener('load', function() {
          $injectedUIHtml
        });
      """;
    }
    """;

    return runJavaScript(injectedUIHtml);
```

如此，页面上就有有一个注入进去的按钮。

### 2、注入按钮要执行的js方法

1、注入按钮要执行的js方法及让js调用app方法的核心如下：

```dart
	"""
		window[`\${injectedJSMethod}`] = function(json) {
      console.log(`正在执行:\${injectedJSMethod}`)
      ......xxx......
      
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
```

完整如下：

```dart
Future<bool> _injectedJavaScript({
    required String jsMethod,
    Map<String, dynamic> Function()? execJSCallBackMapGetHandle,
  }) async {
    String? execJSCallBackJson;
    if (execJSCallBackMapGetHandle != null) {
      Map<String, dynamic> execJSCallBackMap = execJSCallBackMapGetHandle();
      execJSCallBackJson = json.encode(execJSCallBackMap);
    }

    String addJavaScript = """
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

      var execMessage = `正在执行app调用h5，并返回回调:`
      execMessage += `\n执行js方法:\${injectedJSMethod}`
      execMessage += `\n执行js参数:\${JSON.stringify(arguments)}`
      execMessage += `\n回调方法:\${callbackMethod}`
      var sendMessageString = `$execJSCallBackJson`;
      if (sendMessageString === undefined || sendMessageString === null) {
        sendMessageString = "";
      }
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
```

### 3、将注入的事件绑定到注入的按钮的点击事件上，设置按钮文本和点击事件

```dart
injectedUIHtml += """
					var jsMethod2 = `$execJSMethod`
          newButton.textContent = `点击我\n执行\${jsMethod2}`;
          // 添加点击事件处理器
          newButton.onclick = function() {
            // 原始代码
            // window.testInjectedMethod_showJsonWithCallbackMethod(JSON.stringify({
            //   "callbackMethod": "h5CallBridgeAction_showAppToast",
            //   "message": "这是测试运行注入的js",
            // }));

            // 外部变量代码
            var jsMethod = `$execJSMethod`
            var sendMessageString = `$execJSJsonParams`; // 外部的map无法传到内部，需要转为string
            // alert(`按钮被点击了！\${sendMessageString}`);
            window[`\${jsMethod}`](sendMessageString);
          };
          """;
```





## End