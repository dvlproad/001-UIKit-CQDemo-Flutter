import 'dart:ui';

import 'package:flutter/material.dart';
import './log_home_page.dart';
export './log_home_page.dart' show LogType;

class ApplicationLogViewManager {
  static GlobalKey<NavigatorState> globalKey;

  // 全局log视图
  static OverlayEntry logOverlayEntry;
  static bool logVisible = true;
  // 关闭全局log视图
  static void dismissLogOverlayEntry({
    bool onlyHideNoSetnull =
        false, // true:只隐藏，不set null,下次可继续使用;false,会set null,下次重新创建
  }) {
    OverlayEntry logOverlayEntry = ApplicationLogViewManager.logOverlayEntry;
    if (onlyHideNoSetnull == true) {
      logVisible = false;
      logOverlayEntry.markNeedsBuild(); // 刷新 overlay
      return;
    }

    logOverlayEntry?.remove(); // 删除重新绘制
    ApplicationLogViewManager.logOverlayEntry = null;
  }

  static void updateLogOverlayEntry() {
    //print('尝试刷新 overlay 的 chid 视图....');
    if (logOverlayEntry != null) {
      logOverlayEntry.markNeedsBuild();
    }
  }

  // 显示全局log视图
  static Future showLogOverlayEntry({
    double left,
    double top,
    double opacity = 0.7, // 视图的透明不
    @required List logModels,
    void Function(int section, int row, LogModel bApiModel)
        clickLogCellCallback, // logCell 的点击
    void Function(List<LogModel> bLogModels) onPressedCopyAll, // 点击复制所有按钮的事件
    @required void Function(LogType bLogType) onPressedClear, // 点击清空按钮的事件
    @required void Function() onPressedClose, // 点击关闭按钮的事件
  }) async {
    if (ApplicationLogViewManager.globalKey == null) {
      throw Exception(
          'Error:请先在main.dart中设置 ApplicationLogViewManager.globalKey = GlobalKey<NavigatorState>();');
    }

    OverlayEntry logOverlayEntry = ApplicationLogViewManager.logOverlayEntry;
    if (logOverlayEntry != null) {
      logVisible = true;
      logOverlayEntry.markNeedsBuild();
      return;
    }
    logOverlayEntry?.remove(); // 删除重新绘制

    logOverlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        //print('正式刷新 overlay 的 chid 视图....');

        MediaQueryData mediaQuery =
            MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
        Widget lastChild = Container(
          // constraints: BoxConstraints(
          //   minWidth: double.infinity,
          //   minHeight: double.infinity,
          // ),
          color: Colors.white,
          width: mediaQuery.size.width,
          height: mediaQuery.size.height - 300,
          child: LogHomePage(
            logModels: logModels,
            clickLogCellCallback: clickLogCellCallback,
            onPressedClear: onPressedClear,
            onPressedClose: onPressedClose,
            onPressedCopyAll: onPressedCopyAll,
          ),
        );

        return Positioned(
          bottom: 0,
          child: GestureDetector(
            onTap: () async {},
            child: Visibility(
              visible: logVisible,
              // child: child,
              child: Material(
                // [Flutter Text 文字下有黄色下划线](https://www.jianshu.com/p/1f0a29cddba1)
                color: Colors.transparent,
                child: Opacity(
                  opacity: opacity,
                  child: lastChild,
                ),
              ),
            ),
          ),
        );
      },
    );

    /// 赋值方便移除
    ApplicationLogViewManager.logOverlayEntry = logOverlayEntry;
    ApplicationLogViewManager.globalKey.currentState.overlay
        .insert(logOverlayEntry);
  }
}
