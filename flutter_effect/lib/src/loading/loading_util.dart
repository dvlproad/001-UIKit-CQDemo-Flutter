// loading 单例形式的弹出方法
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import './loading_widget.dart';

OverlayEntry pageOverlayEntry;

class LoadingUtil {
  // [Flutter EasyLoading的实现原理](https://blog.csdn.net/weixin_44492423/article/details/104388056)
  /// init EasyLoading
  static TransitionBuilder init() {
    TransitionBuilder builder = EasyLoading.init();

    // config_flutter_easyloading();

    return builder;
  }

  static config_flutter_easyloading() {
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

  /// 在 context 中展示 loading ，(一定记得在 dispose 方法中调用 LoadingUtil.dismissInContext(context);)
  static showInContext(BuildContext context) {
    assert(context != null);
    double left = MediaQuery.of(context).size.width / 2 - 100 / 2;
    double top = MediaQuery.of(context).size.height / 2 - 100 / 2;
    Widget child = LoadingWidget();

    pageOverlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: top,
          left: left,
          child: GestureDetector(
            onTap: () async {
              dismissInContext(context);
            },
            child: child,
          ),
        );
      },
    );

    Overlay.of(context).insert(pageOverlayEntry);
  }

  static dismissInContext(BuildContext context) {
    pageOverlayEntry?.remove();
  }
}
