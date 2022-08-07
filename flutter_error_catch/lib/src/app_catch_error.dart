/*
 * @Author: dvlproad
 * @Date: 2022-07-28 12:38:28
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-31 21:44:01
 * @Description: 错误捕获
 */
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_log/app_log.dart';
import 'package:flutter_bugly/flutter_bugly.dart';

// import 'package:get/get.dart';

/*
void main222() {
  runZonedGuarded(() {
    //
  }, (Object e, StackTrace s) {
    print(e);
  });
}

void main111() {
  FlutterBugly.postCatchedException(() {
    appMain();
  });
}
*/

// Map<String, dynamic> testMap = {"buildNumber": 123};
// String buildNumberTest = testMap['buildNumber'];

//全局异常的捕捉
class AppCatchError {
  // static late GlobalKey<NavigatorState> globalKey;
  static String? currentPageClassString;
  static String? currentPageRoutePath;

  static run(Widget app) {
    ///Flutter 框架异常
    FlutterError.onError = (FlutterErrorDetails details) async {
      _logMessage(
        logType: LogObjectType.dart,
        logLevel: LogLevel.error,
        title: 'dart error',
        shortMap: {
          "exception": details.exception.toString(),
        },
        detailMap: {
          "exception": details.exception.toString(),
          "stack": details.stack.toString(),
        },
      );

      ///线上环境
      ///TODO
      // if (kReleaseMode) {
      //   Zone.current.handleUncaughtError(details.exception, details.stack);
      // } else {
      //   //开发期间 print
      //   FlutterError.dumpErrorToConsole(details);
      // }
    };

    runZonedGuarded(() {
      //受保护的代码块
      runApp(app);
    }, (Object error, StackTrace stack) {
      catchError(error, stack);
    });
  }

  ///对搜集的 异常进行处理  上报等等
  static void catchError(Object error, StackTrace stack) {
    // print("AppCatchError>>>>>>>>>>: $kReleaseMode"); //是否是 Release版本
    // print('AppCatchError message:$error,stack$stack');

    _logMessage(
      logType: LogObjectType.widget,
      logLevel: LogLevel.error,
      title: 'widget error',
      shortMap: {
        "error": error.toString(),
      },
      detailMap: {
        "error": error.toString(),
        "stack": stack.toString(),
      },
    );
  }

  static void _logMessage({
    required LogObjectType logType,
    required LogLevel logLevel,
    String? title,
    required Map<String, dynamic> shortMap,
    required Map<String, dynamic> detailMap,
  }) {
    // [获取当前路由名](http://www.manongjc.com/detail/29-fderocvceejpzpp.html)
    // 1、通过Flutter提供的方式
    // String currentRoutePath1 = ModalRoute.of(context).settings.name;
    // print("current route: $currentRoutePath1");

    // String currentRoutePath = 'unknow page';
    // if (globalKey.currentContext != null) {
    //   ModalRoute? route = ModalRoute.of(globalKey.currentContext!);
    //   if (route != null) {
    //     currentRoutePath = route.settings.name ?? 'unknow page';
    //     print("current route: $currentRoutePath");
    //   }
    // }

    // 2、通过GetX的方式(必须确保注册了路由，否则无法使获取到)
    // var currentRoutePath = Get.currentRoute;
    // print("current route: $currentRoutePath");

    currentPageClassString ??= 'unknow page class';
    currentPageRoutePath ??= 'unknow page route';
    Map<String, dynamic> pageParmas = {
      "currentPageClassString": currentPageClassString,
      "currentPageRoutePath": currentPageRoutePath,
    };
    Map<String, dynamic> lastShortMap = {};
    lastShortMap.addAll(pageParmas);
    lastShortMap.addAll(shortMap);

    Map<String, dynamic> lastDetailMap = {};
    lastDetailMap.addAll(pageParmas);
    lastDetailMap.addAll(detailMap);

    AppLogUtil.logMessage(
      logType: logType,
      logLevel: logLevel,
      title: title,
      shortMap: lastShortMap,
      detailMap: lastDetailMap,
    );
  }
}
