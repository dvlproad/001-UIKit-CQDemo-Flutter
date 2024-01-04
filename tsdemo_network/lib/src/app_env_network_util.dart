/*
 * @Author: dvlproad
 * @Date: 2023-03-27 17:22:14
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-04 17:47:48
 * @Description: 
 */

import 'package:flutter/material.dart';
import 'package:app_network_kit/app_network_kit.dart';
import 'package:app_environment/app_environment.dart';
import 'package:flutter_log_with_env/flutter_log_with_env.dart';
import 'package:event_bus/event_bus.dart';

class AppNetworkKit {
  static EventBus networkEventBus = EventBus();

  static Future<void> start(
    PackageNetworkType originPackageNetworkType,
    PackageTargetType originPackageTargetType, {
    String? token,
    required String channelName,
    required void Function(ResponseModel responseModel)
        needReloginHandle, // 401等需要重新登录时候，执行的操作
    List<int>? Function()?
        forceNoToastStatusCodesGetFunction, // 获取哪些真正的statusCode药强制不弹 toast
    // 应用层信息的获取
    required String Function() uidGetBlock,
    required String Function() accountIdGetBlock,
    required String Function() nicknameGetBlock,
  }) async {
    AppLogUtil.logMessage(
      logType: LogObjectType.sdk_other,
      logLevel: LogLevel.normal,
      shortMap: {
        "message": '初始化网络库前先获取网络库信息',
      },
      detailMap: {
        "message": '初始化网络库前先获取网络库信息',
      },
    );

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
      needReloginHandle: needReloginHandle,
      forceNoToastStatusCodesGetFunction: forceNoToastStatusCodesGetFunction,
      uidGetBlock: uidGetBlock,
      accountIdGetBlock: accountIdGetBlock,
      nicknameGetBlock: nicknameGetBlock,
      assetUploadMonitorHandle: (String localPath, bool multipart) {
        // BuriedPointManager().addEvent("willupload_asset", {
        //   "localPath": localPath, // 仅是为了查看请求参数，排查本地资源上传的桶是否异常
        //   "multipart": multipart, // 仅是为了查看请求参数，排查本地资源上传的桶是否异常
        // });
      },
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
    String? pageCode,
    String? pageType,
    Map<String, dynamic>? params,
    int retryCount = 0, // 轮询次数,最后一次不管成功与否都要返回
    Duration? retryDuration, // 轮询间隔
    bool Function(ResponseModel responseModel)?
        retryStopConditionConfigBlock, // 是否请求停止的判断条件(为空时候,默认请求成功即停止)
    bool withLoading = false,
    bool? showToastForNoNetwork,
  }) async {
    _fireNetworkEvent(pageCode: pageCode, api: api);
    return AppNetworkRequestUtil.get(
      api,
      params: params,
      retryCount: retryCount,
      retryDuration: retryDuration,
      retryStopConditionConfigBlock: retryStopConditionConfigBlock,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    ).then((responseModel) {
      _fireNetworkEvent(
          pageCode: pageCode,
          api: api,
          pageType: pageType,
          responseModel: responseModel);
      return responseModel;
    });
  }

  /// 通用的POST请求(即使设置缓存，只要从缓存中取到了数据，那想要执行的正常请求会被跳过，不会执行)
  static Future<ResponseModel> post(
    String api, {
    String? pageCode,
    String? pageType,
    Map<String, dynamic>? params,
    int retryCount = 0, // 轮询次数,最后一次不管成功与否都要返回
    Duration? retryDuration, // 轮询间隔
    bool Function(ResponseModel responseModel)?
        retryStopConditionConfigBlock, // 是否请求停止的判断条件(为空时候,默认请求成功即停止)
    bool withLoading = false,
    bool? showToastForNoNetwork,
  }) async {
    _fireNetworkEvent(pageCode: pageCode, api: api);
    return AppNetworkRequestUtil.post(
      api,
      params: params,
      retryCount: retryCount,
      retryDuration: retryDuration,
      retryStopConditionConfigBlock: retryStopConditionConfigBlock,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    ).then((responseModel) {
      _fireNetworkEvent(
          pageCode: pageCode,
          api: api,
          pageType: pageType,
          responseModel: responseModel);
      return responseModel;
    });
  }

  /// 通用的GET、POST请求(如果设置缓存，可实现如果从缓存中取到数据，仍然能继续执行正常的请求)
  static void getWithCallback(
    String api, {
    String? pageCode,
    String? pageType,
    Map<String, dynamic>? params,
    bool? ifNoAuthorizationForceGiveUpRequest, // 没有 Authorization 的时候是否强制放弃请求
    int retryCount = 0,
    withLoading = false,
    AppNetworkCacheLevel cacheLevel = AppNetworkCacheLevel.none,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    _fireNetworkEvent(pageCode: pageCode, api: api);
    AppNetworkRequestUtil.getWithCallback(api,
        params: params,
        ifNoAuthorizationForceGiveUpRequest:
            ifNoAuthorizationForceGiveUpRequest,
        retryCount: retryCount,
        cacheLevel: cacheLevel,
        withLoading: withLoading,
        showToastForNoNetwork: showToastForNoNetwork,
        completeCallBack: (ResponseModel responseModel) {
      _fireNetworkEvent(
          pageCode: pageCode,
          api: api,
          pageType: pageType,
          responseModel: responseModel);
      completeCallBack(responseModel);
    });
  }

  static void postWithCallback(
    String api, {
    String? pageCode,
    String? pageType,
    Map<String, dynamic>? params,
    bool? ifNoAuthorizationForceGiveUpRequest, // 没有 Authorization 的时候是否强制放弃请求
    int retryCount = 0,
    withLoading = false,
    AppNetworkCacheLevel cacheLevel = AppNetworkCacheLevel.none,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    _fireNetworkEvent(pageCode: pageCode, api: api);
    AppNetworkRequestUtil.postWithCallback(
      api,
      params: params,
      ifNoAuthorizationForceGiveUpRequest: ifNoAuthorizationForceGiveUpRequest,
      retryCount: retryCount,
      cacheLevel: cacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: (ResponseModel responseModel) {
        _fireNetworkEvent(
            pageCode: pageCode,
            api: api,
            pageType: pageType,
            responseModel: responseModel);
        completeCallBack(responseModel);
      },
    );
  }

  /// 列表的请求(未设置会自动补上 pageNum pageSize 参数)
  static void postListWithCallback(
    String api, {
    String? pageCode,
    String? pageType,
    required Map<String, dynamic> params,
    int retryCount = 0,
    AppListCacheLevel listCacheLevel = AppListCacheLevel.one,
    withLoading = false,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    _fireNetworkEvent(pageCode: pageCode, api: api);
    AppNetworkManager().postListWithCallback(
      api,
      customParams: params,
      retryCount: retryCount,
      listCacheLevel: listCacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: (ResponseModel responseModel) {
        _fireNetworkEvent(
            pageCode: pageCode,
            api: api,
            pageType: pageType,
            responseModel: responseModel);
        completeCallBack(responseModel);
      },
    );
  }

  static void postListCache(
    String api, {
    String? pageCode,
    String? pageType,
    required Map<String, dynamic> params,
    int retryCount = 0,
    bool withLoading = false,
    AppListCacheLevel listCacheLevel = AppListCacheLevel.one,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) {
    _fireNetworkEvent(pageCode: pageCode, pageType: pageType, api: api);
    AppNetworkListCacheUtil.post(api,
            params: params,
            retryCount: retryCount,
            withLoading: withLoading,
            listCacheLevel: listCacheLevel,
            showToastForNoNetwork: showToastForNoNetwork)
        .then((responseModel) {
      _fireNetworkEvent(
          pageCode: pageCode,
          api: api,
          pageType: pageType,
          responseModel: responseModel);
      completeCallBack(responseModel);
    });
  }

  static Future<ResponseModel> postMonitorMessage(
    String messageParam,
  ) async {
    return AppNetworkRequestUtil.postMonitorMessage(messageParam);
  }

  static _fireNetworkEvent(
      {String? pageCode,
      String? pageType,
      required String api,
      ResponseModel? responseModel}) {
    //
  }
}
