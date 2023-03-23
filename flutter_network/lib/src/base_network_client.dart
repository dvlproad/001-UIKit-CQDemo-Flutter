import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import './interceptor/interceptor_request.dart';
import './interceptor/interceptor_response.dart';
import './interceptor/interceptor_error.dart';
import './interceptor_log/dio_interceptor_log.dart';
import './url/appendPathExtension.dart';
import './bean/net_options.dart';
import './mock/local_mock_util.dart';

import './network_change_util.dart';

import './network_util.dart';
import './network_bean.dart';

class BaseNetworkClient {
  // bool get hasStart => _hasStart;

  bool _hasStart = false;
  final Completer _initCompleter = Completer<String>();

  /// 确保网络库start 启动成功过(使用此方法，省得开放_initCompleter)
  Future<void> makeSureCompleteStart() async {
    await _initCompleter.future;
    return;
  }

  String? _baseUrl;
  String? get baseUrl => _baseUrl;

  Uri getUri(String api) {
    String scheme = '';
    String host = '';
    String path = '';
    if (baseUrl != null) {
      // debugPrint("uri计算来源....baseUrl=$baseUrl, api=$api");
      if (baseUrl!.startsWith(RegExp(r'https?:'))) {
        int index = baseUrl!.indexOf("://");
        scheme = baseUrl!.substring(0, index);
        String stringAfterRemovePrefix =
            baseUrl!.substring(index + "://".length);
        host = stringAfterRemovePrefix.split('/').first;

        String pathPrefix = stringAfterRemovePrefix.substring(host.length);

        // 修复之前出现错计算不正确，多了个/导致删除缓存的时候匹配不上，而没删掉
        path = pathPrefix.appendPathString(api);
      }
    }

    Uri uri = Uri(
      scheme: scheme,
      host: host,
      path: path,
    );
    // debugPrint("uri计算结果=$uri");
    return uri;
  }

  late ResponseModel Function(
    ResponseModel responseModel, {
    bool?
        toastIfMayNeed, // 应该弹出toast的地方是否要弹出toast(如网络code为500的时候),必须可为空是,不为空的时候无法实现修改
  }) checkResponseModelFunction;

  /// body 中公共但不变的参数
  Map<String, dynamic> _bodyCommonFixParams = {};

  /// body 中公共但可变的参数
  Map<String, dynamic> Function()? _bodyCommonChangeParamsGetBlock;

  Dio? dio;

  CJNetworkClientGetSuccessResponseModelBlock
      get getSuccessResponseModelFunction => _getSuccessResponseModelBlock;
  late CJNetworkClientGetSuccessResponseModelBlock
      _getSuccessResponseModelBlock;
  late CJNetworkClientGetFailureResponseModelBlock
      _getFailureResponseModelBlock;
  late CJNetworkClientGetDioErrorResponseModelBlock
      _getDioErrorResponseModelBlock;

  /*
 *  设置服务器返回值的各种处理方法(一定要执行)
 *
 *  @param getSuccessResponseModelBlock 将"网络请求成功返回的数据responseObject"转换为"模型"的方法
 *  @param checkIsCommonFailureBlock    在"网络请求成功并转换为模型"后判断其是否是"异地登录"等共同错误并在此对共同错误做处理(可为nil)
 *  @param getFailureResponseModelBlock 将"网络请求失败返回的数据error"转换为"模型"的方法
 *  @param getErrorResponseModelBlock   将"网络请求失败返回的数据error"转换为"模型"的方法
 */
  // ignore: non_constant_identifier_names
  void base_setup({
    required CJNetworkClientGetSuccessResponseModelBlock
        getSuccessResponseModelBlock,
    bool Function(ResponseModel responseModel)? checkIsCommonFailureBlock,
    required CJNetworkClientGetFailureResponseModelBlock
        getFailureResponseModelBlock,
    required CJNetworkClientGetDioErrorResponseModelBlock
        getDioErrorResponseModelBlock,
    required ResponseModel Function(
      ResponseModel responseModel, {
      bool?
          toastIfMayNeed, // 应该弹出toast的地方是否要弹出toast(如网络code为500的时候),必须可为空是,不为空的时候无法实现修改
    })
        checkResponseModelHandel,
  }) {
    _getSuccessResponseModelBlock = getSuccessResponseModelBlock;
    _getFailureResponseModelBlock = getFailureResponseModelBlock;
    _getDioErrorResponseModelBlock = getDioErrorResponseModelBlock;
    checkResponseModelFunction = checkResponseModelHandel;
  }

  // ignore: non_constant_identifier_names
  /// 初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  /// [connectTimeout] 连接超时赶时间
  /// [receiveTimeout] 接收超时赶时间
  /// [interceptors] 基础拦截器
  void base_start({
    required String baseUrl,
    int? connectTimeout,
    int? receiveTimeout,
    String?
        contentType, // "application/json""application/x-www-form-urlencoded"
    Map<String, dynamic>? headers,
    required Map<String, dynamic> bodyCommonFixParams,
    Map<String, dynamic> Function()? bodyCommonChangeParamsGetBlock,
    List<Interceptor>? interceptors,
    bool? nouseDefalutInterceptors = false,
    required void Function(NetOptions apiInfo, ApiProcessType apiProcessType)
        logApiInfoAction, // 打印请求各阶段出现的不同等级的日志信息
    String Function(String apiPath)?
        localApiDirBlock, // 本地网络所在的目录,需要本地模拟时候才需要设置
    void Function(RequestOptions options)? dealRequestOptionsAction,
  }) {
    // DioLogUtil.initDioLogUtil(logApiInfoAction: logApiInfoAction);

    LocalMockUtil.localApiDirBlock = localApiDirBlock;

    _bodyCommonFixParams = bodyCommonFixParams;
    _bodyCommonChangeParamsGetBlock = bodyCommonChangeParamsGetBlock;

    if (_hasStart == true) {
      //print('本方法只能执行一遍，前面已执行过,防止如initState调用多遍的时候,重复添加interceptors');
      return;
    }

    print('NetworkClient:初始化开始执行中...');
    dio!.options = dio!.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      contentType: contentType,
      headers: headers,
    );
    _baseUrl = baseUrl;

    // 添加 interceptors
    List<Interceptor> lastInterceptors = [];
    if (nouseDefalutInterceptors == null || nouseDefalutInterceptors == false) {
      List<Interceptor> defaultInterceptors = [
        RequestInterceptor(),
        ResponseInterceptor(),
        ErrorInterceptor(),
        DioLogInterceptor(
            getSuccessResponseModelBlock: _getSuccessResponseModelBlock,
            logApiInfoAction:
                (NetOptions apiInfo, ApiProcessType apiProcessType) {
              if (logApiInfoAction != null) {
                logApiInfoAction(apiInfo, apiProcessType);
              }
            }),
      ];
      lastInterceptors.addAll(defaultInterceptors);
    }
    RequestInterceptor.dealRequestOptionsAction = dealRequestOptionsAction;

    if (interceptors != null && interceptors.isNotEmpty) {
      lastInterceptors.addAll(interceptors);
      // lastInterceptors..insertAll(2, interceptors);// 将外部 interceptors 插入到 log 前面
    }

    dio!.interceptors.addAll(lastInterceptors);

    _hasStart = true;
    _initCompleter.complete('NetworkClient:初始化(设置baseUrl等)完成，此时才可以进行实际请求');
    debugPrint('NetworkClient:初始化(设置baseUrl等)完成，此时才可以进行实际请求');
  }

  // ignore: non_constant_identifier_names
  void base_postUrl<T>(
    String url, {
    Map<String, dynamic>? customParams,
    CancelToken? cancelToken,
    Options? options,
    required void Function(dynamic resultMap) onSuccess,
    required void Function(String? failureMessage) onFailure,
  }) {
    base_requestUrl(
      url,
      requestMethod: RequestMethod.post,
      customParams: customParams,
      options: options,
      cancelToken: cancelToken,
    ).then((ResponseModel responseModel) {
      int errorCode = responseModel.statusCode;
      if (errorCode == 0) {
        if (onSuccess != null) {
          onSuccess(responseModel.result);
        }
      } else {
        if (onFailure != null) {
          onFailure(responseModel.message);
        }
      }
    });
  }

  // 网络请求的最底层方法
  // ignore: non_constant_identifier_names
  Future<ResponseModel> base_requestUrl(
    String url, {
    RequestMethod requestMethod = RequestMethod.post,
    Map<String, dynamic>? customParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _initCompleter.future;
    // while (_hasStart == false) {
    //   print('NetworkClient:初始化未完成，等待中...');
    //   // sleep(Duration(milliseconds: 3500));
    //   await Future.delayed(Duration(milliseconds: 500));
    // }
    //print('NetworkClient:初始化已完成，开始进行请求');

    Map<String, dynamic> allParams = Map.from(_bodyCommonFixParams);
    if (_bodyCommonChangeParamsGetBlock != null) {
      allParams.addAll(_bodyCommonChangeParamsGetBlock!());
    }
    if (customParams != null && customParams.isNotEmpty) {
      allParams.addAll(customParams);
    }

    return NetworkUtil.requestUrl(
      dio!,
      url,
      requestMethod: requestMethod,
      customParams: allParams,
      options: options,
      cancelToken: cancelToken,
      getSuccessResponseModelBlock: _getSuccessResponseModelBlock,
      getFailureResponseModelBlock: _getFailureResponseModelBlock,
      getDioErrorResponseModelBlock: _getDioErrorResponseModelBlock,
    );
  }

  // 以下代码为 NetworkClient 的 ChangeUtil
  /************************* token 设置 *************************/
  /// 获取当前dio的token值(用于该值为空时候，能否进行请求的token白名单)
  String? getAuthorization() {
    if (dio == null) {
      return null;
    }
    Map<String, dynamic> requestHeaders = dio!.options.headers;
    String tokenKey = 'Authorization';
    String? token = requestHeaders[tokenKey];
    return token;
  }

  /// 添加/修改/删除token(登录成功/退出成功后调用)
  void updateToken(String? token) {
    String tokenKey = 'Authorization';
    if (token == null || token.isEmpty) {
      DioChangeUtil.removeHeadersKey(dio!, tokenKey);
    } else {
      Map<String, dynamic> requestHeaders = {tokenKey: token};
      DioChangeUtil.changeHeaders(dio!, headers: requestHeaders);
    }
  }

  /************************* baseUrl 设置 *************************/
  /// 修改 baseUrl
  void changeOptions({
    required String baseUrl,
  }) {
    _baseUrl = baseUrl;
    DioChangeUtil.changeOptions(dio!, baseUrl: baseUrl);
  }

  /// *********************** proxy 设置 ************************
  String? serviceValidProxyIp; // 网络库当前服务的有效的代理ip地址(无代理或其地址无效时候，该值会是null)
  // 修改代理 proxy(返回代理设置成功与否，当传入的不是ip地址格式不正确等则无法成功设置代理)
  bool changeProxy(String? proxyIp) {
    bool changeSuccess = DioChangeUtil.changeProxy(dio!, proxyIp: proxyIp);
    if (changeSuccess) {
      serviceValidProxyIp = proxyIp;
    }

    return changeSuccess;
  }
}
