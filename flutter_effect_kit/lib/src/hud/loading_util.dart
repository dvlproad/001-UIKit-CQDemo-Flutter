// loading 单例形式的弹出方法
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import './loading_widget.dart';

OverlayEntry pageOverlayEntry;
OverlayEntry doingTextOverlayEntry;

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
          ..indicatorWidget = _loadingWidget
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

  static Widget get _loadingWidget {
    double loadingWidth = 49;
    double loadingHeight = 20;
    return LoadingWidget(width: loadingWidth, height: loadingHeight);
  }

  /// 在 context 中展示 loading ，(一定记得在 dispose 方法中调用 LoadingUtil.dismissInContext(context);)
  static showInContext(BuildContext context) {
    double loadingWidth = 49;
    double loadingHeight = 20;
    Widget child = LoadingWidget(width: loadingWidth, height: loadingHeight);
    pageOverlayEntry =
        _getCenterOverlayInContext(context, child, loadingWidth, loadingHeight);

    Overlay.of(context).insert(pageOverlayEntry);
  }

  /// 在 context 中关闭 loading ，(一定记得在 dispose 方法中调用 LoadingUtil.dismissInContext(context);)
  static dismissInContext(BuildContext context) {
    pageOverlayEntry?.remove();
  }

  static showDongingTextInContext(
    BuildContext context,
    String text, {
    int milliseconds = 0,
    void Function() completeBlock,
  }) {
    double childWidth = 100;
    double childHeight = 44;
    Widget child = Container(
      // color: Colors.grey[350],
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.blue[100], spreadRadius: 1),
        ],
      ),
      width: childWidth,
      height: childHeight,
      child: Center(
        child: Text(text),
      ),
    );
    doingTextOverlayEntry =
        _getCenterOverlayInContext(context, child, childWidth, childHeight);

    Overlay.of(context).insert(doingTextOverlayEntry);

    if (milliseconds > 0) {
      assert(completeBlock != null);
      Future.delayed(Duration(milliseconds: milliseconds), () {
        dismissDongingTextInContext(context);
        completeBlock();
      });
    }
  }

  static dismissDongingTextInContext(BuildContext context) {
    doingTextOverlayEntry?.remove();
  }

  /// 获取要显示在 context 中心的完整视图
  static OverlayEntry _getCenterOverlayInContext(
    BuildContext context,
    Widget child,
    double childWidth,
    double childHeight,
  ) {
    assert(context != null);
    double left = MediaQuery.of(context).size.width / 2 - childWidth / 2;
    double top = MediaQuery.of(context).size.height / 2 - childHeight / 2;

    return OverlayEntry(
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
  }
}
