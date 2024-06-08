# flutter_webview_kit



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