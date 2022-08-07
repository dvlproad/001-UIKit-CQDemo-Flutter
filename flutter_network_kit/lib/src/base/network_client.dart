import 'dart:async' show Completer, StreamSubscription;
import 'dart:developer' as developer;

import 'dart:io' show NetworkInterface, InternetAddressType, InternetAddress;
import 'dart:ui' show window;

import 'package:meta/meta.dart'; // 为了使用 required
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';
import 'package:dio/dio.dart';
// log
import '../log/api_log_util.dart';
// networkStatus
import '../networkStatus/network_status_manager.dart';

class NetworkClient extends BaseNetworkClient {
  /// 初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  void normal_start({
    required String baseUrl,
    String?
        contentType, // "application/json""application/x-www-form-urlencoded"
    List<Interceptor>? extraInterceptors,
    required Map<String, dynamic> headerCommonFixParams, // header 中公共但不变的参数
    Map<String, dynamic> Function()?
        headerCommonChangeParamsGetBlock, // header 中公共但会变的参数
    String? headerAuthorization,
    required Map<String, dynamic> bodyCommonFixParams, // body 中公共但不变的参数
    Map<String, dynamic> Function()?
        bodyCommonChangeParamsGetBlock, // body 中公共但会变的参数
    bool allowMock = false, // 是否允许 mock api
    String? mockApiHost, // 允许 mock api 的情况下，mock 到哪个地址
    String Function(String apiPath)?
        localApiDirBlock, // 本地网络所在的目录,需要本地模拟时候才需要设置
    void Function(RequestOptions options)? dealRequestOptionsAction,
  }) {
    Map<String, dynamic> headers = {};
    if (headerCommonFixParams != null) {
      headers.addAll(headerCommonFixParams);
    }
    if (headerCommonChangeParamsGetBlock != null) {
      headers.addAll(headerCommonChangeParamsGetBlock());
    }
    if (headerAuthorization != null && headerAuthorization.isNotEmpty) {
      headers.addAll({'Authorization': headerAuthorization});
    }

    super.base_start(
      baseUrl: baseUrl,
      headers: headers,
      connectTimeout: 15000,
      contentType: contentType,
      interceptors: extraInterceptors,
      bodyCommonFixParams: bodyCommonFixParams,
      bodyCommonChangeParamsGetBlock: bodyCommonChangeParamsGetBlock,
      logApiInfoAction: (NetOptions apiInfo, ApiProcessType apiProcessType) {
        ApiEnvInfo apiEnvInfo = ApiEnvInfo(
          serviceValidProxyIp: this.serviceValidProxyIp,
        );
        LogApiUtil.logApiInfo(
          apiInfo,
          apiProcessType,
          apiEnvInfo: apiEnvInfo,
        );
      },
      dealRequestOptionsAction: dealRequestOptionsAction,
      localApiDirBlock: localApiDirBlock,
    );
  }

  /*
 *  设置服务器返回值的各种处理方法(一定要执行)
 *
 *  @param getSuccessResponseModelBlock 将"网络请求成功返回的数据responseObject"转换为"模型"的方法
 *  @param checkIsCommonFailureBlock    在"网络请求成功并转换为模型"后判断其是否是"异地登录"等共同错误并在此对共同错误做处理(可为nil)
 *  @param getFailureResponseModelBlock 将"网络请求失败返回的数据error"转换为"模型"的方法
 *  @param getErrorResponseModelBlock   将"网络请求失败返回的数据error"转换为"模型"的方法
 */
  void normal_setup({
    required CJNetworkClientGetSuccessResponseModelBlock
        getSuccessResponseModelBlock,
    bool Function(ResponseModel responseModel)? checkIsCommonFailureBlock,
    required CJNetworkClientGetFailureResponseModelBlock
        getFailureResponseModelBlock,
    required CJNetworkClientGetDioErrorResponseModelBlock
        getDioErrorResponseModelBlock,
    required ResponseModel Function(
      ResponseModel responseModel, {
      bool? showToastForNoNetwork, // 网络开小差的时候，是否显示toast(默认不toast)
    })
        checkResponseModelHandel,
  }) {
    base_setup(
      getSuccessResponseModelBlock: getSuccessResponseModelBlock,
      getFailureResponseModelBlock: getFailureResponseModelBlock,
      getDioErrorResponseModelBlock: getDioErrorResponseModelBlock,
      checkResponseModelHandel: checkResponseModelHandel,
    );
  }

  /// 通用的GET请求
  Future<ResponseModel> get(
    String api, {
    Map<String, dynamic>? customParams,
    Options? options,
    bool withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) async {
    NetworkType realConnectionStatus = await NetworkStatusManager()
        .realConnectionStatus; // 修复无网络情况下,启动应用，导致无网络也走网络请求
    /* ///TODO:暂时注释掉。原因:后台长时间挂起后，网络状态获取不准
    if (realConnectionStatus == NetworkType.none) {
      return checkResponseModelFunction(
        /// TODO:改为空安全，这里就不用做判断了
        ResponseModel.nonetworkResponseModel(),
        showToastForNoNetwork: showToastForNoNetwork,
      );
    }
    */

    if (withLoading == true) {
      LoadingUtil.show();
    }

    return base_getRequestUrl(
      api,
      customParams: customParams,
      options: options,
    ).then((ResponseModel responseModel) {
      if (withLoading == true) {
        LoadingUtil.dismiss();
      }

      return checkResponseModelFunction(
        responseModel,
        showToastForNoNetwork: showToastForNoNetwork,
      );
    });
  }

  /// 通用的POST请求(即使设置缓存，只要从缓存中取到了数据，那想要执行的正常请求会被跳过，不会执行)
  Future<ResponseModel> post(
    String api, {
    Map<String, dynamic>? customParams,
    Options? options,
    CancelToken? cancelToken,
    bool withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) async {
    NetworkType realConnectionStatus = await NetworkStatusManager()
        .realConnectionStatus; // 修复无网络情况下,启动应用，导致无网络也走网络请求
    /* ///TODO:暂时注释掉。原因:后台长时间挂起后，网络状态获取不准
    if (realConnectionStatus == NetworkType.none) {
      return checkResponseModelFunction(
        ResponseModel.nonetworkResponseModel(),
        showToastForNoNetwork: showToastForNoNetwork,
      );
    }
    */

    if (withLoading == true) {
      LoadingUtil.show();
    }

    return base_postRequestUrl(
      api,
      customParams: customParams,
      options: options,
      cancelToken: cancelToken,
    ).then((ResponseModel responseModel) {
      if (withLoading == true) {
        LoadingUtil.dismiss();
      }

      return checkResponseModelFunction(
        responseModel,
        showToastForNoNetwork: showToastForNoNetwork,
      );
    });
  }

  void postWithRetryCallback(
    String api, {
    Map<String, dynamic>? customParams,
    int retryCount = 0,
    Options? options,
    bool withLoading = false,
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    post(
      api,
      customParams: customParams,
      options: options,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    ).then((ResponseModel responseModel) {
      if (completeCallBack == null) {
        throw Exception('温馨提示:本次请求，你没有实现回调方法$api');
      }

      // 如果实际的请求成功，则直接返回
      if (responseModel.isSuccess) {
        completeCallBack(responseModel);
        return;
      }

      // 如果实际的请求失败，则尝试再进行请求
      if (retryCount != null && retryCount > 1) {
        retryCount--;

        postWithRetryCallback(
          api,
          customParams: customParams,
          retryCount: retryCount,
          options: options,
          withLoading: withLoading,
          showToastForNoNetwork: showToastForNoNetwork,
          completeCallBack: completeCallBack,
        );
      } else {
        // 重试次数用完的话，最后一次不管成功与否都要返回
        completeCallBack(responseModel);
      }
    });
  }

  Future retryWhenError(DioError err) async {
    if (err.response == null) {
      return Future.value(false);
    }

    RequestOptions requestOptions =
        err.response!.requestOptions; //千万不要调用 err.request
    try {
      var response = await dio!.request(
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
