/*
 * @Author: dvlproad
 * @Date: 2022-06-01 18:40:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-16 23:05:12
 * @Description: 共享滑动信息
 */
import 'dart:async';

import 'package:flutter/material.dart';

class ScrollNotificationPublisher extends InheritedWidget {
  ScrollNotificationPublisher({Key? key, required Widget child})
      : super(key: key, child: child);

  final StreamController<ScrollNotification> scrollNotificationController =
      StreamController<ScrollNotification>.broadcast();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static StreamController<ScrollNotification> of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<
            ScrollNotificationPublisher>() as ScrollNotificationPublisher)
        .scrollNotificationController;
  }
}
