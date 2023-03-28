/*
 * @Author: dvlproad
 * @Date: 2022-04-21 18:58:00
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-27 03:42:38
 * @Description: 主页页面管理器
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wish/common/event_bus.dart';
import 'package:wish/route/route_manager.dart';
import 'package:wish/routes/app_routes.dart';

import './user_event.dart';

enum MainPageType {
  main,
  login,
}

/// 控制rootVC
class MainPageControl {
  // 工厂模式
  factory MainPageControl() => _getInstance();
  static MainPageControl get instance => _getInstance();
  static MainPageControl _instance;
  static MainPageControl _getInstance() {
    _instance ??= MainPageControl._internal();
    return _instance;
  }

  StreamSubscription _loginSuccessEmitter;
  MainPageControl._internal() {
    // 初始化
    _loginSuccessEmitter = eventBus.on<UserDataEvent>().listen((event) {
      UserLoginState loginState = event.loginState;

      if (loginState == UserLoginState.logined) {
        bool fromOverdue = event.fromOverdue ?? false;
        if (fromOverdue) {
          // 跳到主页
          showMainPage();
        } else {
          // 回到登录前的业务页
          popAllLoginPage();
        }
      } else if (loginState == UserLoginState.overdue) {
        showLoginPage(isTokenOverdue: true);
      } else if (loginState == UserLoginState.unlogin) {
        showLoginPage(isTokenOverdue: false);
      }
    });
  }

  static void updateMainPageType(MainPageType mainPageType) {
    // 更新主控制器
  }

  /// 显示登录页（是否是token过期)
  void showLoginPage({required bool isTokenOverdue}) {
    isTokenOverdue ??= false;

    RouteManager.pushPage(null, RouteNames.loginPage, arguments: {
      "isTokenOverdue": isTokenOverdue,
    });
  }

  /// 显示登录页（是否是token过期)
  void showMainPage() {
    BuildContext context = RouteManager.navigatorKey.currentContext;
    Navigator.of(context).popUntil(ModalRoute.withName(homeRoute.routeName));
  }

  void popAllLoginPage() {
    eventBus.fire(PopAllLoginEvent());
  }
}
