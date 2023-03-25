// ignore_for_file: depend_on_referenced_packages, constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-09-06 13:16:21
 * @Description: 蒲公英请求管理中心
 */
import 'package:flutter_network_kit/flutter_network_kit.dart';

class PgyerNetworkManager extends CacheNetworkClient {
  static const int CONNECT_TIMEOUT = 60000;
  static const int RECEIVE_TIMEOUT = 60000;

  // 单例
  factory PgyerNetworkManager() => _getInstance();
  static PgyerNetworkManager get instance => _getInstance();
  static PgyerNetworkManager? _instance;
  static PgyerNetworkManager _getInstance() {
    _instance ??= PgyerNetworkManager._internal();
    return _instance!;
  }

  PgyerNetworkManager._internal() {
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
          Map<String, dynamic> responseMap = responseObject;

          int errorCode = responseMap['code'];
          String? msg = responseMap['message'];
          dynamic result = responseMap['data'];
          ResponseModel responseModel = ResponseModel(
            statusCode: errorCode,
            message: msg,
            result: result,
            isCache: isFromCache,
          );
          return responseModel;
        },
        getFailureResponseModelBlock: (String fullUrl, int? statusCode,
            dynamic responseObject, bool? isCacheData) {
          return ResponseModel(
            statusCode: -1,
            isCache: isCacheData,
          );
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

/*
class PgyerRequestUtil {
  ///POST请求:蒲公英
  static Future<PgyerResponseModel> requset(
    String url, {
    Map<String, dynamic>? customParams,
  }) async {
    String platformName = "";
    if (Platform.isIOS) {
      platformName = 'ios';
    } else if (Platform.isAndroid) {
      platformName = 'android';
    }
    BranchPackageInfo packageInfo = await BranchPackageInfo.fromPlatform();
    String appBundleID = packageInfo.packageName;
    String appVersion = packageInfo.version;
    String buildBuildVersion = packageInfo.buildNumber;

    Map<String, dynamic> commonParams = {
      "_api_key": _pygerApiKey,
      "appKey": _pygerAppKey,
      "buildVersion": appVersion,
      "buildBuildVersion": buildBuildVersion,
    };

    Map<String, dynamic> allParams = commonParams;
    if (customParams != null) {
      allParams.addAll(customParams);
    }

    Options options = Options(
      contentType: "application/x-www-form-urlencoded",
    );

    CancelToken cancelToken = CancelToken();

    Dio dio = Dio();

    try {
      Response response = await dio.post(
        url,
        data: allParams,
        options: options,
        cancelToken: cancelToken,
      );

      Map<String, dynamic> responseObject = response.data;
      PgyerResponseModel responseModel = PgyerResponseModel(
        code: responseObject['code'],
        message: responseObject['message'],
        result: responseObject['data'],
      );

      return responseModel;
    } catch (e) {
      String errorMessage = e.toString();

      String message = '请求$url的时候，发生网络错误:$errorMessage';
      // throw Exception(message);

      PgyerResponseModel pgyerResponseModel = PgyerResponseModel(
        code: -1,
        message: message,
      );
      return pgyerResponseModel;
    }
  }
}
*/