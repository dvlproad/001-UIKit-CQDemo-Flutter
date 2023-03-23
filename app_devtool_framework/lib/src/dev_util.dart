import 'dart:io';
import 'package:meta/meta.dart';

import 'package:flutter/material.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_log_base/flutter_log_base.dart';

import './dev_page.dart';

class DevUtil {
  // 设置 app 的 navigatorKey(用来处理悬浮按钮的展示)
  static late GlobalKey<NavigatorState> _navigatorKey;

  // 定义 navigatorKey 属性的 get 和 set 方法
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  static set navigatorKey(GlobalKey<NavigatorState> globalKey) {
    _navigatorKey = globalKey; // ①悬浮按钮的显示功能需要
    ApplicationLogViewManager.globalKey = globalKey; // ②日志系统需要
  }

  static init({
    required GlobalKey<NavigatorState> navigatorKey,
    ImageProvider? floatingToolImageProvider, // 悬浮按钮上的图片
    required String floatingToolTextNetworkNameOrigin, // 悬浮按钮上的文本:此包的默认网络环境
    required String floatingToolTextNetworkNameCurrent, // 悬浮按钮上的文本:此包的当前网络环境
    required String floatingToolTextTargetNameOrigin, // 悬浮按钮上的文本:此包的默认发布网站
    required String floatingToolTextTargetNameCurrent, // 悬浮按钮上的文本:此包的当前发布网站
    void Function(BuildContext bContext)? onFloatingToolDoubleTap, // 悬浮按钮的双击事件
    required bool overlayEntryShouldShowIfNil,
  }) {
    DevUtil.navigatorKey = navigatorKey;

    ApplicationDraggableManager.init(
      navigatorKey: navigatorKey, // ①悬浮按钮的拖动功能需要
      floatingToolImageProvider: floatingToolImageProvider,
      floatingToolTextNetworkNameOrigin: floatingToolTextNetworkNameOrigin,
      floatingToolTextTargetNameCurrent: floatingToolTextTargetNameCurrent,
      floatingToolTextTargetNameOrigin: floatingToolTextTargetNameOrigin,
      floatingToolTextNetworkNameCurrent: floatingToolTextNetworkNameCurrent,
      overlayEntryShouldShowIfNil: overlayEntryShouldShowIfNil,
      onTap: () {
        if (navigatorKey == null) {
          throw Exception(
              "Warning:请先执行 DevUtil.navigatorKey = GlobalKey<NavigatorState>(); 才能正常显示悬浮按钮");
        }
        BuildContext? context =
            navigatorKey.currentContext; // 点击的时候才去获取 context，避免未取到
        if (context == null) {
          throw Exception("Warning:未获取到navigatorKey.currentContext");
        }

        if (DevUtil.isDevPageShowing == true) {
          debugPrint('当前已是开发工具页面,无需重复跳转');
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              // DevPage 中
              // ①悬浮按钮的显示功能:需要 DevUtil.navigatorKey = GlobalKey<NavigatorState>();
              // ①悬浮按钮的拖动功能:需要 ApplicationDraggableManager.globalKey = GlobalKey<NavigatorState>();
              // ②日志系统:需要 ApplicationLogViewManager.globalKey = GlobalKey<NavigatorState>();
              // ③检查更新:需要 CheckVersionUtil.navigatorKey = GlobalKey<NavigatorState>();
              return const DevPage();
            },
          ),
        );
      },
      onLongPress: () {
        if (DevLogUtil.isLogShowing == false) {
          DevLogUtil.showLogView();
        } else {
          DevLogUtil.dismissLogView();
        }
      },
      onDoubleTap: () {
        if (onFloatingToolDoubleTap != null &&
            navigatorKey.currentContext != null) {
          onFloatingToolDoubleTap(navigatorKey.currentContext!);
        }
      },
    ).then((value) {
      bool shouldShowDevTool = ApplicationDraggableManager.overlayEntryIsShow;
      if (shouldShowDevTool) {
        Future.delayed(const Duration(milliseconds: 3000), () {
          DevUtil.showDevFloatingWidget();
        });
      }
    });
  }

  static bool isDevPageShowing =
      false; //[暂时没有更好解决办法的Flutter获取当前页面的问题](https://www.cnblogs.com/xsiOS/p/15676609.html)

  // 开发工具的悬浮按钮 是否在显示
  static bool isDevFloatingWidgetShowing() {
    return ApplicationDraggableManager.overlayEntryIsShow;
  }

  // 关闭开发工具的悬浮按钮
  static void hideDevFloatingWidget() {
    ApplicationDraggableManager.removeOverlayEntry();
  }

  // 显示开发工具的悬浮按钮
  static void showDevFloatingWidget() {
    /*
    Widget cell({String title, void Function() onPressed}) {
      return Container(
        child: TextButton(
          child: Text(title, style: TextStyle(color: Colors.white)),
          onPressed: onPressed,
        ),
      );
    }

    Widget overlayChildWidget = Container(
      color: Color(0xFFFF00FF),
      child: Column(
        children: [
          cell(
            title: '切换环境',
            onPressed: () {
              goChangeEnvironment(context,
                  showTestApiWidget: showTestApiWidget);
            },
          ),
          cell(
            title: 'mock api',
            onPressed: () {
              goChangeApiMock(context, showTestApiWidget: showTestApiWidget);
            },
          ),
          cell(
            title: '开启 log 视图',
            onPressed: () {
              DevLogUtil.showLogView();
            },
          ),
          cell(
            title: '返回',
            onPressed: () {
              bool canPop = Navigator.canPop(context);
              if (canPop) {
                Navigator.pop(context);
              }
            },
          ),
          cell(
            title: '关闭悬浮',
            onPressed: () {
              this.hideDevFloatingWidget();
            },
          ),
        ],
      ),
    );

    ApplicationDraggableManager.addOverlayEntry(
      left: left,
      top: top,
      child: overlayChildWidget,
      ifExistUseOld: true,
    );
    */

    ApplicationDraggableManager.showEasyOverlayEntry(
      left: 80,
      top: 180,
    );
  }
}
