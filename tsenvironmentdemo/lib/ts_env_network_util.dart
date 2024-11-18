/*
 * @Author: dvlproad
 * @Date: 2024-11-18 20:47:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-11-18 20:53:41
 * @Description: 
 */
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:app_environment/app_environment.dart';
import 'package:flutter_environment_kit/flutter_environment_kit.dart';
export 'package:flutter_environment_kit/flutter_environment_kit.dart'
    show EnvPage, PackageNetworkType;

import 'package:flutter/material.dart';

GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

class TSEnvNetworkUtil {
  static void initEnv(PackageNetworkType originPackageNetworkType) async {
    AppEnvSingleton().init_target_network_proxy(
      originPackageTargetType: PackageTargetType.dev,
      originPackageNetworkType: originPackageNetworkType,
    );
    await NetworkPageDataManager().initCompleter.future;

    await ProxyPageDataManager().initCompleter.future;

    await PackageTargetPageDataManager().initCompleter.future;

    // 网络环境相关：环境切换界面
    EnvPageUtil.initWithPage(
      navigatorKey: globalKey,
      updateNetworkCallback: (bNetworkModel) {
        CJTSToastUtil.showMessage("网络环境修改回调:${bNetworkModel.apiHost}");
      },
      logoutHandleWhenExitAppByChangeNetwork: () {
        CJTSToastUtil.showMessage("尝试退出登录,仅在切换环境需要退出登录的时候调用");
      },
      updateProxyCallback: (bProxyModel) {
        CJTSToastUtil.showMessage("代理环境修改回调:${bProxyModel.proxyIp}");
      },
      onPressTestApiCallback: (TestApiScene testApiScene) {
        // 测试环境改变之后，网络请求是否生效
        CJTSToastUtil.showMessage("测试环境改变之后，网络请求是否生效的方法");
      },
    );

    // network
    TSEnvNetworkModel initNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;
    String initApiHost = initNetworkModel?.apiHost ?? "初始化失败，请检查";
    CJTSToastUtil.showMessage("网络环境初始化完成回调:$initApiHost");

    // proxy:
    TSEnvProxyModel initProxyModel = ProxyPageDataManager().selectedProxyModel;
    String initProxyIp = initProxyModel?.proxyIp ?? "无代理";
    CJTSToastUtil.showMessage("代理环境初始化完成回调:$initProxyIp");

    // 是否允许 mock api 及 允许 mock api 的情况下，mock 到哪个地址
    String mockApiHost = "TSEnvironmentDataUtil.apiHost_mock";

    ApiManager().setup(
      allowMock: true,
      mockApiHost: mockApiHost,
    );
    if (mockApiHost == null) {
      throw Exception('允许 mock api 的情况下，要 mock 到地址 mockApiHost 不能为空');
    } else {
      CJTSToastUtil.showMessage("模拟接口的mockApiHost:$mockApiHost");
    }
  }
}
