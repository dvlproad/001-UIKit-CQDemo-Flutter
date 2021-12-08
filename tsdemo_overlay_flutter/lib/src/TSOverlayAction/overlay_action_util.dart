import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

OverlayEntry overlayEntry1;

class OverlayActionUtil {
  static OverlayEntry getOverlayEntry1() {
    OverlayEntry _overlayEntry1 = OverlayEntry(
      builder: (context) {
        return Container(
          // color: Colors.red,
          color: Colors.black.withOpacity(0.4),
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
    return _overlayEntry1;
  }

  static void show(BuildContext context) {
    overlayEntry1 = getOverlayEntry1();
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
      builder: (_) => Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Custom Dialog',
                        style: TextStyle(
                            fontSize: 16, decoration: TextDecoration.none)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 8),
                    child: FlatButton(
                        onPressed: () {
                          // 关闭 Dialog
                          Navigator.pop(_);
                        },
                        child: Text('确定')),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // [Flutter EasyLoading的实现原理](https://blog.csdn.net/weixin_44492423/article/details/104388056)
  static show_flutter_easyloading() {
    // 'You should call EasyLoading.init() in your MaterialApp',

    EasyLoading.instance
      ..indicatorWidget = Container(
        color: Colors.red,
        child: Text('转圈'),
      )
      ..successWidget = Container(
        color: Colors.red,
        child: Text('chenggong'),
      )
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5);

    EasyLoading.show();
    // EasyLoading.show(status: 'loading...');

    // EasyLoading.showProgress(0.3, status: 'downloading...');

    // EasyLoading.showSuccess('Great Success!');

    // EasyLoading.showError('Failed with Error');

    // EasyLoading.showInfo('Useful Information.');

    // EasyLoading.dismiss();
  }
}
