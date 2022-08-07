/*
 * @Author: dvlproad
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-20 00:24:38
 * @Description: 可带缓存的网络请求方法
 */
import 'dart:async' show Completer, StreamSubscription;
import 'dart:developer' as developer;

import 'dart:io' show NetworkInterface, InternetAddressType, InternetAddress;
import 'dart:ui' show window;

import 'package:meta/meta.dart'; // 为了使用 required
import 'package:flutter/services.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';

import './app_network_manager.dart';

/// 网络缓存
enum AppNetworkCacheLevel {
  none, // 不需要缓存
  one, // 缓存7天
}

extension Cache on AppNetworkManager {
  /*
  /// 具有更丰富功能的 post 接口(因为即使有缓存也只会返回一次，所以无法使用)
  Future<ResponseModel> postRich(
    String api, {
    Map<String, dynamic> customParams,
    int retryCount = 0,
    AppNetworkCacheLevel cacheLevel = AppNetworkCacheLevel.none,
    withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) async {
    if (withLoading == true) {
      LoadingUtil.show();
    }

    return cache_post(
      api,
      customParams: customParams,
      retryCount: retryCount,
      cacheLevel: cacheLevel == AppNetworkCacheLevel.one
          ? NetworkCacheLevel.one
          : NetworkCacheLevel.none,
    ).then(
      (ResponseModel responseModel) {
        if (withLoading == true && responseModel.isCache != true) {
          LoadingUtil.dismiss();
        }

        ResponseModel newResponseModel = checkResponseModelFunction(
          responseModel,
          showToastForNoNetwork: showToastForNoNetwork,
        );

        return newResponseModel;
      },
    );
  }
  */

  void postWithCallback(
    String api, {
    Map<String, dynamic>? customParams,
    int retryCount = 0,
    AppNetworkCacheLevel cacheLevel = AppNetworkCacheLevel.none,
    withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
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

    cache_postWithCallback(
      api,
      customParams: customParams,
      retryCount: retryCount,
      cacheLevel: cacheLevel == AppNetworkCacheLevel.one
          ? NetworkCacheLevel.one
          : NetworkCacheLevel.none,
      completeCallBack: (ResponseModel responseModel) {
        if (withLoading == true && responseModel.isCache != true) {
          LoadingUtil.dismiss();
        }

        ResponseModel newResponseModel = checkResponseModelFunction(
          responseModel,
          showToastForNoNetwork: showToastForNoNetwork,
        );

        if (completeCallBack != null) {
          completeCallBack(newResponseModel);
        }
      },
    );

    // return post(api, customParams: customParams).then((value) {
    //   completeCallBack(value);
    // });
  }
}
