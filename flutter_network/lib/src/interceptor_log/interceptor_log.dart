import 'dart:convert' as convert;
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:flutter_log/src/string_format_util/formatter_object_util.dart';
import '../log/dio_log_util.dart';
import '../url/url_util.dart';
import '../mock/mock_analy_util.dart';
import '../cache/dio_cache_util.dart';

///日志拦截器
class DioLogInterceptor extends Interceptor {
  ///请求前
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String url = UrlUtil.fullUrlFromDioRequestOptions(options);
    String requestStr = "======== REQUEST(请求开始的信息) ========\n";
    requestStr += "- URL:\n${url}\n";
    requestStr += "- METHOD: ${options.method}\n";

    Map<String, dynamic> headersMap = options.headers;
    String headersMapString =
        FormatterUtil.convert(headersMap, 0, isObject: true);
    requestStr += "- HEADER:\n$headersMapString\n";

    String bodyString = _getBodyString(options);
    requestStr += bodyString;

    //requestStr = data.toString();
    // requestStr = "请求开始的信息：" + requestStr;

    bool isFromCache = null;
    if (null != DioCacheUtil.isRequestCacheCheckFunction) {
      isFromCache = DioCacheUtil.isRequestCacheCheckFunction(options);
    }
    DioLogUtil.logApi(
      url,
      requestStr,
      ApiProcessType.request,
      ApiLogLevel.normal,
      isFromCache: isFromCache,
    );

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
      Map<String, List<String>> headersMap = err.response.headers.map;
      String headersMapString =
          FormatterUtil.convert(headersMap, 0, isObject: true);

      errorStr += "- HEADER:\n$headersMapString\n";
    }

    String bodyString = _getBodyString(err.requestOptions);
    errorStr += bodyString;

    errorStr += "- ERRORTYPE: ${err.type}\n"; // 错误类型

    bool isResponseDataNull = false;
    if (err.response == null) {
      isResponseDataNull = true;
    } else {
      var data = err.response.data;
      if (data == null) {
        isResponseDataNull = true;
      } else {
        if (data is String) {
          isResponseDataNull = (data as String).isEmpty;
        } else {
          isResponseDataNull = false;
        }
      }
    }

    if (isResponseDataNull == true) {
      errorStr += "- MSG: ${err.message}\n";
    } else {
      var data = err.response.data;
      String responseStr = FormatterUtil.convert(data, 0, isObject: true);
      errorStr += "- ERROR:\n${responseStr}\n";
    }

    String logHeaderString = ''; // 日志头
    logHeaderString += "请求失败(${err.type.toString()})的回复：\n";
    logHeaderString += "============== Error ==============\n";

    errorStr = logHeaderString + errorStr;

    bool isFromCache = null;
    if (null != DioCacheUtil.isCacheErrorCheckFunction) {
      isFromCache = DioCacheUtil.isCacheErrorCheckFunction(err);
    }
    DioLogUtil.logApi(
      url,
      errorStr,
      ApiProcessType.error,
      ApiLogLevel.error,
      isFromCache: isFromCache,
    );

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
      dynamic responseObject;
      if (response.data is String) {
        // 后台把data按字符串返回的时候
        responseObject = convert.jsonDecode(response.data);
      } else {
        //String dataString = response.data.toString();
        String dataJsonString = convert.jsonEncode(response.data);
        responseObject = convert.jsonDecode(dataJsonString);
      }

      String responseString =
          FormatterUtil.convert(responseObject, 0, isObject: true);
      responseStr += "- RESPONSE:\n $responseString";
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

    bool isFromCache = null;
    if (null != DioCacheUtil.isCacheResponseCheckFunction) {
      isFromCache = DioCacheUtil.isCacheResponseCheckFunction(response);
    }
    DioLogUtil.logApi(
      url,
      responseStr,
      ApiProcessType.response,
      apiLogLevel,
      isFromCache: isFromCache,
    );

    handler.next(response);
  }

  String _getBodyString(RequestOptions options) {
    String bodyString = '';
    final data = options.data;
    if (data != null) {
      if (data is Map) {
        String dataString = FormatterUtil.convert(data, 0, isObject: true);
        bodyString += "- BODY:\n$dataString\n";
      } else if (data is FormData) {
        final formDataMap = Map()
          ..addEntries(data.fields)
          ..addEntries(data.files);

        String formDataString =
            FormatterUtil.convert(formDataMap, 0, isObject: true);
        bodyString += "- BODY:\n$formDataString\n";
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
}
