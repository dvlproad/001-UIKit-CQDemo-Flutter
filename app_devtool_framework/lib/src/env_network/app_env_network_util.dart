/*
 * @Author: dvlproad
 * @Date: 2023-03-27 17:22:14
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-27 18:54:46
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:app_network/app_network.dart';
import 'package:app_environment/app_environment.dart';

class AppNetworkKit {
  static Future<void> start(
    PackageNetworkType originPackageNetworkType,
    PackageTargetType originPackageTargetType, {
    String? token,
    required String channelName,
    required void Function() needReloginHandle, // 401等需要重新登录时候，执行的操作
    List<int>? Function()?
        forceNoToastStatusCodesGetFunction, // 获取哪些真正的statusCode药强制不弹 toast
    // 应用层信息的获取
    required String Function() uidGetBlock,
  }) async {
    await EnvManagerUtil.init_target_network_proxy(
      originPackageTargetType: originPackageTargetType,
      originPackageNetworkType: originPackageNetworkType,
    );

    // 环境初始化
    // network:api host
    await NetworkPageDataManager().initCompleter.future;
    TSEnvNetworkModel selectedNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;

    // target:
    await PackageTargetPageDataManager().initCompleter.future;
    PackageTargetModel selectedTargetModel =
        PackageTargetPageDataManager().selectedTargetModel;

    // proxy:
    await ProxyPageDataManager().initCompleter.future;
    TSEnvProxyModel selectedProxyModel =
        ProxyPageDataManager().selectedProxyModel;

    // network:api host
    AppNetworkInitUtil.start(
      selectedTargetModel: selectedTargetModel,
      selectedNetworkModel: selectedNetworkModel,
      selectedProxyModel: selectedProxyModel,
      token: token,
      channelName: channelName,
      mockApiHost: TSEnvironmentDataUtil.apiHost_mock,
      needReloginHandle: needReloginHandle,
      forceNoToastStatusCodesGetFunction: forceNoToastStatusCodesGetFunction,
      uidGetBlock: uidGetBlock,
    );

    // check network+proxy+mock
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      PackageCheckUpdateNetworkUtil.checkShouldResetNetwork(); //检查包的环境
    });
  }

  // 环境相关：环境切换界面
  static void initWithPage({
    required GlobalKey navigatorKey,
    required void Function() logoutHandleWhenExitAppByChangeNetwork,
  }) {
    EnvPageUtil.initWithPage(
      navigatorKey: navigatorKey,
      updateNetworkCallback: (TSEnvNetworkModel bNetworkModel) {
        changeOptions(bNetworkModel);
      },
      logoutHandleWhenExitAppByChangeNetwork:
          logoutHandleWhenExitAppByChangeNetwork,
      updateProxyCallback: (TSEnvProxyModel bProxyModel) {
        changeProxy(bProxyModel.proxyIp);
      },
      onPressTestApiCallback: (TestApiScene testApiScene) {
        // 测试环境改变之后，网络请求是否生效
        post(
          'login/doLogin',
          params: {
            "clientId": "clientApp",
            "clientSecret": "123123",
          },
        ).then((value) {
          debugPrint('测试的网络请求结束');
        });
      },
    );
  }

  // AppNetworkChangeUtil
  static void changeOptions(TSEnvNetworkModel bNetworkModel) {
    AppNetworkChangeUtil.changeOptions(bNetworkModel);
  }

  static bool changeProxy(String? proxyIp) {
    return AppNetworkChangeUtil.changeProxy(proxyIp);
  }

  /// 通用的GET请求
  static Future<ResponseModel> get(
    String api, {
    Map<String, dynamic>? params,
    int retryCount = 0, // 轮询次数,最后一次不管成功与否都要返回
    Duration? retryDuration, // 轮询间隔
    bool Function(ResponseModel responseModel)?
        retryStopConditionConfigBlock, // 是否请求停止的判断条件(为空时候,默认请求成功即停止)
    bool withLoading = false,
    bool? showToastForNoNetwork,
  }) async {
    return AppNetworkRequestUtil.get(
      api,
      params: params,
      retryCount: retryCount,
      retryDuration: retryDuration,
      retryStopConditionConfigBlock: retryStopConditionConfigBlock,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    );
  }

  /// 通用的POST请求(即使设置缓存，只要从缓存中取到了数据，那想要执行的正常请求会被跳过，不会执行)
  static Future<ResponseModel> post(
    String api, {
    Map<String, dynamic>? params,
    int retryCount = 0, // 轮询次数,最后一次不管成功与否都要返回
    Duration? retryDuration, // 轮询间隔
    bool Function(ResponseModel responseModel)?
        retryStopConditionConfigBlock, // 是否请求停止的判断条件(为空时候,默认请求成功即停止)
    bool withLoading = false,
    bool? showToastForNoNetwork,
  }) async {
    return AppNetworkRequestUtil.post(
      api,
      params: params,
      retryCount: retryCount,
      retryDuration: retryDuration,
      retryStopConditionConfigBlock: retryStopConditionConfigBlock,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    );
  }

  /// 通用的GET、POST请求(如果设置缓存，可实现如果从缓存中取到数据，仍然能继续执行正常的请求)
  static void getWithCallback(
    String api, {
    Map<String, dynamic>? params,
    bool? ifNoAuthorizationForceGiveUpRequest, // 没有 Authorization 的时候是否强制放弃请求
    int retryCount = 0,
    withLoading = false,
    AppNetworkCacheLevel cacheLevel = AppNetworkCacheLevel.none,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    AppNetworkRequestUtil.getWithCallback(
      api,
      params: params,
      ifNoAuthorizationForceGiveUpRequest: ifNoAuthorizationForceGiveUpRequest,
      retryCount: retryCount,
      cacheLevel: cacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: completeCallBack,
    );
  }

  static void postWithCallback(
    String api, {
    Map<String, dynamic>? params,
    bool? ifNoAuthorizationForceGiveUpRequest, // 没有 Authorization 的时候是否强制放弃请求
    int retryCount = 0,
    withLoading = false,
    AppNetworkCacheLevel cacheLevel = AppNetworkCacheLevel.none,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    AppNetworkRequestUtil.postWithCallback(
      api,
      params: params,
      ifNoAuthorizationForceGiveUpRequest: ifNoAuthorizationForceGiveUpRequest,
      retryCount: retryCount,
      cacheLevel: cacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: completeCallBack,
    );
  }

  /// 列表的请求(未设置会自动补上 pageNum pageSize 参数)
  static void postListWithCallback(
    String api, {
    required Map<String, dynamic> params,
    int retryCount = 0,
    AppListCacheLevel listCacheLevel = AppListCacheLevel.one,
    withLoading = false,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    AppNetworkRequestUtil.postListWithCallback(
      api,
      params: params,
      retryCount: retryCount,
      listCacheLevel: listCacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: completeCallBack,
    );
  }

  static Future<ResponseModel> postMonitorMessage(
    String messageParam,
  ) async {
    return AppNetworkRequestUtil.postMonitorMessage(messageParam);
  }
}
