/*
 * @Author: dvlproad
 * @Date: 2022-08-11 10:38:16
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-11 15:21:21
 * @Description: 网络库缓存接口支持形如Future样式的写法，方便极简代码替换接口
 */
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

class AppNetworkCacheUtil {
  String api;
  Map<String, dynamic>? params;
  bool? ifNoAuthorizationForceGiveUpRequest; // 没有 Authorization 的时候是否强制放弃请求
  int retryCount;
  bool withLoading;
  AppNetworkCacheLevel cacheLevel;
  bool? showToastForNoNetwork;

  RequestMethod requestMethod = RequestMethod.post;

  AppNetworkCacheUtil.get(
    this.api, {
    this.params,
    this.ifNoAuthorizationForceGiveUpRequest,
    this.retryCount = 0,
    this.withLoading = false,
    this.cacheLevel = AppNetworkCacheLevel.one,
    this.showToastForNoNetwork,
  }) {
    requestMethod = RequestMethod.get;
  }

  AppNetworkCacheUtil.post(
    this.api, {
    this.params,
    this.ifNoAuthorizationForceGiveUpRequest,
    this.retryCount = 0,
    this.withLoading = false,
    this.cacheLevel = AppNetworkCacheLevel.one,
    this.showToastForNoNetwork,
  }) {
    requestMethod = RequestMethod.post;
  }

  void then(
    void Function(ResponseModel responseModel) completeCallBack,
  ) async {
    AppNetworkManager().requestWithCallback(
      api,
      requestMethod: requestMethod,
      customParams: params,
      ifNoAuthorizationForceGiveUpRequest: ifNoAuthorizationForceGiveUpRequest,
      retryCount: retryCount,
      cacheLevel: cacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: completeCallBack,
    );
  }
}

/// 列表的请求(未设置会自动补上 pageNum pageSize 参数)
class AppNetworkListCacheUtil {
  String api;
  Map<String, dynamic> params;
  int retryCount;
  bool withLoading;
  AppListCacheLevel listCacheLevel = AppListCacheLevel.one;
  bool? showToastForNoNetwork;

  RequestMethod requestMethod = RequestMethod.post;

  AppNetworkListCacheUtil.post(
    this.api, {
    required this.params,
    this.retryCount = 0,
    this.withLoading = false,
    this.listCacheLevel = AppListCacheLevel.one,
    this.showToastForNoNetwork,
  }) {
    requestMethod = RequestMethod.post;
  }

  void then(
    void Function(ResponseModel responseModel) completeCallBack,
  ) async {
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
}
