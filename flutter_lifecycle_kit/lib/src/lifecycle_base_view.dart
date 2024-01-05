// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-05-12 17:34:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 14:46:39
 * @Description: 含生命周期的 base page
 */
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import './lifecycle_enum.dart';

//class LifeCycleView extends StatefulWidget {
abstract class LifeCycleView extends StatefulWidget {
  static RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  const LifeCycleView({Key? key}) : super(key: key);

  // @override
  // // LifeCycleViewState createState() => LifeCycleViewState();
  // LifeCycleViewState createState() => getState();
  // ///子类实现
  // LifeCycleViewState getState() {
  //   print('请在子类中实现');
  // }
}

//class LifeCycleViewState extends State<LifeCycleView> {
abstract class LifeCycleViewState<V extends LifeCycleView> extends State<V>
    with RouteAware, WidgetsBindingObserver {
  /// 当前页面是否显示在最顶层
  /// 用于当APP从后台返回前台或前台进入后台时
  /// 只调用显示在屏幕上页面的[viewDidAppear]和[viewDidDisappear]
  bool _isVisibleOnTop = false;

  AppLifecycleState _lastAppLifeCircle = AppLifecycleState.resumed;

  @override
  void dispose() {
    LifeCycleView.routeObserver.unsubscribe(this); // 取消订阅
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isVisibleOnTop = false;
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context) is PopupRoute) {
      // 示例: 页面是从底部弹出在本页面的模态视图的时候，不能监听到 LifeCycleView
      // class _ModalBottomSheetRoute<T> extends PopupRoute<T>
      debugPrint(
          "Warning:当前类$runtimeType无法出发viewDidAppear,类似常见的有 showModalBottomSheet 方法调出的页面");
    } else {
      LifeCycleView.routeObserver.subscribe(
        this,
        ModalRoute.of(context) as PageRoute,
      ); //订阅
    }

    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 所有页面前后台切换都会调用 didChangeAppLifecycleState ，但只有显示在顶层的才执行 viewDidAppear / viewDidDisappear
    _updateViewDidAppearAndViewDidDisappearForAppLifecycleState(
      state,
      isVisibleOnTop: _isVisibleOnTop,
    );
  }

  // 所有页面前后台切换都会调用 didChangeAppLifecycleState ，但只有显示在顶层的才执行 viewDidAppear / viewDidDisappear
  void _updateViewDidAppearAndViewDidDisappearForAppLifecycleState(
    AppLifecycleState state, {
    required bool isVisibleOnTop,
  }) {
    if (isVisibleOnTop != true) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        printMessage('从后台进入前台，当前页面是否显示出来了');
        viewDidAppear(AppearBecause.resume);
        break;
      case AppLifecycleState.paused:
        printMessage('从前台进入后台，当前页面是否新关闭了');
        viewDidDisappear(DisAppearBecause.pause);
        break;
      // case AppLifecycleState.inactive:
      //   printMessage('从前台进入后台');
      //   viewDidDisappear(DisAppearBecause.pause);
      //   break;
      // case AppLifecycleState.detached:
      //   printMessage('从前台进入后台');
      //   viewDidDisappear(DisAppearBecause.pause);
      //   break;
      case AppLifecycleState.inactive:
        printMessage('App失活');
        if (_lastAppLifeCircle != DisAppearBecause.inactive &&
            _lastAppLifeCircle != DisAppearBecause.pause) {
          viewDidDisappear(DisAppearBecause.inactive);
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
    _lastAppLifeCircle = state;
  }

  printMessage(String message) {
    String routeClassString = widget.runtimeType.toString();

    String prefixString = routeClassString.padRight(20, " ");
    String suffixString = "$message...".padRight(18, " ");
    debugPrint('------  $prefixString $suffixString  ------');
  }

  // 当前页面显示了，底层必须先执行 super.viewDidAppear
  void viewDidAppear(AppearBecause appearBecause) {
    if (appearBecause == AppearBecause.newCreate ||
        appearBecause == AppearBecause.pop ||
        appearBecause == AppearBecause.monitor) {
      _isVisibleOnTop = true;
    }
  }

  // 当前页面消失了，底层必须先执行 super.viewDidDisappear
  void viewDidDisappear(DisAppearBecause disAppearBecause) {
    if (disAppearBecause == DisAppearBecause.goNew ||
        disAppearBecause == DisAppearBecause.pop ||
        disAppearBecause == DisAppearBecause.monitor) {
      _isVisibleOnTop = false;
    }
  }

  // 提供给子类的方法，按需调用
  Widget visibilityDetectorWidget(
    BuildContext context, {
    required Widget child,
  }) {
    return VisibilityDetector(
      key: Key(widget.runtimeType.toString()),
      onVisibilityChanged: (VisibilityInfo visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1) {
          viewDidAppear(AppearBecause.monitor);
        } else {
          if (!_isVisibleOnTop) {
            return;
          }
          viewDidDisappear(DisAppearBecause.monitor);
        }
      },
      child: child,
    );
  }
}
