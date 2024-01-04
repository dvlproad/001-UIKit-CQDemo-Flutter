// ignore_for_file: non_constant_identifier_names, camel_case_types

/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-04 17:21:06
 * @Description: 
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

import 'package:app_network_kit/app_network_kit.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_environment_base/flutter_environment_base.dart';

import './page/ts_network_home_page.dart';
import './page/ts_dio_home_page.dart';
import './app_env_network_util.dart';

class TSNetworkMainPage extends CJTSBaseTabBarPage {
  TSNetworkMainPage({Key? key}) : super(key: key);

  @override
//  _TSNetworkMainPageState createState() => _TSNetworkMainPageState();
  CJTSBaseTabBarPageState getState() => _TSNetworkMainPageState();
}

class _TSNetworkMainPageState
    extends CJTSBaseTabBarPageState<TSNetworkMainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  List<dynamic> get tabbarModels {
    List<dynamic> tabbarModels = [
      {
        'title': "Dio",
        'nextPage': TSDioHomePage(),
      },
      {
        'title': "Network",
        'nextPage': const TSNetworkHomePage(),
      },
      {
        'title': "Network(wu）",
        'nextPage': const TSNetworkHomePage(),
      },
    ];

    return tabbarModels;
  }
}

class APP_Network_And_AllEnvironmentUtil {
  static initNetworkAndProxy_demo({
    required GlobalKey globalKey,
    String? currentUserApiToken,
  }) async {
    await _initNetworkAndProxy(
      PackageNetworkType.product,
      PackageTargetType.formal,
      globalKey: globalKey,
      channelName: 'apple',
      tryLogoutHandle: () {
        CJTSToastUtil.showMessage("退出登录");
      },
      currentUserApiToken: currentUserApiToken,
      userReloginHandle: (ResponseModel responseModel) {
        CJTSToastUtil.showMessage("重新登录");
      },
    );
  }

  static _initNetworkAndProxy(
    PackageNetworkType originPackageNetworkType,
    PackageTargetType originPackageTargetType, {
    required String channelName,
    required GlobalKey globalKey,
    required void Function() tryLogoutHandle, // 尝试退出登录,仅在切换环境需要退出登录的时候调用
    String? currentUserApiToken,
    required void Function(ResponseModel responseModel)
        userReloginHandle, // 需要重新登录时候，执行的操作
  }) async {
    // 配置网络
    await AppNetworkKit.start(
      originPackageNetworkType,
      originPackageTargetType,
      channelName: channelName,
      token: currentUserApiToken,
      needReloginHandle: userReloginHandle,
      forceNoToastStatusCodesGetFunction: () {
        return null;
      },
      uidGetBlock: () {
        String? uid = "UserInfoManager().userModel.userId";
        if (uid == null) {
          debugPrint("Errror:uid不能为空,请检查，下方先临时赋值，让其通过");
          uid = '0';
        }
        return uid;
      },
      accountIdGetBlock: () {
        return "UserInfoManager().userModel?.id ?? ''";
      },
      nicknameGetBlock: () {
        return "UserInfoManager().userModel?.nickname ?? ''";
      },
    );

    AppNetworkKit.initWithPage(
      navigatorKey: globalKey,
      logoutHandleWhenExitAppByChangeNetwork: tryLogoutHandle,
    );
  }
}
