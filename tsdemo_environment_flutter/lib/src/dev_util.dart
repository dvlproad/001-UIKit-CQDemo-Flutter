import 'package:flutter/material.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

import './main_init/environment_datas_util.dart';

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
      print(
          "Warning:请先执行 DevUtil.navigatorKey = GlobalKey<NavigatorState>(); 才能正常显示悬浮按钮");
      return;
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
          print('当前已是开发工具页面,无需重复跳转');
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
        DevLogUtil.showLogView();
      },
    );
  }

  static Future goChangeEnvironment(
    BuildContext context, {
    bool showTestApiWidget,
  }) {
    return EnvironmentUtil.goChangeEnvironment(
      context,
      onPressTestApiCallback: showTestApiWidget
          ? () {
              print('测试切换环境后，网络请求的情况');
              // 我的收货地址
              // Api.getAddressList(
              //     {"accountId": UserInfoManager.instance.userModel.id});
              // HttpManager.getInstance().post(
              //   'user/account/getConsigneeAddresses',
              //   params: {"accountId": UserInfoManager.instance.userModel.id},
              // );
            }
          : null,
      updateNetworkCallback: (apiHost, webHost, gameHost) {
        NetworkChangeUtil.changeOptions(baseUrl: apiHost);
      },
      updateProxyCallback: (proxyIp) {
        NetworkChangeUtil.changeProxy(proxyIp);
      },
    );
  }

  static Future goChangeApiMock(
    BuildContext context, {
    bool showTestApiWidget,
  }) {
    String simulateApiHost = TSEnvironmentDataUtil.dev_mockApiHost;
    return EnvironmentUtil.goChangeApiMock(
      context,
      mockApiHost: simulateApiHost,
      onPressTestApiCallback: showTestApiWidget
          ? () {
              print('测试 mock api 后，网络请求的情况');
              // 我的收货地址
              // Api.getAddressList(
              //     {"accountId": UserInfoManager.instance.userModel.id});
            }
          : null,
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
