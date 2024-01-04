/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 17:40:42
 * @Description: 网络请求Error错误的信息模型
 */
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

import './req_options.dart';
import './res_options.dart';

enum NetworkErrorType {
  /// It occurs when url is opened timeout.
  connectTimeout,

  /// It occurs when url is sent timeout.
  sendTimeout,

  ///It occurs when receiving timeout.
  receiveTimeout,

  /// When the server response, but with a incorrect status, such as 404, 503...
  response,

  /// When the request is cancelled, dio will throw a error with this type.
  cancel,

  /// Default error type, Some other Error. In this case, you can
  /// use the DioError.error if it is not null.
  other,
}

class NetworkErrorTypeUtil {
  ///string转枚举类型
  static NetworkErrorType networkErrorTypeFromString(String value) {
    Iterable<NetworkErrorType> values = [
      NetworkErrorType.connectTimeout,
      NetworkErrorType.sendTimeout,
      NetworkErrorType.receiveTimeout,
      NetworkErrorType.response,
      NetworkErrorType.cancel,
      NetworkErrorType.other,
    ];

    return values.firstWhere((type) {
      return type.toString().split('.').last == value;
    }, orElse: () {
      return NetworkErrorType.other;
    });
  }

  ///枚举类型转string
  static String networkErrorTypeStringFromEnum(o) {
    return o.toString().split('.').last;
  }
}

class ErrOptions {
  late DateTime errorTime; //ms
  String? message;
  ReqOptions requestOptions;
  ResOptions? response;
  NetworkErrorType type;

  bool? isErrorFromCache; // 此错误信息是否是来自缓存数据(默认null，表示是请求后台的实际接口返回的出错信息)

  ErrOptions({
    this.message,
    required this.requestOptions,
    this.response,
    required this.type,
    this.isErrorFromCache,
  }) {
    errorTime = DateTime.now();
  }

  int get id {
    return requestOptions.id;
  }

  String get fullUrl {
    return requestOptions.fullUrl;
  }

  String get apiSpendTime {
    Duration duration = errorTime.difference(requestOptions.requestTime);
    int milliseconds = duration.inMilliseconds;
    String startTime = requestOptions.requestTime.toString().substring(11);
    String endTime = errorTime.toString().substring(11);
    if (milliseconds > 0) {
      return "$milliseconds毫秒($startTime---$endTime)";
    } else {
      int microseconds = duration.inMicroseconds;
      return "0毫秒$microseconds微秒($startTime---$endTime)";
    }
  }

  Map<String, dynamic> get detailLogJsonMap => logJsonMap["detail"];

  Map<String, dynamic> get logJsonMap {
    Map<String, dynamic> detailLogJsonMap = {};
    Map<String, dynamic> shortLogJsonMap = {};

    ErrOptions err = this;

    bool? isErrorFromCache = err.isErrorFromCache;
    if (isErrorFromCache == true) {
      detailLogJsonMap.addAll({"isRealApi": "====此次api结果为缓存数据，而不是后台实际结果===="});
      shortLogJsonMap.addAll({"isRealApi": "====此次api结果为缓存数据，而不是后台实际结果===="});
    }

    detailLogJsonMap.addAll({"apiSpendTime": apiSpendTime});
    shortLogJsonMap.addAll({"apiSpendTime": apiSpendTime});
    detailLogJsonMap.addAll({"URL": err.fullUrl});
    shortLogJsonMap.addAll({"URL": err.fullUrl});

    detailLogJsonMap.addAll({"METHOD": err.requestOptions.method});

    if (err.response != null) {
      Map<String, dynamic>? requestHeadersMap =
          err.response!.requestOptions.headers;
      if (requestHeadersMap != null) {
        detailLogJsonMap.addAll({"HEADER(REQUEST)": requestHeadersMap});
      }

      Map<String, List<String>>? headersMap = err.response!.headersMap;
      if (headersMap != null) {
        detailLogJsonMap.addAll({"HEADER(RESPONSE)": headersMap});
      }
    }

    Map<String, dynamic> bodyJsonMap = err.requestOptions.bodyJsonMap;
    detailLogJsonMap.addAll({"BODY": bodyJsonMap});

    detailLogJsonMap.addAll({"ERRORTYPE": err.type.toString()}); // 错误类型
    shortLogJsonMap.addAll({"ERRORTYPE": err.type.toString()}); // 错误类型
    detailLogJsonMap.addAll({"MSG": err.message});

    if (err.response != null) {
      ResOptions response = err.response!;
      detailLogJsonMap.addAll({"STATUS": response.statusCode});

      Map<String, dynamic> responseMap;
      if (response.data is String) {
        // 后台把data按字符串返回的时候
        if ((response.data as String).isEmpty) {
          responseMap = {};
        } else {
          try {
            responseMap = convert.jsonDecode(response.data);
          } on FormatException catch (e) {
            debugPrint("$e");
            responseMap = response.data;
          }
        }
      } else {
        responseMap = response.data;
      }
      detailLogJsonMap.addAll({
        "RESPONSE_Class": response.data.runtimeType.toString(),
        "RESPONSE_Data": responseMap,
      });
    }

    return {
      "short": shortLogJsonMap,
      "detail": detailLogJsonMap,
    };
  }
}
