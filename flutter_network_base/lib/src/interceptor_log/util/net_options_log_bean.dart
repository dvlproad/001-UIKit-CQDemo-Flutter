/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-14 00:01:22
 * @Description: 请求各过程中的信息获取
 */
import '../../bean/net_options.dart';

/// api 日志信息类型
enum ApiLogLevel {
  request, // 正常日志信息
  // ignore: constant_identifier_names
  error_timeout, // 请求超时的错误信息（超时的请求错误企业微信上报，使用文件折叠，其他用纯文本铺开）
  // ignore: constant_identifier_names
  error_other, // 请求失败的其他错误信息（超时的请求错误企业微信上报，使用文件折叠，其他用纯文本铺开）
  // ignore: constant_identifier_names
  response_warning, // 请求成功但业务失败(警告)
  // ignore: constant_identifier_names
  response_success, // 请求成功并业务成功(恭喜)
}

class ApiLogLevelUtil {
  static ApiLogLevel getApiLogLevelByStatusCode(
    int statusCode,
    String statusMessage,
  ) {
    String? errorMessage = statusMessage;

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

class ApiMessageModel {
  DateTime dateTime;
  ApiProcessType apiProcessType;

  Map<String, dynamic> detailLogJsonMap;
  Map<String, dynamic> shortLogJsonMap;
  ApiLogLevel apiLogLevel;

  bool? isCacheApiLog;

  // error 才有的数据
  NetworkErrorType? errorType;

  // response 才有的数据
  int? statusCode;
  int? businessCode;

  ApiMessageModel({
    required this.dateTime,
    required this.apiProcessType,
    required this.detailLogJsonMap,
    required this.shortLogJsonMap, // 简略信息(目前只用在页面日志列表的cell里，详情里还是完整信息)
    required this.apiLogLevel,
    this.errorType, // error 时候才有
    this.statusCode, // response 时候才有
    this.businessCode, // response 时候才有
    this.isCacheApiLog,
  });

  String get logHeaderString {
    String logHeaderString = ''; // 日志头
    if (apiProcessType == ApiProcessType.request) {
      logHeaderString += "======== REQUEST(请求开始的信息) ========";
    } else if (apiProcessType == ApiProcessType.error) {
      logHeaderString += "请求失败(${errorType.toString()})的回复：\n";
      logHeaderString += "============== Error ==============";
    } else if (apiProcessType == ApiProcessType.response) {
      logHeaderString += "=========== RESPONSE ===========\n"; // 日志头
      if (apiLogLevel == ApiLogLevel.response_success ||
          apiLogLevel == ApiLogLevel.response_warning) {
        logHeaderString += "请求成功(code$businessCode)的回复";
      } else {
        logHeaderString += "请求失败(code$businessCode)的回复";
      }
    }

    return logHeaderString;
  }
}
