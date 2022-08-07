/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 14:49:32
 * @Description: 服务器返回的数据模型
 */

import './interceptor_log/util/net_options_log_bean.dart';

class HttpStatusCode {
  static int Unknow = -500; // 未知错误
  static int NoNetwork = -1; // 无网络错误
  static int ErrorTryCatch = -2; // try catch 中出现问题

  // try catch 中出现问题
  /// It occurs when url is opened timeout/sent timeout/receiving timeout.
  static int ErrorTimeout = -101;

  /// When the request is cancelled, dio will throw a error with this type.
  static int ErrorDioCancel = -102;

  /// When the server response, but with a incorrect status, such as 404, 503...
  static int ErrorDioResponse = -103;

  /// Default error type, Some other Error. In this case, you can use the DioError.error if it is not null.
  static int ErrorDioOther = -104;

  static int Error401 = 401; // （未授权） 请求要求身份验证。 对于需要登录的网页，服务器可能返回此响应。
  static int Error404 = 404; // （未找到） 服务器找不到请求的网页。
  static int Error500 = 500; // （服务器内部错误） 服务器遇到错误，无法完成请求。
  //static int Error501; // （尚未实施） 服务器不具备完成请求的功能。 例如，服务器无法识别请求方法时可能会返回此代码。
  //static int Error502; // （错误网关） 服务器作为网关或代理，从上游服务器收到无效响应。
  static int Error503 = 503; // （服务不可用） 服务器目前无法使用（由于超载或停机维护）。 通常，这只是暂时状态。
  //static int Error504; // （网关超时） 服务器作为网关或代理，但是没有及时从上游服务器收到请求。
  //static int Error505; // （HTTP 版本不受支持）服务器不支持请求中所用的 HTTP 协议版本。
}

class ResponseModel {
  int statusCode;
  String? message;
  dynamic? result;
  bool? isCache;

  ResponseModel({
    required this.statusCode,
    this.message,
    this.result,
    this.isCache,
  });

  @override
  String toString() {
    return "{isCache:$isCache,statusCode:$statusCode,message:$message,result:${result.toString()}}";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> responseMap = {};
    if (isCache != null) {
      responseMap.addAll({"isCache": isCache});
    }
    if (statusCode != null) {
      responseMap.addAll({"statusCode": statusCode});
    }
    if (message != null) {
      responseMap.addAll({"message": message});
    }
    if (result != null) {
      responseMap.addAll({"result": result});
    }
    return responseMap;
  }

  bool get isSuccess => statusCode == 0;

  /// 获取错误时候的 responseModel
  static ResponseModel nonetworkResponseModel() {
    ResponseModel responseModel = ResponseModel(
      statusCode: HttpStatusCode.NoNetwork,
      message: "目前无网络可用",
      result: null,
    );
    return responseModel;
  }

  static ResponseModel tryCatchErrorResponseModel(
    String message, {
    bool? isCache,
  }) {
    ResponseModel responseModel = ResponseModel(
      statusCode: HttpStatusCode.ErrorTryCatch,
      message: message,
      result: null,
      isCache: isCache,
    );
    return responseModel;
  }

  ApiLogLevel get apiLogLevel {
    String? errorMessage = message;

    ApiLogLevel apiLogLevel = ApiLogLevel.response_success;
    if (statusCode == 200 || statusCode == 0) {
      apiLogLevel = ApiLogLevel.response_success;
    } else if (statusCode == 401) {
      // 401 Unauthorized 当前请求需要用户验证(token不能为空)
      bool needRelogin = errorMessage == '暂未登录或token已经过期';
      if (needRelogin) {
        apiLogLevel = ApiLogLevel.response_warning;
      } else {
        apiLogLevel = ApiLogLevel.error_other;
      }
    } else if (statusCode == 500 || statusCode == 503 || statusCode == 404) {
      // 500 Internal Server Error 服务器错误
      // 401 Unauthorized 当前请求需要用户验证(token不能为空)
      // 404 Not Found 请求路径不存在
      apiLogLevel = ApiLogLevel.error_other;
    } else {
      apiLogLevel = ApiLogLevel.response_warning;
    }

    return apiLogLevel;
  }
}

enum RequestMethod {
  post,
  get,
}
