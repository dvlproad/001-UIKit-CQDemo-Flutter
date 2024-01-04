/*
 * @Author: dvlproad
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 01:32:59
 * @Description: 可带缓存的网络请求方法
 */

import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';

import './app_network_manager.dart';
import '../mock/app_api_mock_manager.dart';

/// 网络缓存
enum AppNetworkCacheLevel {
  none, // 不需要缓存
  one, // 缓存7天
}

enum AppListCacheLevel {
  none, // 不需要缓存
  one, // 缓存7天
}

extension Cache on AppNetworkManager {
  /// 列表的请求(未设置会自动补上 pageNum pageSize 参数)
  void postListWithCallback(
    String api, {
    required Map<String, dynamic> customParams,
    int retryCount = 0,
    AppListCacheLevel listCacheLevel = AppListCacheLevel.one,
    withLoading = false,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    if (customParams['pageSize'] == null) {
      customParams.addAll({"pageSize": 20});
    }

    AppNetworkCacheLevel cacheLevel = AppNetworkCacheLevel.none;
    if (customParams['pageNum'] != null) {
      int pageNum = customParams['pageNum'];
      if (listCacheLevel == AppListCacheLevel.one && pageNum == 1) {
        cacheLevel = AppNetworkCacheLevel.one;
      }
    }

    requestWithCallback(
      api,
      requestMethod: RequestMethod.post,
      customParams: customParams,
      retryCount: retryCount,
      cacheLevel: cacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: completeCallBack,
    );
  }

  void requestWithCallback(
    String api, {
    RequestMethod requestMethod = RequestMethod.post,
    Map<String, dynamic>? customParams,
    bool? ifNoAuthorizationForceGiveUpRequest, // 没有 Authorization 的时候是否强制放弃请求
    int retryCount = 0,
    AppNetworkCacheLevel cacheLevel = AppNetworkCacheLevel.none,
    withLoading = false,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    AppMockManager.tryDealApi(
      api,
      isGet: requestMethod == RequestMethod.get ? true : false,
    );

    // ignore: todo
    /* ///TODO:判断不准确，临时注释起来
    if (cacheLevel != NetworkCacheLevel.one) {
      // 不是取缓存的请求的时候，才需要取网络
      if (NetworkStatusManager().connectionStatus == NetworkType.none) {
        ResponseModel newResponseModel = checkResponseModelFunction(
          ResponseModel.nonetworkResponseModel(),
          showToastForNoNetwork: showToastForNoNetwork,
        );

        if (completeCallBack != null) {
          completeCallBack(newResponseModel);
        }
        return;
      }
    }
    */

    if (withLoading == true) {
      LoadingUtil.show();
    }

    cache_requestWithCallback(
      api,
      requestMethod: requestMethod,
      customParams: customParams,
      ifNoAuthorizationForceGiveUpRequest: ifNoAuthorizationForceGiveUpRequest,
      retryCount: retryCount,
      cacheLevel: cacheLevel == AppNetworkCacheLevel.one
          ? NetworkCacheLevel.one
          : NetworkCacheLevel.none,
      toastIfMayNeed: showToastForNoNetwork,
      completeCallBack: (ResponseModel responseModel) {
        if (withLoading == true && responseModel.isCache != true) {
          LoadingUtil.dismiss();
        }
        completeCallBack(responseModel);
      },
    );

    // return post(api, customParams: customParams).then((value) {
    //   completeCallBack(value);
    // });
  }
}
