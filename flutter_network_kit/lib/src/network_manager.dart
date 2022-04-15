import 'package:meta/meta.dart'; // 为了使用 @required
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import './cache/cache_helper.dart';
export './cache/cache_helper.dart' show NetworkCacheLevel;

class NetworkKit {
  static DioCacheManager _manager;
  static DioCacheManager getCacheManager({String baseUrl}) {
    if (null == _manager) {
      _manager = DioCacheManager(CacheConfig(baseUrl: baseUrl));
    }
    return _manager;
  }

  static ResponseModel Function(
    ResponseModel responseModel, {
    bool showToastForNoNetwork, // 网络开小差的时候，是否显示toast(默认不toast)
  }) _checkResponseModelHandel;

  /// 初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  static void start({
    @required
        String baseUrl,
    @required
        Map<String, dynamic> commonParams,
    @required
        String token,
    @required
        ResponseModel Function(
      ResponseModel responseModel, {
      bool showToastForNoNetwork, // 网络开小差的时候，是否显示toast(默认不toast)
    })
            checkResponseModelHandel,
    bool allowMock, // 是否允许 mock api
    String mockApiHost, // 允许 mock api 的情况下，mock 到哪个地址
  }) {
    _checkResponseModelHandel = checkResponseModelHandel;

    DioLogInterceptor.initDioLogInterceptor(
      logApiInfoAction: (
        String fullUrl,
        String logString, {
        ApiProcessType apiProcessType, // api 请求的阶段类型
        ApiLogLevel apiLogLevel, // api 日志信息类型
        bool isCacheApiLog, // 是否是缓存请求的日志
      }) {
        String serviceValidProxyIp = NetworkManager.serviceValidProxyIp;
        Map extraApiLogInfo = {
          "hasProxy": serviceValidProxyIp != null,
        };
        if (isCacheApiLog != null) {
          extraApiLogInfo.addAll({
            "isCacheApiLog": isCacheApiLog,
          });
        }
        if (apiLogLevel == ApiLogLevel.error) {
          LogUtil.apiError(fullUrl, logString, extraLogInfo: extraApiLogInfo);
        } else if (apiLogLevel == ApiLogLevel.warning) {
          LogUtil.apiWarning(fullUrl, logString, extraLogInfo: extraApiLogInfo);
        } else {
          if (apiProcessType == ApiProcessType.response) {
            LogUtil.apiSuccess(fullUrl, logString,
                extraLogInfo: extraApiLogInfo);
          } else {
            LogUtil.apiNormal(fullUrl, logString,
                extraLogInfo: extraApiLogInfo);
          }
        }
      },
      isCacheRequestCheckBlock: (options) {
        bool isRequestCache = CacheHelper.isCacheRequest(options);
        return isRequestCache;
      },
      isCacheErrorCheckBlock: (err) {
        bool isFromCache = CacheHelper.isCacheError(err);
        return isFromCache;
      },
      isCacheResponseCheckBlock: (response) {
        bool isFromCache = CacheHelper.isCacheResponse(response);
        return isFromCache;
      },
    );

    List<Interceptor> extraInterceptors = [
      getCacheManager(baseUrl: baseUrl).interceptor,
    ];

    Map<String, dynamic> headers;
    if (token != null && token.isNotEmpty) {
      headers = {'Authorization': token};
    }
    if (commonParams != null) {
      if (headers == null) {
        headers = commonParams;
      } else {
        headers.addAll(commonParams);
      }
    }
    NetworkManager.start(
      baseUrl: baseUrl,
      headers: headers,
      connectTimeout: 15000,
      interceptors: extraInterceptors,
    );
  }

  post2() {}

  /// 通用的GET请求
  static Future<ResponseModel> get(
    String api, {
    Map<String, dynamic> customParams,
    NetworkCacheLevel cacheLevel = NetworkCacheLevel.none,
    withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) async {
    if (withLoading == true) {
      LoadingUtil.show();
    }

    return NetworkUtil.getRequestUrl(
      api,
      customParams: customParams,
      options: CacheHelper.buildOptions(cacheLevel),
    ).then((ResponseModel responseModel) {
      if (withLoading == true) {
        LoadingUtil.dismiss();
      }

      return _checkResponseModelHandel(
        responseModel,
        showToastForNoNetwork: showToastForNoNetwork,
      );
    });
  }

  /*
  /// 通用的POST请求(如果设置缓存，可实现如果从缓存中取到数据，仍然能继续执行正常的请求)
  static void postWithCallback(
    String api, {
    Map<String, dynamic> params,
    withLoading,
    NetworkCacheLevel cacheLevel = NetworkCacheLevel.none,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
    @required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    post(
      api,
      customParams: params,
      withLoading: withLoading,
      cacheLevel: cacheLevel,
      showToastForNoNetwork: showToastForNoNetwork ?? false,
    ).then((ResponseModel responseModel) {
      if (completeCallBack == null) {
        print('温馨提示:本次请求，你没有实现回调方法$api');
        return;
      }

      if (responseModel.isCache == true) {
        completeCallBack(responseModel);

        //print('底层网络库:这是缓存数据');

        if (cacheLevel == NetworkCacheLevel.one) {
          cacheLevel = NetworkCacheLevel.forceRefreshAndCacheOne;
        }

        postWithCallback(
          api,
          params: params,
          withLoading: withLoading,
          cacheLevel: cacheLevel,
          showToastForNoNetwork: showToastForNoNetwork ?? false,
          completeCallBack: completeCallBack,
        );
      } else {
        // completeCallBack(responseModel);

        // 如果实际的请求失败，则尝试再进行请求
        if (responseModel.statusCode == 0) {
          completeCallBack(responseModel);
        } else {
          int retryCount = params['retryCount'];
          if (retryCount != null && retryCount > 1) {
            retryCount--;
            params['retryCount'] = retryCount;
            if (cacheLevel == NetworkCacheLevel.one ||
                cacheLevel == NetworkCacheLevel.forceRefreshAndCacheOne) {
              cacheLevel = NetworkCacheLevel.forceRefreshAndCacheOne;
            } else {
              cacheLevel = NetworkCacheLevel.none;
            }

            postWithCallback(
              api,
              params: params,
              withLoading: withLoading,
              cacheLevel: cacheLevel,
              showToastForNoNetwork: showToastForNoNetwork ?? false,
              completeCallBack: completeCallBack,
            );
          }
        }
      }
    });
  }
  */

  /// 通用的POST请求(即使设置缓存，只要从缓存中取到了数据，那想要执行的正常请求会被跳过，不会执行)
  static Future<ResponseModel> post(
    String api, {
    Map<String, dynamic> customParams,
    NetworkCacheLevel cacheLevel = NetworkCacheLevel.none,
    withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) async {
    if (withLoading == true) {
      LoadingUtil.show();
    }

    return NetworkUtil.postRequestUrl(
      api,
      customParams: customParams,
      options: CacheHelper.buildOptions(cacheLevel),
    ).then((ResponseModel responseModel) {
      if (withLoading == true) {
        LoadingUtil.dismiss();
      }

      return _checkResponseModelHandel(
        responseModel,
        showToastForNoNetwork: showToastForNoNetwork,
      );
    });
  }

  Future retryWhenError(DioError err) async {
    Dio dio = NetworkManager.instance.serviceDio; // 获取dio单例

    RequestOptions requestOptions =
        err.response.requestOptions; //千万不要调用 err.request
    try {
      var response = await dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        cancelToken: requestOptions.cancelToken,
        // options: requestOptions,
        onReceiveProgress:
            requestOptions.onReceiveProgress, //TODO 差一个onSendProgress
      );
      return response;
    } on DioError catch (e) {
      return e;
    }
  }
}
