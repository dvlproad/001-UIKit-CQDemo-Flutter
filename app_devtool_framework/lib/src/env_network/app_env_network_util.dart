import 'package:flutter/material.dart';
import 'package:app_network/app_network.dart';
import 'package:app_environment/app_environment.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_foundation_base/flutter_foundation_base.dart';

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
    _start(
      appFeatureType: selectedTargetModel.envId,
      baseUrl: selectedNetworkModel.apiHost,
      monitorBaseUrl: selectedNetworkModel.monitorApiHost,
      getMonitorDataHubIdBlock: () {
        String monitorDataHubId =
            NetworkPageDataManager().selectedNetworkModel.monitorDataHubId;
        return monitorDataHubId;
      },
      token: token,
      channelName: channelName,
      mockApiHost: TSEnvironmentDataUtil.apiHost_mock,
      needReloginHandle: needReloginHandle,
      forceNoToastStatusCodesGetFunction: forceNoToastStatusCodesGetFunction,
      uidGetBlock: uidGetBlock,
      packageNetworkTypeGetBlock: () {
        return NetworkPageDataManager().selectedNetworkModel.type;
      },
    );

    // proxy:
    changeProxy(selectedProxyModel.proxyIp);

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

  static void _start({
    required String appFeatureType,
    required String baseUrl, // 正常请求的 baseUrl
    required String monitorBaseUrl, // 埋点请求的 baseUrl
    required String Function()
        getMonitorDataHubIdBlock, // 埋点请求的 DataHubId 的获取方法
    String? token,
    required void Function() needReloginHandle, // 401等需要重新登录时候，执行的操作
    List<int>? Function()?
        forceNoToastStatusCodesGetFunction, // 获取哪些真正的statusCode药强制不弹 toast
    String? mockApiHost, // 允许 mock api 的情况下，mock 到哪个地址
    // 应用层信息的获取
    required String Function() uidGetBlock,
    required String channelName,
    required PackageNetworkType Function() packageNetworkTypeGetBlock,
  }) async {
    NetworkStatusManager(); // 提前开始获取网络类型环境

    Map<String, dynamic> commonHeaderParams =
        await CommonParamsHelper.commonHeaderParams(
      appFeatureType: appFeatureType,
      channel: channelName,
    );
    bool allowMock = true;

    CheckResponseModelUtil.init(
      needReloginHandle: needReloginHandle,
      forceNoToastStatusCodesGetFunction: forceNoToastStatusCodesGetFunction,
    );

    Map<String, dynamic> apiCommonBodyParams = {};
    AppNetworkManager().start(
      baseUrl: baseUrl,
      headerCommonFixParams: commonHeaderParams,
      headerAuthorization: token,
      // headerAuthorizationWhiteList: await _getHeaderAuthorizationWhiteList(),
      bodyCommonFixParams: apiCommonBodyParams,
      allowMock: allowMock,
      mockApiHost: mockApiHost,
      uidGetBlock: uidGetBlock,
    );

    Map<String, dynamic> monitorPublicParamsMap =
        await CommonParamsHelper.fixedCommonParams();
    String monitorPublicParamsString =
        FormatterUtil.convert(monitorPublicParamsMap, 0);
    Map<String, dynamic> monitorCommonBodyParams = {
      "Public": monitorPublicParamsString,
    };
    MonitorNetworkManager().normal_start(
      baseUrl: monitorBaseUrl,
      headerCommonFixParams: commonHeaderParams,
      headerAuthorization: token,
      bodyCommonFixParams: monitorCommonBodyParams,
      bodyCommonChangeParamsGetBlock: () {
        String monitorDataHubId = getMonitorDataHubIdBlock();
        return {
          "DataHubId": monitorDataHubId,
        };
      },
      allowMock: allowMock,
      mockApiHost: mockApiHost,
      localApiDirBlock: (apiPath) {
        return "asset/data";
      },
    );

    if (allowMock == true && mockApiHost != null) {
      // 允许 mock api 的情况下，要 mock 到的地址 mockApiHost 不能为空
      ApiManager().setup(
        allowMock: allowMock,
        mockApiHost: mockApiHost,
      );
    }
  }

  /// *********************** baseUrl 设置 ************************
  static void changeOptions(TSEnvNetworkModel bNetworkModel) {
    AppNetworkManager().changeOptions(baseUrl: bNetworkModel.apiHost);
    MonitorNetworkManager()
        .changeOptions(baseUrl: bNetworkModel.monitorApiHost);
  }

  /// *********************** proxy 设置 ************************
  static bool changeProxy(String? proxyIp) {
    bool changeSuccess = AppNetworkManager().changeProxy(proxyIp);
    // bool changeSuccess2 = MonitorNetworkManager().changeProxy(proxyIp);

    return changeSuccess;
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
    return AppNetworkManager().get(
      api,
      customParams: params,
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
    return AppNetworkManager().post(
      api,
      customParams: params,
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
    AppNetworkManager().requestWithCallback(
      api,
      requestMethod: RequestMethod.get,
      customParams: params,
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
    AppNetworkManager().requestWithCallback(
      api,
      requestMethod: RequestMethod.post,
      customParams: params,
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
    AppNetworkManager().postListWithCallback(
      api,
      customParams: params,
      retryCount: retryCount,
      listCacheLevel: listCacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: completeCallBack,
    );
  }

  //*
  static bool Function()? _loginStateGetBlock;
  static List<String>?
      _ignoreRequestApiIfLogout; // 如果是未登录状态下，默认不请求(可省去外部加isLoginState()的判断)

  /// 是否不请求(如果是未登录状态下，默认不请求(可省去外部加isLoginState()的判断))
  // ignore: unused_element
  static bool _shouldIgnoreRequest(String api) {
    if (_loginStateGetBlock != null &&
        _ignoreRequestApiIfLogout != null &&
        _ignoreRequestApiIfLogout!.isNotEmpty) {
      bool isLogin = _loginStateGetBlock!();
      if (isLogin == false) {
        String apiPath;
        int index = api.indexOf('/hapi/');

        if (index != -1) {
          apiPath = api.substring(index + '/hapi'.length);
        } else {
          apiPath = api;
        }
        if (_ignoreRequestApiIfLogout!.contains(apiPath)) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
  //*/

  ////////// ----------------- 埋点请求 ----------------- //////////

  static Future<ResponseModel> postMonitorMessage(
    String messageParam,
  ) async {
    String api = '/bi/sendMessage';

    Map<String, dynamic> customParams = {
      // "DataHubId": "datahub-y32g29n6", // 已添加到 commonParams 中
      // "Message": "[{\"Key\":\"\",\"Body\":{\"lib\":\"MiniProgram_app\"}},{\"Body\":{\"lib\":\"MiniProgram_app\"}}]",
      "Message": messageParam,
    };

    return MonitorNetworkManager().mock_requestUrl(
      api,
      requestMethod: RequestMethod.post,
      customParams: customParams,
      withLoading: false,
      showToastForNoNetwork: false,
    );
  }

  /*
  List<String>? _getHeaderAuthorizationWhiteList() async {
    return [
      "config/biz-config",
      "config/home",
      "config/getResources",

      "login/device-config", //获取活动落地页

      "login/loginOut", //退出登录
      "login/doLogin", //用户一键登录
      "login/checkAuthorizationAccount", //获取当前微信登录用户是否存在手机号
      "user/account/getTelCaptcha", //用户发送验证码
      "user/account/get_city", //获取全国地址
      // 以上是自己整的
    ];

    // 以下是后台给的
    List<String>? headerAuthorizationWhiteList;
    try {
      // import 'package:flutter/services.dart'; // 用于使用 rootBundle
      //var value = await rootBundle.loadString("assets/data/app_info.json");
      var value = await rootBundle
          .loadString("packages/app_network/assets/data/whitelist.json");
      if (value != null) {
        Map<String, dynamic> data =
            json.decode(value); // import 'dart:convert'; // 用于使用json.decode

        List<String>? monitorHeaderAuthorizationWhiteList =
            data['monitor_white_list'];
        if (monitorHeaderAuthorizationWhiteList != null) {
          headerAuthorizationWhiteList ??= [];
          headerAuthorizationWhiteList.add(monitorHeaderAuthorizationWhiteList);
        }
        List<String>? appHeaderAuthorizationWhiteList = data['app_white_list'];
        if (monitorHeaderAuthorizationWhiteList != null) {
          headerAuthorizationWhiteList ??= [];
          headerAuthorizationWhiteList.add(appHeaderAuthorizationWhiteList);
        }

        return headerAuthorizationWhiteList;
      }
    } catch (e) {
      if (_isDebug() == false) {
        print('whitelist.json文件内容获取失败,可能未存在或解析过程出错');
      }
    }
  }
  */
}
