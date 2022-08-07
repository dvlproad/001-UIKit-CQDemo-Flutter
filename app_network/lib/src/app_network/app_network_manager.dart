/*
 * @Author: dvlproad
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 15:09:44
 * @Description: 正常请求管理中心+埋点请求管理中心
 */
import 'package:meta/meta.dart';
import 'dart:convert' show json;
import 'dart:convert' as convert;
import 'package:flutter_network_kit/flutter_network_kit.dart';
import '../app_response_model_util.dart';
import '../mock/mock_analy_util.dart';

class AppNetworkManager extends CacheNetworkClient {
  static const int CONNECT_TIMEOUT = 3000;
  static const int RECEIVE_TIMEOUT = 5000; // 会影响发视频这种大数据吗

  // 单例
  factory AppNetworkManager() => _getInstance();
  static AppNetworkManager get instance => _getInstance();
  static AppNetworkManager? _instance;
  static AppNetworkManager _getInstance() {
    if (_instance == null) {
      _instance = AppNetworkManager._internal();
    }
    return _instance!;
  }

  AppNetworkManager._internal() {
    //debugPrint('这个单例里的初始化方法只会执行一次');

    _init();
  }

  _init() {
    if (dio == null) {
      BaseOptions options = BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        contentType: "application/json",
      );
      dio = Dio(options);

      normal_setup(
        getSuccessResponseModelBlock:
            (String fullUrl, dynamic responseMap, bool? isFromCache) {
          return _getResponseModel(
            fullUrl: fullUrl,
            statusCode: 200,
            responseData: responseMap,
            isResponseFromCache: isFromCache,
          );
        },
        getFailureResponseModelBlock: (String fullUrl, int? statusCode,
            dynamic responseObject, bool? isCacheData) {
          String errorMessage = '后端接口出现异常';
          String message = '请求$fullUrl的时候，发生网络错误:$errorMessage';
          ResponseModel responseModel = ResponseModel(
            statusCode: statusCode ?? HttpStatusCode.Unknow,
            message: message,
            result: null,
            isCache: isCacheData,
          );

          return responseModel;
        },
        getDioErrorResponseModelBlock:
            (String url, ErrOptions errorModel, bool? isCacheData) {
          return ErrorResponseUtil.getErrorResponseModel(
            url,
            errorModel,
            isCacheData,
          );
        },
        checkResponseModelHandel: (responseModel, {showToastForNoNetwork}) {
          return CheckResponseModelUtil.checkResponseModel(
            responseModel,
            showToastForNoNetwork: showToastForNoNetwork ?? false,
            serviceProxyIp: serviceValidProxyIp,
          );
        },
      );
    }
  }

  ResponseModel _getResponseModel({
    required String fullUrl, // 用来判断是否是模拟的环境
    required int statusCode,
    dynamic responseData,
    bool? isResponseFromCache,
  }) {
    if (responseData == null) {
      return ResponseModel(
        statusCode: -1,
        message: "responseData == null",
        result: null,
        isCache: isResponseFromCache,
      );
    }

    if (responseData is String && (responseData as String).isEmpty) {
      // 后台把data按字符串返回的时候
      return ResponseModel(
        statusCode: statusCode,
        // message: response.m,
        result: {
          "code": -1001,
          "msg":
              "Error:后台response用字符串返回,值为${responseData},该字符串却无法转成标准的由code\msg\result组成的map结构(目前发现于503时候)",
        },
        isCache: isResponseFromCache,
      );
    }

    dynamic responseObject;
    if (responseData is String) {
      // 后台把data按字符串返回的时候
      responseObject = convert.jsonDecode(responseData);
    } else {
      //String dataString = responseData.toString();
      String dataJsonString = convert.jsonEncode(responseData);
      responseObject = convert.jsonDecode(dataJsonString);
    }

    // Uri uri = response.requestOptions.uri;
    // String url = uri.toString();

    Map<String, dynamic> responseMap;

    EnvironmentMockType envMockType = MockAnalyUtil.envMockType(fullUrl);
    if (envMockType == EnvironmentMockType.mockWish) {
      // 是模拟的环境，不是本项目
      responseMap = MockAnalyUtil.responseMapFromMock(responseObject, fullUrl);
    } else {
      responseMap = responseObject;
    }

    // int businessCode = responseObject["code"];
    // String message = responseObject["msg"];
    // dynamic result = responseObject['data'];
    // ResponseModel responseModel = ResponseModel(
    //   statusCode: businessCode,
    //   message: message,
    //   result: result,
    //   isCache: isResponseFromCache,
    // );

    var errorCode = responseMap['code'];
    var msg = responseMap['msg'];
    dynamic result = responseMap['data'];
    ResponseModel responseModel = ResponseModel(
      statusCode: errorCode,
      message: msg,
      result: result,
      isCache: isResponseFromCache,
    );

    return responseModel;
  }
}
