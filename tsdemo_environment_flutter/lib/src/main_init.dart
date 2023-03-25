/*
 * @Author: dvlproad
 * @Date: 2022-04-15 14:42:37
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 13:59:05
 * @Description: 启动初始化
 */
import 'dart:convert';
import 'dart:io';

import 'package:app_network/app_network.dart';
import 'package:flutter/material.dart';

import 'package:app_devtool_framework/app_devtool_framework.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
export 'package:app_devtool_framework/app_devtool_framework.dart'
    show PackageType, PackageTargetType;

// import 'package:flutter_cache_kit/flutter_cache_kit.dart';
import 'package:flutter_environment_base/flutter_environment_base.dart';
import 'package:app_environment/app_environment.dart'
    show devtoolEventBus, DevtoolEnvironmentInitCompleteEvent;

import 'package:flutter_images_picker/flutter_images_picker.dart'
    show PermissionsManager;

import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_log_base/flutter_log_base.dart';
import './dev_user_page.dart';
import './userInfoManager.dart';

class MainInit {
  static GlobalKey<NavigatorState> _navigatorKey;
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static initWithGlobalKey(
    GlobalKey globalKey,
    PackageNetworkType packageNetworkType,
    PackageTargetType packageTargetType,
  ) {
    _navigatorKey = globalKey;
    _initWithGlobalKey(globalKey, packageNetworkType, packageTargetType);

    // 其他开发页
    DevPage.navbarActions = [
      _buttonToPage('调试页面', const Text('1'), globalKey),
      _buttonToPage('用户相关', const DevUserPage(), globalKey),
      _buttonToPage('设备信息', const DeviceInfoPage(), globalKey),
    ];

    // 权限
    PermissionsManager.globalKey = globalKey;

    // 监听
    devtoolEventBus.on<DevtoolEnvironmentInitCompleteEvent>().listen((event) {
      // print("Success:开发工具环境初始化完成");
      BuildContext context = globalKey.currentContext;
    });

    _addUserEventListens();
  }

  static _addUserEventListens() {}

  static Future _initWithGlobalKey(
    GlobalKey globalKey,
    PackageNetworkType packageNetworkType,
    PackageTargetType packageTargetType,
  ) async {
    // 缓存(网络中的token获取需要用到，所以需要最先初始化)
    // await LocalStorage.init();

    // 网络相关（接口请求+接口日志系统+网络环境切换+代理环境切换）
    String userApiToken = await UserInfoManager().getCacheUserAuthToken();
    await DevToolInit.initWithGlobalKey(
      globalKey,
      packageNetworkType,
      packageTargetType,
      logoutHandleWhenExitAppByChangeNetwork: () {
        if (UserInfoManager.isLoginState == true) {
          UserInfoManager().logout();
        }
      },
      userApiToken: userApiToken,
      channelName: 'channelName',
      logUserDescribeBlock: () {
        if (UserInfoManager.isLoginState) {
          User_manager_bean user = UserInfoManager.instance.userModel;
          String userDescribe = "${user.nickname ?? ''}(${user.tel ?? ''})";
          return userDescribe;
        } else {
          return '未登录';
        }
      },
      userNeedReloginHandle: () {
        // RouteManager.pushPage(null, RouteNames.loginPage);
      },
      onFloatingToolDoubleTap: (bContext) {
        BuildContext context = globalKey.currentContext;
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return const DebugPage();
        // }));
      },
    );
  }

  static Widget _buttonToPage(
      String buttonText, Widget pageWidget, GlobalKey globalKey) {
    return Container(
      padding: const EdgeInsets.only(right: 4),
      child: Center(
        child: ThemeBGButton(
          width: 70,
          height: 30,
          cornerRadius: 15,
          bgColorType: ThemeBGType.pink,
          title: buttonText,
          // titleStyle: RegularTextStyle(fontSize: 12),
          onPressed: () {
            BuildContext context = globalKey.currentContext;
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return pageWidget;
            }));
          },
        ),
      ),
    );
  }
}
