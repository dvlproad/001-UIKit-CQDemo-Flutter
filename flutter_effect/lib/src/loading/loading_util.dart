// loading 单例形式的弹出方法
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingUtil {
  // [Flutter EasyLoading的实现原理](https://blog.csdn.net/weixin_44492423/article/details/104388056)
  /// init EasyLoading
  static TransitionBuilder init() {
    TransitionBuilder builder = EasyLoading.init();

    _initInstance_flutter_easyloading();

    return builder;
  }

  static _initInstance_flutter_easyloading() {
    // 'You should call EasyLoading.init() in your MaterialApp',
    EasyLoading.instance
          // 自定义组件
          ..indicatorWidget = Container(
            // color: Colors.red,
            // width: 250,
            // height: 200,
            child: Image.asset(
              'assets/loading_gif/loading_bj.gif',
              package: 'flutter_effect',
              width: 160,
              height: 160,
            ),
          )
          ..indicatorSize = 160
          ..userInteractions = false // 当loading展示的时候，是否允许用户操作.
        ;
  }

  static show() {
    EasyLoading.show();
  }

  static dismiss() {
    EasyLoading.dismiss();
  }
}
