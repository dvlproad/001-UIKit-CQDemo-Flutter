import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:flutter_log/flutter_log.dart';
import './appendPathExtension.dart';

///日志拦截器
class DioLogInterceptor extends Interceptor {
  ///请求前
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String url;
    if (options.path.startsWith(RegExp(r'https?:'))) {
      url = options.path;
    } else {
      url = options.baseUrl.appendPathString(options.path);
    }
    String requestStr = "\n==================== REQUEST ====================\n"
        "- URL:\n${url}\n"
        "- METHOD: ${options.method}\n";

    requestStr += "- HEADER:\n${options.headers.mapToStructureString()}\n";

    String bodyString = _getBodyString(options);
    requestStr += bodyString;

    // LogUtil.normal("请求开始的信息1：" + data.toString());
    LogUtil.normal("请求开始的信息：" + requestStr);

    handler.next(options);
  }

  ///出错前
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    String url =
        err.requestOptions.baseUrl.appendPathString(err.requestOptions.path);

    String errorStr = '''
\n==================== RESPONSE ====================\n
    - URL:\n${url}\n
    - METHOD: ${err.requestOptions.method}\n
    ''';

    if (err != null && err.response != null && err.response.headers != null) {
      errorStr +=
          "- HEADER:\n${err.response.headers.map.mapToStructureString()}\n";
    }

    String bodyString = _getBodyString(err.requestOptions);
    errorStr += bodyString;

    errorStr += "- ERRORTYPE: ${err.type}\n";
    print('╔ ${err.type.toString()}');
    if (err.response != null && err.response.data != null) {
      errorStr += "- ERROR:\n${_parseResponse(err.response)}\n";
    } else {
      errorStr += "- MSG: ${err.message}\n";
    }

    LogUtil.error("请求失败的回复：" + errorStr);

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

    String responseStr =
        "\n==================== RESPONSE ====================\n"
        "- URL:\n${uri}\n";
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
    if (responseObject.keys.contains('code') == false) {
      // 不是项目结构，比如是yapi格式
      if (responseObject.keys.contains('errcode') == true) {
        // yapi的格式
        int businessCode = responseObject["errcode"];
        if (businessCode != 0) {
          LogUtil.error("请求失败(code$businessCode)的回复：" + responseStr);
        } else {
          LogUtil.normal("请求成功(code$businessCode)的回复：" + responseStr);
        }
      } else {
        // 其他非项目结构的，暂时都当做成功，目前不会有此情况
        LogUtil.normal("请求成功的回复：" + responseStr);
      }
    } else {
      int businessCode = responseObject["code"];
      if (businessCode == 0) {
        LogUtil.normal("请求成功(code$businessCode)的回复：" + responseStr);
      } else if (businessCode == 500) {
        LogUtil.error("请求失败(code$businessCode)的回复：" + responseStr);
      } else {
        LogUtil.warning("请求成功(code$businessCode)的回复：" + responseStr);
      }
    }

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
