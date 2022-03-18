import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

import './dev_page.dart';

class DevUtil {
  // 设置 app 的 navigatorKey(用来处理悬浮按钮的展示)
  static GlobalKey _navigatorKey;

  // 定义 navigatorKey 属性的 get 和 set 方法
  static GlobalKey get navigatorKey => _navigatorKey;
  static set navigatorKey(GlobalKey globalKey) {
    _navigatorKey = globalKey; // ①悬浮按钮的显示功能需要
    ApplicationDraggableManager.globalKey = globalKey; // ①悬浮按钮的拖动功能需要
    ApplicationLogViewManager.globalKey = globalKey; // ②日志系统需要
    CheckVersionUtil.navigatorKey = globalKey; // ③检查更新需要
  }

  static init({
    GlobalKey navigatorKey,
    ImageProvider floatingToolImageProvider, // 悬浮按钮上的图片
    String floatingToolTextDefaultEnv, // 悬浮按钮上的文本:此包的默认环境
  }) {
    DevUtil.navigatorKey = navigatorKey;
    ApplicationDraggableManager.floatingToolImageProvider =
        floatingToolImageProvider;
    ApplicationDraggableManager.floatingToolTextDefaultEnv =
        floatingToolTextDefaultEnv;
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
  static void showDevFloatingWidget({
    double left = 80,
    double top = 180,
    bool showTestApiWidget,
  }) {
    if (navigatorKey == null) {
      throw Exception(
          "Warning:请先执行 DevUtil.navigatorKey = GlobalKey<NavigatorState>(); 才能正常显示悬浮按钮");
    }
    BuildContext context = navigatorKey.currentContext;

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
      left: left,
      top: top,
      onTap: () {
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
    );
  }

  static int requestCount = 0;
  static Future goChangeEnvironmentNetwork(
    BuildContext context, {
    bool showTestApiWidget,
  }) {
    return EnvironmentUtil.goChangeEnvironmentNetwork(
      context,
      onPressTestApiCallback: showTestApiWidget
          ? () {
              // 测试请求
              // requestCount = 0;
              // NetworkKit.post(
              //   'login/doLogin',
              //   params: {
              //     "clientId": "clientApp",
              //     "clientSecret": "123123",
              //   },
              //   cacheLevel: NetworkCacheLevel.one,
              // ).then((value) {
              //   requestCount++;
              //   debugPrint('测试网络请求的缓存功能:$requestCount');
              // });

              // 测试网络请求的缓存功能
              requestCount = 0;
              NetworkKit.postWithCallback(
                'login/doLogin',
                params: {
                  "clientId": "clientApp",
                  "clientSecret": "123123",
                  'retryCount': 3,
                },
                cacheLevel: NetworkCacheLevel.none,
                completeCallBack: (resultData) {
                  requestCount++;
                  debugPrint('测试网络请求的缓存功能:$requestCount');
                },
              );
            }
          : null,
      updateNetworkCallback: (bNetworkModel, {shouldExit}) {
        changeEnv(bNetworkModel, shouldExit, context: context);
      },
    );
  }

  static Future goChangeEnvironmentProxy(
    BuildContext context, {
    bool showTestApiWidget,
  }) {
    return EnvironmentUtil.goChangeEnvironmentProxy(
      context,
      onPressTestApiCallback: showTestApiWidget
          ? () {
              // 测试请求
              requestCount = 0;
              NetworkKit.post(
                'login/doLogin',
                params: {
                  "clientId": "clientApp",
                  "clientSecret": "123123",
                },
                cacheLevel: NetworkCacheLevel.one,
              ).then((value) {
                requestCount++;
                debugPrint('测试网络请求的缓存功能:$requestCount');
              });
            }
          : null,
      updateProxyCallback: (TSEnvProxyModel bProxyModel) {
        changeProxyTo(bProxyModel);
      },
    );
  }

  static void changeProxyToNone() {
    TSEnvProxyModel proxyModel = TSEnvProxyModel.noneProxyModel();
    changeProxyTo(proxyModel);
  }

  static void changeProxyTo(TSEnvProxyModel proxyModel) {
    /// ①修改代理环境_页面数据
    ProxyPageDataManager().updateProxyPageSelectedData(proxyModel);

    /// ②修改代理环境_SDK数据
    changeAllProxy(proxyModel.proxyIp);
  }

  static void changeEnv(TSEnvNetworkModel bNetworkModel, bool shouldExit,
      {BuildContext context}) {
    /// ①修改网络环境_页面数据
    NetworkPageDataManager().updateNetworkPageSelectedData(bNetworkModel);

    /// ②修改网络环境_SDK数据
    if (shouldExit == true && 'UserInfoManager.isLoginState()' == true) {
      /*
      UserInfoManager.instance.userLoginOut().then((value) {
        eventBus.fire(LogoutSuccessEvent());
      });
      */
    }

    changeHost(
      apiHost: bNetworkModel.apiHost,
      webHost: bNetworkModel.webHost,
      gameHost: bNetworkModel.gameHost,
    );

    /// ③修改网络环境_更改完数据后，是否退出应用
    if (shouldExit == true) {
      // Future.delayed(const Duration(milliseconds: 500), () {
      LoadingUtil.showDongingTextInContext(
        context,
        '退出中...',
        milliseconds: 500,
        completeBlock: () {
          // [Flutter如何有效地退出程序](https://zhuanlan.zhihu.com/p/191052343)
          exit(0); // 需要 import 'dart:io';
          // SystemNavigator
          //     .pop(); // 该方法在iOS中并不适用。需要  import 'package:flutter/services.dart';
        },
      );
    }
  }

  static changeHost({String apiHost, String webHost, String gameHost}) {
    if (apiHost != null) {
      NetworkManager.changeOptions(baseUrl: apiHost);
    }
  }

  static bool changeAllProxy(String proxyIp) {
    return NetworkManager.changeProxy(proxyIp);
  }

  static Future goChangeApiMock(
    BuildContext context, {
    bool showTestApiWidget,
  }) {
    return EnvironmentUtil.goChangeApiMock(
      context,
      onPressTestApiCallback: showTestApiWidget ? () {} : null,
      // navbarActions: [
      //   CQTSThemeBGButton(
      //     title: '添加',
      //     onPressed: () {
      //       ApiManager.tryAddApi(
      //           cqtsRandomString(0, 10, CQRipeStringType.english));
      //       print('添加后的api个数:${ApiManager().apiModels.length}');
      //       Navigator.pop(context);
      //     },
      //   ),
      // ],
    );
  }
}
