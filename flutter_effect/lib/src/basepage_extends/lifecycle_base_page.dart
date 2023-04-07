// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-05-12 17:34:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-03 14:38:01
 * @Description: 含生命周期的 base page
 */
import 'dart:core';
import 'package:flutter/material.dart';

import '../util/stack_trace_util.dart';
import 'package:stack_trace/stack_trace.dart';

//class LifeCyclePage extends StatefulWidget {
abstract class LifeCyclePage extends StatefulWidget {
  static RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  LifeCyclePage({
    Key? key,
  }) : super(key: key);

  // @override
  // // LifeCycleBasePageState createState() => LifeCycleBasePageState();
  // LifeCycleBasePageState createState() => getState();
  // ///子类实现
  // LifeCycleBasePageState getState() {
  //   print('请在子类中实现');
  // }
}

enum AppearBecause {
  newCreate, // 新显示
  pop, // 从其他界面pop回来的
}

enum DisAppearBecause {
  goNew, // 去新的页面
  pop, // 退出当前界面
}

//class LifeCycleBasePageState extends State<LifeCyclePage> {
abstract class LifeCycleBasePageState<V extends LifeCyclePage> extends State<V>
    with RouteAware {
  @override
  void dispose() {
    LifeCyclePage.routeObserver.unsubscribe(this); // 取消订阅

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context) is PopupRoute) {
      // 示例: 页面是从底部弹出在本页面的模态视图的时候，不能监听到 LifeCyclePage
      // class _ModalBottomSheetRoute<T> extends PopupRoute<T>
      debugPrint(
          "Warning:当前类${this.runtimeType}无法出发viewDidAppear,类似常见的有 showModalBottomSheet 方法调出的页面");
    } else {
      LifeCyclePage.routeObserver.subscribe(
        this,
        ModalRoute.of(context) as PageRoute,
      ); //订阅
    }

    super.didChangeDependencies();
  }

  @override
  void didPush() {
    super.didPush();
    // print('${widget.runtimeType.toString()} didPush/viewDidAppear(新显示): push to current...');
    printMessage('创建并显示了');

    viewDidAppear(AppearBecause.newCreate);
  }

  @override
  void didPopNext() {
    // print('${widget.runtimeType.toString()} didPopNext/viewDidAppear(回来了): pop to current...');
    printMessage('回来了');
    viewDidAppear(AppearBecause.pop);
  }

  @override
  void didPushNext() {
    // print('${widget.runtimeType.toString()} didPushNext/viewDidDisappear(消失了去下一个页面): push new...');
    printMessage('消失去下一个页面了');
    viewDidDisappear(DisAppearBecause.goNew);
  }

  @override
  void didPop() {
    // print('${widget.runtimeType.toString()} didPop/viewDidDisappear(消失了回前一个页面): pop current...');
    printMessage('消失回前一个页面去了');
    viewDidDisappear(DisAppearBecause.pop);
  }

  printMessage(String message) {
    String routeClassString = widget.runtimeType.toString();

    String prefixString = routeClassString.padRight(20, " ");
    String suffixString = "$message...".padRight(18, " ");
    print('------  $prefixString $suffixString  ------');
  }

  void viewDidAppear(AppearBecause appearBecause) {}

  void viewDidDisappear(DisAppearBecause disAppearBecause) {}

  // @override
  // Widget build(BuildContext context) {
  //   super.build(context);
  // }

  printStack() {
    print('$__CLASS__ $__METHOD__($__FILE__:$__LINE__)');
  }

  String? get __CLASS__ {
    var frames = Trace.current().frames; //调用栈
    if (frames.length > 1) {
      var member = frames[1].member;
      var parts = member?.split(".");
      if (parts != null && parts.length > 1) {
        return parts[0];
      }
    }

    return null;
  }

  String? get __METHOD__ {
    var frames = Trace.current().frames;
    if (frames.length > 1) {
      var member = frames[1].member;
      var parts = member?.split(".");
      if (parts != null && parts.length > 1) {
        return parts[1];
      }
    }

    return null;
  }

  String? get __FILE__ {
    var frames = Trace.current().frames;
    if (frames.length > 1) {
      return frames[1].uri.path;
    }

    return null;
  }

  int? get __LINE__ {
    var frames = Trace.current().frames;
    if (frames.length > 1) {
      return frames[1].line;
    }

    return null;
  }
}
