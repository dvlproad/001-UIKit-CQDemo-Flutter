import 'package:meta/meta.dart'; // 为了使用 required
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:tencent_cos/tencent_cos.dart';
import 'dart:convert';

import './app_network/app_network_manager.dart';
import './app_network/app_network_cache_manager.dart';
import './trace/trace_util.dart';
import './monitor_network/monitor_network_manager.dart';
import './app_response_model_util.dart';
import './app_api_simulate_util.dart';

class AppNetworkKit {
  static void start({
    required Map<String, dynamic> commonHeaderParams,
    required String baseUrl, // 正常请求的 baseUrl
    required Map<String, dynamic> commonBodyParams,
    required String monitorBaseUrl, // 埋点请求的 baseUrl
    required Map<String, dynamic> monitorCommonBodyParams,
    required String token,
    required void Function() needReloginHandle, // 401等需要重新登录时候，执行的操作

    bool allowMock = false, // 是否允许 mock api
    String? mockApiHost, // 允许 mock api 的情况下，mock 到哪个地址
  }) {
    NetworkStatusManager(); // 提前开始获取网络类型环境

    CheckResponseModelUtil.init(needReloginHandle);
    AppNetworkManager().cache_start(
      baseUrl: baseUrl,
      headerCommonFixParams: commonHeaderParams,
      headerCommonChangeParamsGetBlock: () {
        return {
          'trace_id': TraceUtil.traceId(),
        };
      },
      headerAuthorization: token,
      bodyCommonFixParams: commonBodyParams,
      // bodyCommonChangeParamsGetBlock: () {
      //   return {
      //     'trace_id': TraceUtil.traceId(),
      //   };
      // },
      commonIgnoreKeysForCache: ['trace_id', 'retryCount'],
      allowMock: allowMock,
      mockApiHost: mockApiHost,
      localApiDirBlock: (apiPath) {
        return "asset/data";
      },
    );

    MonitorNetworkManager().cache_start(
      baseUrl: monitorBaseUrl,
      headerCommonFixParams: commonHeaderParams,
      headerAuthorization: token,
      bodyCommonFixParams: monitorCommonBodyParams,
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

  /************************* baseUrl 设置 *************************/
  static void changeOptions(TSEnvNetworkModel bNetworkModel) {
    AppNetworkManager().changeOptions(baseUrl: bNetworkModel.apiHost);
    MonitorNetworkManager()
        .changeOptions(baseUrl: bNetworkModel.monitorApiHost);
  }

  /************************* proxy 设置 *************************/
  static bool changeProxy(String proxyIp) {
    bool changeSuccess = AppNetworkManager().changeProxy(proxyIp);
    bool changeSuccess2 = MonitorNetworkManager().changeProxy(proxyIp);

    return changeSuccess;
  }

  /// 通用的GET请求
  static Future<ResponseModel> get(
    String api, {
    Map<String, dynamic>? params,
    bool withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) async {
    _tryDealApi(api, isGet: true);

    return AppNetworkManager().get(
      api,
      customParams: params,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    );
  }

  /// 通用的POST请求(即使设置缓存，只要从缓存中取到了数据，那想要执行的正常请求会被跳过，不会执行)
  static Future<ResponseModel> post(
    String api, {
    Map<String, dynamic>? params,
    bool withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) async {
    _tryDealApi(api, isGet: false);

    return AppNetworkManager().post(
      api,
      customParams: params,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    );
  }

  /// 通用的POST请求(如果设置缓存，可实现如果从缓存中取到数据，仍然能继续执行正常的请求)
  static void postWithCallback(
    String api, {
    Map<String, dynamic>? params,
    int retryCount = 0,
    withLoading = false,
    AppNetworkCacheLevel cacheLevel = AppNetworkCacheLevel.none,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    _tryDealApi(api, isGet: false);

    AppNetworkManager().postWithCallback(
      api,
      customParams: params,
      retryCount: retryCount,
      cacheLevel: cacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: completeCallBack,
    );
  }

  static _tryDealApi(String api, {required bool isGet}) {
    if (ApiManager.instance.allowMock == true) {
      ApiManager.tryAddApi(api, isGet: isGet);
      bool shouldMock = ApiManager.shouldAfterMockApi(api);
      if (shouldMock) {
        api = (api as String).toSimulateApi();
      }
    }
  }

  //*
  static bool Function()? _loginStateGetBlock;
  static List<String>?
      _ignoreRequestApiIfLogout; // 如果是未登录状态下，默认不请求(可省去外部加isLoginState()的判断)
  /// 是否不请求(如果是未登录状态下，默认不请求(可省去外部加isLoginState()的判断))
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
    _tryDealApi(api, isGet: false);

    Map<String, dynamic> customParams = {
      // "DataHubId": "datahub-y32g29n6", // 已添加到 commonParams 中
      // "Message": "[{\"Key\":\"\",\"Body\":{\"lib\":\"MiniProgram_app\"}},{\"Body\":{\"lib\":\"MiniProgram_app\"}}]",
      "Message": messageParam,
    };

    return MonitorNetworkManager().post(
      api,
      customParams: customParams,
      withLoading: false,
      showToastForNoNetwork: false,
    );
  }
}
