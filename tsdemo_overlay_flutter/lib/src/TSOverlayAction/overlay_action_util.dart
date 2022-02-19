import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

OverlayEntry overlayEntry1;

class OverlayActionUtil {
  static OverlayEntry getOverlayEntry1(BuildContext context) {
    OverlayEntry _overlayEntry1 = OverlayEntry(
      builder: (context) {
        return Container(
          color: Colors.red.withOpacity(0.4),
          // color: Colors.black.withOpacity(0.4),
          width: 200,
          height: 200,
          child: GestureDetector(
            onTap: () {
              print('点击了空白区域');
            },
            child: Stack(
              children: <Widget>[
                // this.overlayChild,
                Positioned(
                  left: 40,
                  right: 40,
                  bottom: 30,
                  child: Container(
                    height: 42,
                    child: FlatButton(
                      onPressed: () {
                        OverlayActionUtil.dismiss();
                      },
                      child: Text('点击隐藏22'),
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Widget child = FlatButton(
    //   onPressed: () {
    //     OverlayActionUtil.dismiss();
    //   },
    //   child: Text('点击隐藏22'),
    //   color: Colors.red,
    // );

    double left = MediaQuery.of(context).size.width / 2 - 100 / 2;
    double top = MediaQuery.of(context).size.height / 2 - 100 / 2;
    Widget child = _loadingWidget_gif;

    _overlayEntry1 = OverlayEntry(
      builder: (BuildContext context) {
        // return Container(
        //   color: Colors.green,
        //   width: 200,
        //   height: 200,
        //   child: Positioned(
        //     top: top,
        //     left: left,
        //     child: GestureDetector(
        //       onTap: () async {},
        //       child: child,
        //     ),
        //   ),
        // );
        return Positioned(
          top: top,
          left: left,
          child: GestureDetector(
            onTap: () async {
              OverlayActionUtil.dismiss();
            },
            child: child,
          ),
        );
      },
    );

    return _overlayEntry1;
  }

  // 动画加载方法1：使用 gif 加载动画
  static Widget get _loadingWidget_gif {
    return Image.asset(
      'assets/loading_gif/loading_bj.gif',
      package: 'tsdemo_overlay_flutter',
      width: 100,
      height: 100,
    );
  }

  static void show(BuildContext context) {
    overlayEntry1 = getOverlayEntry1(context);
    Overlay.of(context).insert(overlayEntry1);
  }

  static void dismiss() {
    overlayEntry1.remove();
  }

  //[实现Flutter弹窗的正确姿势](https://www.jianshu.com/p/0f417c75cb41)
  static void show_showDialog(BuildContext context) {
    showDialog(
      // 传入 context
      context: context,
      // 构建 Dialog 的视图
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[_customPopupWidget(context)],
      ),
      // builder: (_) => Container(
      //   color: Colors.green,
      //   alignment: Alignment.center,
      //   child: _customPopupWidget(context),
      // ),
    );
  }

  static Widget _customPopupWidget(BuildContext context) {
    // return FlatButton(
    //   onPressed: () {
    //     // 关闭 Dialog
    //     Navigator.pop(context);
    //   },
    //   child: Text('确定'),
    // );

    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Custom Dialog',
              style: TextStyle(fontSize: 16, decoration: TextDecoration.none),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 8),
            child: FlatButton(
              child: Text('确定'),
              onPressed: () {
                // 关闭 Dialog
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // [Flutter EasyLoading的实现原理](https://blog.csdn.net/weixin_44492423/article/details/104388056)
  static show_flutter_easyloading() {
    // 'You should call EasyLoading.init() in your MaterialApp',

    // initInstance_flutter_easyloading();

    EasyLoading.show();
    // EasyLoading.show(status: 'loading...');

    // EasyLoading.showProgress(0.3, status: 'downloading...');

    // EasyLoading.showSuccess('Great Success!');

    // EasyLoading.showError('Failed with Error');

    // EasyLoading.showInfo('Useful Information.');
  }

  static dismiss_flutter_easyloading() {
    EasyLoading.dismiss();
  }

  /// init EasyLoading
  static TransitionBuilder init_flutter_easyloading() {
    TransitionBuilder builder = EasyLoading.init();

    _initInstance_flutter_easyloading();

    return builder;
  }

  static _initInstance_flutter_easyloading() {
    EasyLoading.instance
      ..indicatorWidget = GestureDetector(
        onTap: () {
          print('点击本身来隐藏');
          OverlayActionUtil.dismiss_flutter_easyloading();
        },
        child: Container(
          color: Colors.red,
          width: 200,
          height: 200,
          child: Image.asset(
            'assets/loading_gif/loading_bj.gif',
            package: 'tsdemo_overlay_flutter',
            width: 100,
            height: 100,
          ),
        ),
      )
      // 展示成功状态的自定义组件
      ..successWidget = Container(
        color: Colors.red,
        width: 200,
        height: 200,
        child: Text('自定义的成功界面'),
      )
      ..contentPadding = EdgeInsets.zero // 默认时会有边距

      ..loadingStyle = EasyLoadingStyle.custom // 设置custom，才能自定义backgroundColor
      ..boxShadow = [
        BoxShadow(color: Colors.transparent)
      ] // 设置custom后，不设置boxShadow或设为null都会取默认值，而不是真正的null
      ..backgroundColor = Colors.transparent
      ..indicatorColor = Colors
          .green // 为了自定义的backgroundColor生效，设置了 EasyLoadingStyle.custom, 导致必须设置此参数
      ..textColor = Colors
          .orange // 为了自定义的backgroundColor生效，设置了 EasyLoadingStyle.custom, 导致必须设置此参数
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false // 当loading展示的时候，是否允许用户操作.
      ..displayDuration = const Duration(milliseconds: 2000)
      ..radius = 10.0;
  }
}
