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
            // color: Colors.transparent,
            // width: 250,
            // height: 200,
            child: Image.asset(
              'assets/loading_gif/loading_bj.gif',
              package: 'flutter_effect',
              width: 60,
              height: 60,
            ),
          )
          ..contentPadding = EdgeInsets.zero // 默认时会有边距

          ..loadingStyle =
              EasyLoadingStyle.custom // 设置custom，才能自定义backgroundColor
          ..boxShadow = [
            BoxShadow(color: Colors.transparent)
          ] // 设置custom后，不设置boxShadow或设为null都会取默认值，而不是真正的null
          ..backgroundColor = Colors.transparent
          ..indicatorColor = Colors
              .green // 为了自定义的backgroundColor生效，设置了 EasyLoadingStyle.custom, 导致必须设置此参数
          ..textColor = Colors
              .orange // 为了自定义的backgroundColor生效，设置了 EasyLoadingStyle.custom, 导致必须设置此参数
          ..indicatorSize = 60
          ..userInteractions = false // 当loading展示的时候，是否允许用户操作.
        ;
  }

  static show() {
    EasyLoading.show();
    // EasyLoading.show(
    //   indicator: Container(
    //     color: Colors.transparent,
    //     // width: 250,
    //     // height: 200,
    //     child: Image.asset(
    //       'assets/loading_gif/loading_bj.gif',
    //       package: 'flutter_effect',
    //       width: 160,
    //       height: 160,
    //     ),
    //   ),
    // );
  }

  static dismiss() {
    EasyLoading.dismiss();
  }
}
