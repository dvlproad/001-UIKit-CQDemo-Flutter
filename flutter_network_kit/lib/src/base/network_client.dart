import 'package:flutter_network_base/flutter_network_base.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';
import 'package:dio/dio.dart';
// log
import '../log/api_log_util.dart';
// networkStatus
// import '../networkStatus/network_status_manager.dart';

class NetworkClient extends BaseNetworkClient {
  List<String>? _headerAuthorizationWhiteList;

  /// 初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  // ignore: non_constant_identifier_names
  void normal_start({
    required String baseUrl,
    String?
        contentType, // "application/json""application/x-www-form-urlencoded"
    List<Interceptor>? extraInterceptors,
    required Map<String, dynamic> headerCommonFixParams, // header 中公共但不变的参数
    Map<String, dynamic> Function()?
        headerCommonChangeParamsGetBlock, // header 中公共但会变的参数
    String? headerAuthorization,
    List<String>?
        headerAuthorizationWhiteList, // 请求时候，检查到当前headerAuthorization为空,可继续请求的白名单
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
    headers.addAll(headerCommonFixParams);
    if (headerCommonChangeParamsGetBlock != null) {
      headers.addAll(headerCommonChangeParamsGetBlock());
    }
    if (headerAuthorization != null && headerAuthorization.isNotEmpty) {
      headers.addAll({'Authorization': headerAuthorization});
    }
    _headerAuthorizationWhiteList = headerAuthorizationWhiteList;

    super.base_start(
      baseUrl: baseUrl,
      headers: headers,
      connectTimeout: 15000,
      receiveTimeout: 15000,
      contentType: contentType,
      interceptors: extraInterceptors,
      bodyCommonFixParams: bodyCommonFixParams,
      bodyCommonChangeParamsGetBlock: bodyCommonChangeParamsGetBlock,
      logApiInfoAction: (NetOptions apiInfo, ApiProcessType apiProcessType) {
        ApiEnvInfo apiEnvInfo = ApiEnvInfo(
          serviceValidProxyIp: serviceValidProxyIp,
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
  // ignore: non_constant_identifier_names
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
      bool? toastIfMayNeed,
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

  /// 检查是否应该放弃请求(如果缺少token,又没在白名单中,将直接return)
  Future<bool> shouldGiveUpRequest(String api) async {
    await makeSureCompleteStart();

    String? currentHeaderAuthorization = getAuthorization();
    if (currentHeaderAuthorization == null) {
      if (_headerAuthorizationWhiteList != null) {
        String noslashApiPath = api; // 没带斜杠的 api host
        if (noslashApiPath.startsWith('/')) {
          noslashApiPath = noslashApiPath.substring(1, noslashApiPath.length);
        }

        // if (_headerAuthorizationWhiteList!.contains(api) == false) {
        int foundIndex = _headerAuthorizationWhiteList!
            .indexWhere((element) => element.contains(noslashApiPath));
        if (foundIndex == -1) {
          // -1 未找到,即不在白名单中
          return true;
        }
      }
    }
    return false;
  }

  /// 检查是否存在token
  Future<bool> existAuthorization() async {
    await makeSureCompleteStart();

    String? currentHeaderAuthorization = getAuthorization();
    if (currentHeaderAuthorization == null) {
      return false;
    }
    return true;
  }

  Future<ResponseModel> requestWithRetry(
    String api, {
    RequestMethod requestMethod = RequestMethod.post,
    Map<String, dynamic>? customParams,
    int retryCount = 0, // 轮询次数,最后一次不管成功与否都要返回
    Duration retryDuration = const Duration(milliseconds: 1000), // 轮询间隔
    bool Function(ResponseModel responseModel)?
        retryStopConditionConfigBlock, // 是否请求停止的判断条件(为空时候,默认请求成功即停止)
    Options? options,
    bool withLoading = false,
    bool?
        toastIfMayNeed, // 应该弹出toast的地方是否要弹出toast(如网络code为500的时候),必须可为空是,不为空的时候无法实现修改

    ResponseModel? beforeResponseModel, // 上一次请求时候得到的值(重试\缓存)
  }) async {
    return requestUrl(
      api,
      requestMethod: requestMethod,
      customParams: customParams,
      options: options,
      withLoading: withLoading,
      toastIfMayNeed: toastIfMayNeed,
    ).then((ResponseModel responseModel) {
      if (beforeResponseModel != null) {
        if (responseModel.isEqualToResponse(beforeResponseModel)) {
          responseModel.isSameToBefore = true;
        }
      }

      bool allowRetryIfFailure = retryCount > 1;
      if (allowRetryIfFailure != true) {
        // 重试次数用完的话，最后一次不管成功与否都要返回
        return responseModel;
      }

      // 如果实际的请求成功，则直接返回
      bool noneedRetry = responseModel.isSuccess;
      if (retryStopConditionConfigBlock != null) {
        noneedRetry = retryStopConditionConfigBlock(responseModel);
      }
      if (noneedRetry) {
        return responseModel;
      } else {
        // 如果实际的请求失败，则尝试再进行请求
        retryCount--;

        return Future.delayed(retryDuration).then((value) {
          return requestWithRetry(
            api,
            requestMethod: requestMethod,
            customParams: customParams,
            retryCount: retryCount,
            retryDuration: retryDuration,
            retryStopConditionConfigBlock: retryStopConditionConfigBlock,
            options: options,
            withLoading: withLoading,
            toastIfMayNeed: toastIfMayNeed,
            beforeResponseModel: responseModel,
          );
        });
      }
    });
  }

  /// 通用的GET/POST请求(即使设置缓存，只要从缓存中取到了数据，那想要执行的正常请求会被跳过，不会执行)
  Future<ResponseModel> requestUrl(
    String api, {
    RequestMethod requestMethod = RequestMethod.post,
    Map<String, dynamic>? customParams,
    Options? options,
    bool withLoading = false,
    bool?
        toastIfMayNeed, // 应该弹出toast的地方是否要弹出toast(如网络code为500的时候),必须可为空是,不为空的时候无法实现修改
  }) async {
    /*
    NetworkType realConnectionStatus = await NetworkStatusManager()
        .realConnectionStatus; // 修复无网络情况下,启动应用，导致无网络也走网络请求
    // ignore: todo
    ///TODO:暂时注释掉。原因:后台长时间挂起后，网络状态获取不准
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

    return base_requestUrl(
      api,
      requestMethod: requestMethod,
      customParams: customParams,
      options: options,
    ).then((ResponseModel responseModel) {
      if (withLoading == true) {
        LoadingUtil.dismiss();
      }

      return checkResponseModelFunction(
        responseModel,
        toastIfMayNeed: toastIfMayNeed,
      );
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
