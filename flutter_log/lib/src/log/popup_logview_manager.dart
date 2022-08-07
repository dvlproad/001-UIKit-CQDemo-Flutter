import 'dart:ui';

import 'package:flutter/material.dart';
import './log_home_page.dart';
import './log_data_bean.dart';

// import 'package:sliding_up_panel/sliding_up_panel.dart';

class ApplicationLogViewManager {
  static GlobalKey<NavigatorState>? globalKey;

  static Widget Function(LogModel logModel)? logDetailPageBuilder;

  // 全局log视图
  static String logListOverlayKey = 'logListOverlayKey';
  static String logDetailOverlayKey = 'logDetailOverlayKey';
  static Map<String, OverlayEntry> logOverlayMap = {};
  static bool logVisible = true;
  // 关闭全局log视图
  static void dismissLogOverlayEntry(
    String overlayKey, {
    bool onlyHideNoSetnull =
        false, // true:只隐藏，不set null,下次可继续使用;false,会set null,下次重新创建
  }) {
    OverlayEntry? logOverlayEntry = logOverlayMap[overlayKey];
    if (onlyHideNoSetnull == true) {
      logVisible = false;
      logOverlayEntry?.markNeedsBuild(); // 刷新 overlay
      return;
    }

    logOverlayEntry?.remove(); // 删除重新绘制
    logOverlayMap.remove(overlayKey);

    // BuildContext context = ApplicationLogViewManager.globalKey.currentContext;
    // Navigator.pop(context);
  }

  static void updateLogOverlayEntry() {
    //print('尝试刷新 overlay 的 chid 视图....');
    OverlayEntry? logOverlayEntry = logOverlayMap[logListOverlayKey];
    if (logOverlayEntry != null) {
      // TODO:使用延迟临时修复setState() or markNeedsBuild() called during build.错误解决
      Future.delayed(Duration(microseconds: 100)).then((value) {
        logOverlayEntry.markNeedsBuild();
      });
    }
  }

  static Widget _overlayContentWidget({
    double opacity = 0.7, // 视图的透明不
    required Widget child,
    double? childDistanceToTop, // 离顶部的距离
  }) {
    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    Widget lastChild = Container(
      // constraints: BoxConstraints(
      //   minWidth: double.infinity,
      //   minHeight: double.infinity,
      // ),
      color: Colors.white,
      width: mediaQuery.size.width,
      height: mediaQuery.size.height - (childDistanceToTop ?? 300.0),
      child: child,
    );

    return Positioned(
      bottom: 0,
      child: GestureDetector(
        onTap: () async {},
        child: Visibility(
          visible: logVisible,
          maintainState: true,
          // child: Offstage( // Offstage 点击关闭弹窗会失效
          //   offstage: logVisible,
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
  }

  // 显示全局log视图
  static Future showLogListOverlayEntry({
    double left = 0.0,
    double top = 0.0,
    double opacity = 0.7, // 视图的透明不
    required List<LogModel> logModels,
    required void Function({
      required BuildContext context,
      int? section,
      int? row,
      required LogModel bLogModel,
    })
        clickLogCellCallback, // logCell 的点击
    required void Function(List<LogModel> bLogModels)
        onPressedCopyAll, // 点击复制所有按钮的事件
    required void Function(
            {required LogObjectType logType, required LogCategory bLogCategory})
        onPressedClear, // 点击清空按钮的事件
    required void Function() onPressedClose, // 点击关闭按钮的事件
  }) async {
    return _showLogOverlayEntry(
      logListOverlayKey,
      left: left,
      top: top,
      builder: (context) {
        Widget logHomePage = LogHomePage(
          logModels: logModels,
          clickLogCellCallback: clickLogCellCallback,
          onPressedClear: onPressedClear,
          onPressedClose: onPressedClose,
          onPressedCopyAll: onPressedCopyAll,
        );

        return _overlayContentWidget(
          opacity: opacity,
          child: logHomePage,
          childDistanceToTop: 300,
        );
      },
    );
  }

  static Future showLogDetailOverlayEntry({
    double left = 0.0,
    double top = 0.0,
    double opacity = 0.7, // 视图的透明不
    required LogModel apiLogModel,
  }) async {
    return _showLogOverlayEntry(
      logDetailOverlayKey,
      left: left,
      top: top,
      builder: (context) {
        Widget logDetailWidget;
        if (logDetailPageBuilder == null) {
          logDetailWidget = Container(
            color: Colors.cyan,
            child: Text("请实现logDetailPageBuilder"),
          );
        } else {
          logDetailWidget = logDetailPageBuilder!(apiLogModel);
        }

        return _overlayContentWidget(
          opacity: 1.0,
          child: GestureDetector(
            // behavior: HitTestBehavior.deferToChild,
            // onTap: () => dismissLogOverlayEntry(logDetailOverlayKey),
            child: Container(
              color: Colors.white,
              child: logDetailPageBuilder == null
                  ? Text("请实现logDetailPageBuilder")
                  : logDetailPageBuilder!(apiLogModel),
            ),
          ),
          childDistanceToTop: 0,
        );
      },
    );
  }

  // 显示全局log视图
  static Future _showLogOverlayEntry(
    String overlayKey, {
    double left = 0.0,
    double top = 0.0,
    required WidgetBuilder builder,
  }) async {
    assert(builder != null);

    if (ApplicationLogViewManager.globalKey == null) {
      throw Exception(
          'Error:请先在main.dart中设置 ApplicationLogViewManager.globalKey = GlobalKey<NavigatorState>();');
    }

    OverlayEntry? logOverlayEntry = logOverlayMap[overlayKey];
    if (logOverlayEntry != null) {
      logVisible = true;
      logOverlayEntry.markNeedsBuild();
      return;
    }
    logOverlayEntry?.remove(); // 删除重新绘制

    logOverlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        //print('正式刷新 overlay 的 chid 视图....');
        return builder(context);
      },
    );

    /// 赋值方便移除
    logOverlayMap[overlayKey] = logOverlayEntry;
    ApplicationLogViewManager.globalKey!.currentState?.overlay
        ?.insert(logOverlayEntry);
    /*
    BuildContext context = ApplicationLogViewManager.globalKey.currentContext;

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      enableDrag: true,
      builder: builder,
    );
    */
  }
}
