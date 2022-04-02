import 'package:meta/meta.dart'; // 为了使用 @required
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_network/src/network_client.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

extension SimulateExtension on String {
  String toSimulateApi() {
    String simulateApiHost = ApiManager.instance.mockApiHost;
    List<String> allMockApiHosts = ["http://dev.api.xihuanwu.com/hapi/"];
    String newApi = this.newApi(
      newApiHost: simulateApiHost,
      shouldChangeApiHosts: allMockApiHosts,
    );

    //print('mock newApi = ${newApi}');
    return newApi;
  }

  String toLocalApi() {
    String localApiHost = NetworkUtil.localApiHost;
    List<String> allMockApiHosts = ["http://dev.api.xihuanwu.com/hapi/"];
    String newApi = this.newApi(
      newApiHost: localApiHost,
      shouldChangeApiHosts: allMockApiHosts,
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

  static void Function() _needReloginHandle;

  /// 初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  static void start({
    @required String baseUrl,
    @required Map<String, dynamic> commonParams,
    @required String token,
    bool allowMock, // 是否允许 mock api
    String mockApiHost, // 允许 mock api 的情况下，mock 到哪个地址
    @required void Function() needReloginHandle, // 401等需要重新登录时候，执行的操作
  }) {
    _needReloginHandle = needReloginHandle;

    DioLogInterceptor.logApiInfoAction = (
      String fullUrl,
      String logString, {
      ApiProcessType apiProcessType, // api 请求的阶段类型
      ApiLogLevel apiLogLevel, // api 日志信息类型
    }) {
      String serviceValidProxyIp = NetworkManager.serviceValidProxyIp;
      Map extraApiLogInfo = {
        "hasProxy": serviceValidProxyIp != null,
      };
      if (apiLogLevel == ApiLogLevel.error) {
        LogUtil.apiError(fullUrl, logString, extraLogInfo: extraApiLogInfo);
      } else if (apiLogLevel == ApiLogLevel.warning) {
        LogUtil.apiWarning(fullUrl, logString, extraLogInfo: extraApiLogInfo);
      } else {
        if (apiProcessType == ApiProcessType.response) {
          LogUtil.apiSuccess(fullUrl, logString, extraLogInfo: extraApiLogInfo);
        } else {
          LogUtil.apiNormal(fullUrl, logString, extraLogInfo: extraApiLogInfo);
        }
      }
    };

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
    withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) async {
    if (withLoading == true) {
      LoadingUtil.show();
    }
    ApiManager.tryAddApi(api, isGet: true);

    return NetworkUtil.getRequestUrl(
      api,
      customParams: params,
      options: _dioOptions(cacheLevel),
    ).then((ResponseModel responseModel) {
      if (withLoading == true) {
        LoadingUtil.dismiss();
      }

      return _checkResponseModel(
        responseModel,
        showToastForNoNetwork: showToastForNoNetwork,
      );
    });
  }

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
      params: params,
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

  /// 通用的POST请求(即使设置缓存，只要从缓存中取到了数据，那想要执行的正常请求会被跳过，不会执行)
  static Future<ResponseModel> post(
    String api, {
    Map<String, dynamic> params,
    NetworkCacheLevel cacheLevel = NetworkCacheLevel.one,
    withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) async {
    if (withLoading == true) {
      LoadingUtil.show();
    }

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
    ).then((ResponseModel responseModel) {
      if (withLoading == true) {
        LoadingUtil.dismiss();
      }

      return _checkResponseModel(
        responseModel,
        showToastForNoNetwork: showToastForNoNetwork,
      );
    });
  }

  static ResponseModel _checkResponseModel(
    ResponseModel responseModel, {
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) {
    int errorCode = responseModel.statusCode;
    if (errorCode != 0) {
      String errorMessage = _responseErrorMessage(
        responseModel,
        showToastForNoNetwork: showToastForNoNetwork,
      );
    }

    return responseModel;
  }

  static String _responseErrorMessage(
    ResponseModel responseModel, {
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) {
    int errorCode = responseModel.statusCode;
    if (errorCode == 0) {
      return null;
    }

    String errorMessage;
    if (errorCode == -1) {
      errorMessage = "非常抱歉！服务器开小差了～";

      String proxyIp = ProxyPageDataManager()
          .selectedProxyModel
          ?.proxyIp; // 存在请求已开始，代理还没设置的情况
      if (proxyIp != null) {
        errorMessage = '$errorMessage:建议先关闭代理$proxyIp再检查';
      }
      if (showToastForNoNetwork == null || showToastForNoNetwork == false) {
        errorMessage = null;
      }
    } else if (errorCode == 500) {
      // statusCode 200, 但 errorCode 500 网络框架问题
      errorMessage = "非常抱歉！服务器开小差了～";
      if (showToastForNoNetwork == null || showToastForNoNetwork == false) {
        errorMessage = null;
      }
    } else if (errorCode == 401) {
      errorMessage = responseModel.message ?? "Token不能为空或Token过期，请重新登录";
      bool needRelogin = errorMessage == '暂未登录或token已经过期';
      if (needRelogin) {
        _needReloginHandle();
      }
    } else if (errorCode == -500) {
      errorMessage = responseModel.message ?? "非常抱歉！请求发生错误了～";
    } else {
      errorMessage = responseModel.message ?? "非常抱歉！业务发生错误了～";
    }

    if (errorMessage != null && errorMessage.isNotEmpty) {
      ToastUtil.showMessage(errorMessage);
    }

    return errorMessage;
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

  //*
  static bool Function() _loginStateGetBlock;
  static List<String>
      _ignoreRequestApiIfLogout; // 如果是未登录状态下，默认不请求(可省去外部加isLoginState()的判断)
  /// 是否不请求(如果是未登录状态下，默认不请求(可省去外部加isLoginState()的判断))
  static bool _shouldIgnoreRequest(String api) {
    if (_loginStateGetBlock != null &&
        _ignoreRequestApiIfLogout != null &&
        _ignoreRequestApiIfLogout.isNotEmpty) {
      bool isLogin = _loginStateGetBlock();
      if (isLogin == false) {
        String apiPath;
        int index = api.indexOf('/hapi/');

        if (index != -1) {
          apiPath = api.substring(index + '/hapi'.length);
        } else {
          apiPath = api;
        }
        if (_ignoreRequestApiIfLogout.contains(apiPath)) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }
  //*/
}
