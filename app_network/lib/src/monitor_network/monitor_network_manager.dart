// ignore_for_file: constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 01:31:35
 * @Description: 正常请求管理中心+埋点请求管理中心
 */
import 'package:flutter_network_kit/flutter_network_kit.dart';

import '../base/mock_network_manager.dart';

class MonitorNetworkManager extends MockNetworkManager {
  static const int CONNECT_TIMEOUT = 3000;
  static const int RECEIVE_TIMEOUT = 10000;

  // 单例
  factory MonitorNetworkManager() => _getInstance();
  static MonitorNetworkManager get instance => _getInstance();
  static MonitorNetworkManager? _instance;
  static MonitorNetworkManager _getInstance() {
    _instance ??= MonitorNetworkManager._internal();
    return _instance!;
  }

  MonitorNetworkManager._internal() {
    //debugPrint('这个单例里的初始化方法只会执行一次');

    _init();
  }

  _init() {
    if (dio == null) {
      BaseOptions options = BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        contentType: "application/x-www-form-urlencoded",
      );
      dio = Dio(options);

      normal_setup(
        getSuccessResponseModelBlock: (String fullUrl, int statusCode,
            dynamic responseObject, bool? isFromCache) {
          if (responseObject is String) {
            return ResponseModel(
              statusCode: statusCode,
              message: "失败",
              result: responseObject,
            );
          }
          Map<String, dynamic> responseMap = responseObject;
          bool isSuccess = responseMap["Response"] != null &&
              responseMap["Response"]["Error"] == null;

          var errorCode = isSuccess ? 0 : -1;
          var msg = isSuccess ? "成功" : "失败";
          dynamic result = responseMap["Response"];
          ResponseModel responseModel = ResponseModel(
            statusCode: errorCode,
            message: msg,
            result: result,
            isCache: isFromCache,
          );
          return responseModel;
        },
        getFailureResponseModelBlock: (String fullUrl, int statusCode,
            dynamic responseObject, bool? isCacheData) {
          String errorMessage = '临时写的，暂时都不会调用到此转换方法';
          ResponseModel responseModel = ResponseModel(
            statusCode: statusCode,
            message: errorMessage,
            result: null,
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
        checkResponseModelHandel: (responseModel, {bool? toastIfMayNeed}) {
          // CheckResponseModelUtil.needReloginHandle = needReloginHandle;
          // return CheckResponseModelUtil.checkResponseModel(
          //   responseModel,
          //   showToastForNoNetwork: showToastForNoNetwork,
          // );
          return responseModel;
        },
      );
    }
  }
}
