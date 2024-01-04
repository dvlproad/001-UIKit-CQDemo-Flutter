// ignore_for_file: constant_identifier_names

/*
 * @Author: allen
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-04 16:19:17
 * @Description: 同盾请求管理中心 https://cn-doc.trustdecision.com/reference/docs-navigation-cn
 */
import 'package:flutter_network_kit/flutter_network_kit.dart';
import '../base/mock_network_manager.dart';

class TDNetworkManager extends MockNetworkManager {
  static const int CONNECT_TIMEOUT = 3000;
  static const int RECEIVE_TIMEOUT = 10000;

  // 单例
  factory TDNetworkManager() => _getInstance();
  static TDNetworkManager get instance => _getInstance();
  static TDNetworkManager? _instance;
  static TDNetworkManager _getInstance() {
    _instance ??= TDNetworkManager._internal();
    return _instance!;
  }

  TDNetworkManager._internal() {
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
        getSuccessResponseModelBlock: (String fullUrl, int statusCode,
            dynamic responseObject, bool? isFromCache,
            {required ResOptions resOptions}) {
          Map<String, dynamic> responseMap = responseObject;
          bool isSuccess = responseMap["code"] == 200;
          var errorCode = isSuccess ? 0 : -1;
          var msg = isSuccess ? "成功" : "失败";
          ResponseModel responseModel = ResponseModel(
            statusCode: errorCode,
            message: msg,
            result: responseMap,
            isCache: isFromCache,
            dateModel: ResponseDateModel.fromResOptions(resOptions),
          );
          return responseModel;
        },
        getFailureResponseModelBlock: (String fullUrl, int statusCode,
            dynamic responseObject, bool? isCacheData,
            {required ResOptions resOptions}) {
          String errorMessage = '临时写的，暂时都不会调用到此转换方法';
          ResponseModel responseModel = ResponseModel(
            statusCode: statusCode,
            message: errorMessage,
            result: null,
            dateModel: ResponseDateModel.fromResOptions(resOptions),
          );
          return responseModel;
        },
        getDioErrorResponseModelBlock:
            (String url, ErrOptions errorModel, bool? isCacheData,
                {required ErrOptions errOptions}) {
          return ErrorResponseUtil.getErrorResponseModel(
            url,
            errorModel,
            isCacheData,
            errOptions: errOptions,
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
