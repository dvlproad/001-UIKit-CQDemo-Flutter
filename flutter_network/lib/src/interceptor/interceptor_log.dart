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

    final data = options.data;
    if (data != null) {
      if (data is Map) {
        requestStr += "- BODY:\n${data.mapToStructureString()}\n";
      } else if (data is FormData) {
        final formDataMap = Map()
          ..addEntries(data.fields)
          ..addEntries(data.files);
        requestStr += "- BODY:\n${formDataMap.mapToStructureString()}\n";
      } else {
        requestStr += "- BODY:\n${data.toString()}\n";
      }
    }

    // LogUtil.v("请求开始的信息1：" + data.toString());
    LogUtil.v("请求开始的信息：" + requestStr);

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

    if (err.response != null && err.response.data != null) {
      print('╔ ${err.type.toString()}');
      errorStr += "- ERROR:\n${_parseResponse(err.response)}\n";
    } else {
      errorStr += "- ERRORTYPE: ${err.type}\n";
      errorStr += "- MSG: ${err.message}\n";
    }

    LogUtil.v("请求失败的回复：" + errorStr);

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
    responseStr += "- STATUS: ${response.statusCode}\n";

    if (response.data != null) {
      responseStr += "- BODY:\n ${_parseResponse(response)}";
    }
    responseStr = printWrapped(responseStr);

    // LogUtil.v("请求成功的回复1：" + response.data.toString());
    LogUtil.v("请求成功的回复：" + responseStr);

    handler.next(response);
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
    if (data is Map)
      responseStr += data.mapToStructureString();
    else if (data is List)
      responseStr += data.listToStructureString();
    else
      responseStr += response.data.toString();

    return responseStr;
  }
}
