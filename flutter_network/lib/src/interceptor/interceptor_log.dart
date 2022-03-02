import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:flutter_log/flutter_log.dart';
import './url_util.dart';
import '../mock_analy_util.dart';

/// api 日志信息类型
enum ApiLogLevel {
  normal, // 正常日志信息
  warning, // 警告信息
  error, // 错误信息
}

/// api 请求的阶段类型
enum ApiProcessType {
  request, // 请求阶段
  error, // 请求失败
  response, // 请求成功
}

///日志拦截器
class DioLogInterceptor extends Interceptor {
  static void Function(
    String fullUrl, // 完整的url路径
    String logString, {
    ApiProcessType apiProcessType, // api 请求的阶段类型
    ApiLogLevel apiLogLevel, // api 日志信息类型
  }) logApiInfoAction; // 打印请求各阶段出现的不同等级的日志信息

  void logApi(
    String fullUrl, // 完整的url路径
    String logString, // api 日志信息
    ApiProcessType apiProcessType, // api 请求的阶段类型
    ApiLogLevel apiLogLevel, // api 日志信息类型
  ) {
    if (DioLogInterceptor.logApiInfoAction != null) {
      DioLogInterceptor.logApiInfoAction(
        fullUrl,
        logString,
        apiProcessType: apiProcessType,
        apiLogLevel: apiLogLevel,
      );
    }
  }

  ///请求前
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String url = UrlUtil.fullUrlFromDioRequestOptions(options);
    String requestStr = "======== REQUEST(请求开始的信息) ========\n";
    requestStr += "- URL:\n${url}\n";
    requestStr += "- METHOD: ${options.method}\n";
    requestStr += "- HEADER:\n${options.headers.mapToStructureString()}\n";

    String bodyString = _getBodyString(options);
    requestStr += bodyString;

    //requestStr = data.toString();
    // requestStr = "请求开始的信息：" + requestStr;
    logApi(url, requestStr, ApiProcessType.request, ApiLogLevel.normal);

    handler.next(options);
  }

  ///出错前
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    String url = UrlUtil.fullUrlFromDioError(err);

    String errorStr = '''
    - URL:\n${url}
    - METHOD: ${err.requestOptions.method}
    ''';

    if (err != null && err.response != null && err.response.headers != null) {
      errorStr +=
          "- HEADER:\n${err.response.headers.map.mapToStructureString()}\n";
    }

    String bodyString = _getBodyString(err.requestOptions);
    errorStr += bodyString;

    errorStr += "- ERRORTYPE: ${err.type}\n"; // 错误类型
    print('╔ ${err.type.toString()}');
    if (err.response != null && err.response.data != null) {
      errorStr += "- ERROR:\n${_parseResponse(err.response)}\n";
    } else {
      errorStr += "- MSG: ${err.message}\n";
    }

    String logHeaderString = ''; // 日志头
    logHeaderString += "请求失败(${err.type.toString()})的回复：\n";
    logHeaderString += "============== Error ==============\n";

    errorStr = logHeaderString + errorStr;
    logApi(url, errorStr, ApiProcessType.error, ApiLogLevel.error);

    handler.next(err);
  }

  ///响应前
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.headers == null) {
      print('---- response.headers = null');
      response.headers = Headers();
    }

    Uri uri = response.requestOptions.uri;

    String responseStr = "";
    responseStr += "- URL:\n${uri}\n";
    responseStr += "- HEADER:\n{";
    response.headers.forEach(
        (key, list) => responseStr += "\n  " + "\"$key\" : \"$list\",");
    responseStr += "\n}\n";
    // body
    String bodyString = _getBodyString(response.requestOptions);
    responseStr += bodyString;
    // status
    responseStr += "- STATUS: ${response.statusCode}\n";

    if (response.data != null) {
      responseStr += "- RESPONSE:\n ${_parseResponse(response)}";
    }
    responseStr = printWrapped(responseStr);

    dynamic responseObject;
    if (response.data is String) {
      // 后台把data按字符串返回的时候
      responseObject = convert.jsonDecode(response.data);
    } else {
      //String dataString = response.data.toString();
      String dataJsonString = convert.jsonEncode(response.data);
      responseObject = convert.jsonDecode(dataJsonString);
    }
    // LogUtil.normal("请求成功的回复1：" + response.data.toString());
    String url = uri.toString();
    bool isMockEnvironment = MockAnalyUtil.isMockEnvironment(url);

    String logHeaderString = "=========== RESPONSE ===========\n"; // 日志头
    ApiLogLevel apiLogLevel = ApiLogLevel.normal;
    if (isMockEnvironment == true) {
      // 是模拟的环境，不是本项目
      bool mockHappenError =
          responseObject.keys.contains('errcode') == true; // mock环境是否发生错误
      if (mockHappenError == true) {
        int businessCode = responseObject["errcode"];
        logHeaderString += "请求失败(code$businessCode)的回复\n";
        apiLogLevel = ApiLogLevel.error;
      } else {
        logHeaderString += "请求成功的回复\n";
        apiLogLevel = ApiLogLevel.normal;
      }
    } else {
      int businessCode = responseObject["code"];
      if (businessCode == 0) {
        logHeaderString += "请求成功(code$businessCode)的回复\n";
        apiLogLevel = ApiLogLevel.normal;
      } else if (businessCode == 500 ||
          businessCode == 401 ||
          businessCode == 404) {
        // 500 Internal Server Error 服务器错误
        // 401 Unauthorized 当前请求需要用户验证(token不能为空)
        // 404 Not Found 请求路径不存在
        logHeaderString += "请求失败(code$businessCode)的回复\n";
        String errorMessage = responseObject["msg"];
        bool needRelogin = errorMessage == '暂未登录或token已经过期';
        if (needRelogin) {
          apiLogLevel = ApiLogLevel.warning;
        } else {
          apiLogLevel = ApiLogLevel.error;
        }
      } else {
        logHeaderString += "请求成功(code$businessCode)的回复\n";
        apiLogLevel = ApiLogLevel.warning;
      }
    }

    responseStr = logHeaderString + responseStr;
    logApi(url, responseStr, ApiProcessType.response, apiLogLevel);

    handler.next(response);
  }

  String _getBodyString(RequestOptions options) {
    String bodyString = '';
    final data = options.data;
    if (data != null) {
      if (data is Map) {
        bodyString += "- BODY:\n${data.mapToStructureString()}\n";
      } else if (data is FormData) {
        final formDataMap = Map()
          ..addEntries(data.fields)
          ..addEntries(data.files);
        bodyString += "- BODY:\n${formDataMap.mapToStructureString()}\n";
      } else {
        bodyString += "- BODY:\n${data.toString()}\n";
      }
    }
    return bodyString;
  }

  String printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk

    String allString = '';
    pattern.allMatches(text).forEach((match) {
      String string = match.group(0);
      allString = allString + '\n' + string;
    });

    return allString;
  }

  String _parseResponse(Response response) {
    String responseStr = "";
    var data = response.data;
    if (data is Map) {
      responseStr += data.mapToStructureString();
    } else if (data is List) {
      responseStr += data.listToStructureString();
    } else {
      responseStr += data.toString();
    }

    return responseStr;
  }
}
