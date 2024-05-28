# flutter_keyboard_listener

一个应用的键盘监听(不仅可以监听键盘的显示隐藏，还可以监听键盘的高度变化)



```shell
# app
flutter create tsbaseuidemo

# package
flutter create --template=package flutter_baseui_kit
flutter create --template=package tsdemo_baseui
```

使用方法如下：

```
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    //改为如下
    WidgetsBinding.instance.addObserver(KeyBoardObserver.instance);
    WidgetsBinding.instance.removeObserver(KeyBoardObserver.instance);

    KeyBoardObserver.instance.addListener((isKeyboardShow, keyboardHeight) {
      // debugPrint('Keyboard update:$isKeyboardShow, height:$keyboardHeight');
      currentKeyboardVisible = isKeyboardShow;
      _keyboardHeight = keyboardHeight;
      _onKeyboardListener();
    });
```