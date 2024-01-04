// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 18:00:46
 * @Description: 服务器返回的数据模型
 */

import './interceptor_log/util/net_options_log_bean.dart';
import 'bean/err_options.dart';
import 'bean/res_options.dart';

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

class ResponseDateModel {
  final DateTime requestTime;
  final DateTime endTime; //ms

  ResponseDateModel({
    required this.requestTime, // 请求开始的时间
    required this.endTime, // 请求结束的时间
  });

  static ResponseDateModel fromErrOptions(ErrOptions errOptions) {
    return ResponseDateModel(
      requestTime: errOptions.requestOptions.requestTime,
      endTime: errOptions.errorTime,
    );
  }

  static ResponseDateModel fromResOptions(ResOptions resOptions) {
    return ResponseDateModel(
      requestTime: resOptions.requestOptions.requestTime,
      endTime: resOptions.responseTime,
    );
  }

  static String getApiSpendTime(List<ResponseDateModel> dateModels) {
    ResponseDateModel firstDateModel = dateModels.first;
    ResponseDateModel lastDateModel = dateModels.last;

    String allItemSpendTime = "";
    int count = dateModels.length;

    DateTime? lastEndTime;
    for (int i = 0; i < count; i++) {
      ResponseDateModel dateModel = dateModels[i];

      String spendTime = "${i + 1}";
      spendTime += "、${dateModel.apiSpendTime}";
      spendTime +=
          "${dateModel.requestTime.toString().substring(11)}--${dateModel.endTime.toString().substring(11)}";
      if (i > 0) {
        allItemSpendTime += "====";

        if (lastEndTime != null) {
          Duration skipDuration = dateModel.requestTime.difference(lastEndTime);
          allItemSpendTime += "${skipDuration.inMilliseconds}毫秒====";
        }
      }
      allItemSpendTime += spendTime;

      lastEndTime = dateModel.endTime;
    }

    Duration totalDuration =
        lastDateModel.endTime.difference(firstDateModel.requestTime);
    // int seconds = totalDuration.inSeconds;
    int milliseconds = totalDuration.inMilliseconds;
    // return apiDuration.toString();
    String spendTime = "$milliseconds毫秒($allItemSpendTime)";

    return spendTime;
  }

  String get apiSpendTime {
    Duration duration = endTime.difference(requestTime);

    // int seconds = duration.inSeconds;
    int milliseconds = duration.inMilliseconds;
    if (milliseconds > 0) {
      return "$milliseconds毫秒";
    } else {
      int microseconds = duration.inMicroseconds;
      return "0毫秒$microseconds微秒";
    }
  }
}

class ResponseModel {
  int statusCode;
  String? message;
  dynamic result;
  bool? isCache;
  bool? isSameToBefore; // 网络新数据是否和之前数据一样(重试/缓存)
  final ResponseDateModel dateModel;
  List<ResponseDateModel>? dateModels; // 有时候得到一个结果是不仅经过一次，而是多次请求才得到的（如缓存）

  ResponseModel({
    required this.statusCode,
    this.message,
    this.result,
    this.isCache,
    this.isSameToBefore,
    required this.dateModel,
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
    if (isSameToBefore != null) {
      responseMap.addAll({"isSameToBefore": isSameToBefore});
    }

    responseMap.addAll({"statusCode": statusCode});
    if (message != null) {
      responseMap.addAll({"message": message});
    }
    if (result != null) {
      responseMap.addAll({"result": result});
    }
    return responseMap;
  }

  bool isEqualToResponse(ResponseModel cacheResponseModel) {
    if (statusCode != cacheResponseModel.statusCode) {
      return false;
    }

    if (message != cacheResponseModel.message) {
      return false;
    }

    if (result.toString() != cacheResponseModel.result.toString()) {
      return false;
    }

    return true;
  }

  bool get isSuccess => statusCode == 0;
  // 是否是错误的response（http错误、网络错误)
  bool get isErrorResponse {
    List<int> httpCodes = [
      HttpStatusCode.NoNetwork,
      HttpStatusCode.ErrorDioCancel,
      HttpStatusCode.ErrorTimeout,
      HttpStatusCode.ErrorDioResponse,
      HttpStatusCode.ErrorTryCatch,
      HttpStatusCode.Unknow,
      500,
      503,
      401,
      20030,
    ];
    return httpCodes.contains(statusCode);
  }

  /// 获取错误时候的 responseModel
  static ResponseModel nonetworkResponseModel({
    required DateTime requestTime,
    required DateTime errorTime,
  }) {
    ResponseModel responseModel = ResponseModel(
      statusCode: HttpStatusCode.NoNetwork,
      message: "目前无网络可用",
      result: null,
      dateModel: ResponseDateModel(
        requestTime: requestTime,
        endTime: errorTime,
      ),
    );
    return responseModel;
  }

  static ResponseModel tryCatchErrorResponseModel(
    String message, {
    bool? isCache,
    required DateTime requestTime,
    required DateTime errorTime,
  }) {
    ResponseModel responseModel = ResponseModel(
      statusCode: HttpStatusCode.ErrorTryCatch,
      message: message,
      result: null,
      isCache: isCache,
      dateModel: ResponseDateModel(
        requestTime: requestTime,
        endTime: errorTime,
      ),
    );
    return responseModel;
  }

  // 自定义获取api日志类型
  ApiLogLevel Function(ResponseModel responseModel)? customGetApiLogLevelBlock;

  ApiLogLevel get apiLogLevel {
    if (customGetApiLogLevelBlock != null) {
      return customGetApiLogLevelBlock!(this);
    }
    return ApiLogLevelUtil.getApiLogLevelByStatusCode(
      statusCode,
      message ?? '',
    );
  }
}

enum RequestMethod {
  post,
  get,
}
