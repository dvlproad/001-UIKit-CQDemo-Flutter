import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_network/src/network_client.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import './api_error_robot.dart';
import './compile_mode_util.dart';
export './compile_mode_util.dart';

extension SimulateExtension on String {
  String toSimulateApi() {
    String simulateApiHost = ApiManager.instance.mockApiHost;
    List<String> allMockApiHosts = ["http://dev.api.xihuanwu.com/hapi/"];
    String newApi = this.addSimulateApiHost(
      simulateApiHost,
      allMockApiHosts: allMockApiHosts,
    );

    //print('mock newApi = ${newApi}');
    return newApi;
  }
}

/// 网络缓存
enum NetworkCacheLevel {
  none, // 不需要缓存
  one,
  forceRefreshAndCacheOne, // 强制刷新本次，并且缓存本次的数据以备下次使用

}

class NetworkKit {
  static DioCacheManager _manager;
  static DioCacheManager getCacheManager({String baseUrl}) {
    if (null == _manager) {
      _manager = DioCacheManager(CacheConfig(baseUrl: baseUrl));
    }
    return _manager;
  }

  /// 初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  static void start({
    String baseUrl,
    bool allowMock, // 是否允许 mock api
    String mockApiHost, // 允许 mock api 的情况下，mock 到哪个地址
  }) {
    DioLogInterceptor.logApiInfoAction = (
      String fullUrl,
      String logString, {
      ApiProcessType apiProcessType, // api 请求的阶段类型
      ApiLogLevel apiLogLevel, // api 日志信息类型
    }) {
      if (apiLogLevel == ApiLogLevel.error) {
        LogUtil.error(logString);
      } else if (apiLogLevel == ApiLogLevel.warning) {
        LogUtil.warning(logString);
      } else {
        LogUtil.normal(logString);
      }

      bool shouldPostApiError = false;
      String serviceValidProxyIp = NetworkChangeUtil.serviceValidProxyIp;
      if (apiLogLevel == ApiLogLevel.error) {
        ComplieMode complieMode = ComplieModeUtil.getCompileMode();
        if (complieMode == ComplieMode.debug) {
          if (serviceValidProxyIp != null) {
            // debug 且有代理的时候，如果发生错误，是否通知到企业微信
            shouldPostApiError = false;
          } else {
            shouldPostApiError = true;
          }
        } else {
          shouldPostApiError = true;
        }
      }

      if (shouldPostApiError) {
        ApiErrorRobot.postApiError(
          fullUrl,
          logString,
          serviceValidProxyIp: serviceValidProxyIp,
        );
      }
    };

    List<Interceptor> extraInterceptors = [
      getCacheManager(baseUrl: baseUrl).interceptor,
    ];

    NetworkManager.start(
      baseUrl: baseUrl,
      connectTimeout: 15000,
      interceptors: extraInterceptors,
    );

    // 是否允许 mock api 及 允许 mock api 的情况下，mock 到哪个地址
    ApiManager.updateCanMock(allowMock ?? false);
    if (allowMock == true && mockApiHost == null) {
      throw Exception('允许 mock api 的情况下，要 mock 到地址 mockApiHost 不能为空');
    }
    ApiManager.configMockApiHost(mockApiHost);
  }

  /// 通用的GET请求
  static Future<ResponseModel> get(
    String api, {
    Map<String, dynamic> params,
    NetworkCacheLevel cacheLevel = NetworkCacheLevel.one,
    withLoading = true,
    bool isUrl = false,
  }) async {
    ApiManager.tryAddApi(api, isGet: true);

    return NetworkUtil.getRequestUrl(
      api,
      customParams: params,
      options: _dioOptions(cacheLevel),
    );
  }

  /// 通用的POST请求(如果设置缓存，可实现如果从缓存中取到数据，仍然能继续执行正常的请求)
  static void postWithCallback(
    String api, {
    Map<String, dynamic> params,
    withLoading = true,
    NetworkCacheLevel cacheLevel = NetworkCacheLevel.none,
    void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    post(
      api,
      params: params,
      withLoading: withLoading,
      cacheLevel: cacheLevel,
    ).then((ResponseModel responseModel) {
      if (completeCallBack == null) {
        print('温馨提示:本次请求，你没有实现回调方法$api');
        return;
      }
      completeCallBack(responseModel);

      if (responseModel.isCache == true) {
        //print('底层网络库:这是缓存数据');

        if (cacheLevel == NetworkCacheLevel.one) {
          cacheLevel = NetworkCacheLevel.forceRefreshAndCacheOne;
        }

        postWithCallback(
          api,
          params: params,
          withLoading: withLoading,
          cacheLevel: cacheLevel,
          completeCallBack: completeCallBack,
        );
      }
    });
  }

  /// 通用的POST请求(即使设置缓存，只要从缓存中取到了数据，那想要执行的正常请求会被跳过，不会执行)
  static Future<ResponseModel> post(
    String api, {
    Map<String, dynamic> params,
    NetworkCacheLevel cacheLevel = NetworkCacheLevel.one,
    withLoading = true,
  }) async {
    if (ApiManager.instance.allowMock == true) {
      ApiManager.tryAddApi(api, isGet: false);
      bool shouldMock = ApiManager.shouldAfterMockApi(api);
      if (shouldMock) {
        api = (api as String).toSimulateApi();
      }
    }

    return NetworkUtil.postRequestUrl(
      api,
      customParams: params,
      options: _dioOptions(cacheLevel),
    );
  }

  static Options _dioOptions(NetworkCacheLevel cacheLevel) {
    Options dioOptions = null;
    if (cacheLevel == NetworkCacheLevel.one) {
      dioOptions = buildCacheOptions(
        Duration(days: 0, hours: 1),
        // options: Options(
        //   contentType: "application/x-www-form-urlencoded",
        // ),
        forceRefresh: false,
      );
    } else if (cacheLevel == NetworkCacheLevel.forceRefreshAndCacheOne) {
      dioOptions = buildCacheOptions(
        Duration(days: 0, hours: 1),
        // options: Options(
        //   contentType: "application/x-www-form-urlencoded",
        // ),
        forceRefresh: true,
      );
    }

    return dioOptions;
  }
}
