/*
 * @Author: dvlproad
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-11 15:20:47
 * @Description: 正常请求管理中心+埋点请求管理中心
 */
import 'package:meta/meta.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';
import '../mock/app_api_mock_manager.dart';

class MockNetworkManager extends CacheNetworkClient {
  Future<ResponseModel> get(
    String api, {
    Map<String, dynamic>? customParams,
    Options? options,
    int retryCount = 0, // 轮询次数,最后一次不管成功与否都要返回
    Duration? retryDuration, // 轮询间隔
    bool Function(ResponseModel responseModel)?
        retryStopConditionConfigBlock, // 是否请求停止的判断条件(为空时候,默认请求成功即停止)
    bool withLoading = false,
    bool? showToastForNoNetwork,
  }) async {
    return mock_requestUrl(
      api,
      requestMethod: RequestMethod.get,
      customParams: customParams,
      options: options,
      retryCount: retryCount,
      retryDuration: retryDuration,
      retryStopConditionConfigBlock: retryStopConditionConfigBlock,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    );
  }

  Future<ResponseModel> post(
    String api, {
    Map<String, dynamic>? customParams,
    Options? options,
    int retryCount = 0, // 轮询次数,最后一次不管成功与否都要返回
    Duration? retryDuration, // 轮询间隔
    bool Function(ResponseModel responseModel)?
        retryStopConditionConfigBlock, // 是否请求停止的判断条件(为空时候,默认请求成功即停止)
    bool withLoading = false,
    bool? showToastForNoNetwork,
  }) async {
    return mock_requestUrl(
      api,
      requestMethod: RequestMethod.post,
      customParams: customParams,
      options: options,
      retryCount: retryCount,
      retryDuration: retryDuration,
      retryStopConditionConfigBlock: retryStopConditionConfigBlock,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    );
  }

  /// 通用的GET/POST请求(即使设置缓存，只要从缓存中取到了数据，那想要执行的正常请求会被跳过，不会执行)
  Future<ResponseModel> mock_requestUrl(
    String api, {
    RequestMethod requestMethod = RequestMethod.post,
    Map<String, dynamic>? customParams,
    Options? options,
    int retryCount = 0, // 轮询次数,最后一次不管成功与否都要返回
    Duration? retryDuration, // 轮询间隔
    bool Function(ResponseModel responseModel)?
        retryStopConditionConfigBlock, // 是否请求停止的判断条件(为空时候,默认请求成功即停止)
    bool withLoading = false,
    bool? showToastForNoNetwork,
  }) async {
    AppMockManager.tryDealApi(
      api,
      isGet: requestMethod == RequestMethod.post ? true : false,
    );
    return requestWithRetry(
      api,
      requestMethod: requestMethod,
      customParams: customParams,
      options: options,
      retryCount: retryCount,
      retryDuration: retryDuration ?? Duration(milliseconds: 1000),
      retryStopConditionConfigBlock: retryStopConditionConfigBlock,
      withLoading: withLoading,
      toastIfMayNeed: showToastForNoNetwork,
    );
  }
}
