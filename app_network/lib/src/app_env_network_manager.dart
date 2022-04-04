import 'package:meta/meta.dart'; // 为了使用 @required
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';

import './app_response_model_util.dart';
import './app_api_simulate_util.dart';

class AppNetworkKit {
  static void start({
    @required String baseUrl,
    @required Map<String, dynamic> commonParams,
    @required String token,
    @required void Function() needReloginHandle, // 401等需要重新登录时候，执行的操作

    bool allowMock, // 是否允许 mock api
    String mockApiHost, // 允许 mock api 的情况下，mock 到哪个地址
  }) {
    NetworkKit.start(
      baseUrl: baseUrl,
      commonParams: commonParams,
      token: token,
      checkResponseModelHandel: (responseModel, {showToastForNoNetwork}) {
        CheckResponseModelUtil.needReloginHandle = needReloginHandle;
        return CheckResponseModelUtil.checkResponseModel(
          responseModel,
          showToastForNoNetwork: showToastForNoNetwork,
        );
      },
      allowMock: allowMock,
      mockApiHost: mockApiHost,
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
    if (ApiManager.instance.allowMock == true) {
      ApiManager.tryAddApi(api, isGet: true);
      bool shouldMock = ApiManager.shouldAfterMockApi(api);
      if (shouldMock) {
        api = (api as String).toSimulateApi();
      }
    }

    return NetworkKit.get(
      api,
      customParams: params,
      cacheLevel: cacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    );
  }

  /// 通用的POST请求(即使设置缓存，只要从缓存中取到了数据，那想要执行的正常请求会被跳过，不会执行)
  static Future<ResponseModel> post(
    String api, {
    Map<String, dynamic> params,
    NetworkCacheLevel cacheLevel = NetworkCacheLevel.none,
    withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) async {
    if (ApiManager.instance.allowMock == true) {
      ApiManager.tryAddApi(api, isGet: false);
      bool shouldMock = ApiManager.shouldAfterMockApi(api);
      if (shouldMock) {
        api = (api as String).toSimulateApi();
      }
    }

    return NetworkKit.post(
      api,
      customParams: params,
      cacheLevel: cacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    );
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
