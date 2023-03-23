/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 16:50:55
 * @Description: 网络请求成功返回的数据模型
 */
import 'dart:convert' as convert;
import 'req_options.dart';

class ResOptions {
  ReqOptions requestOptions;
  dynamic data;

  /// Http status code.
  int? statusCode;

  /// Returns the reason phrase associated with the status code.
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body.
  String? statusMessage;

  late DateTime responseTime; //ms

  Map<String, List<String>>? headersMap;

  bool? isResponseFromCache; // 此错误信息是否是来自缓存数据(默认null，表示是请求后台的实际接口返回的结果)

  ResOptions({
    required this.requestOptions,
    required this.data,
    this.statusCode,
    this.statusMessage,
    // this.duration,
    this.headersMap,
    this.isResponseFromCache,
  }) {
    responseTime = DateTime.now();
  }

  int get duration {
    int iDuration = responseTime.millisecondsSinceEpoch -
        requestOptions.requestTime.millisecondsSinceEpoch;
    return iDuration;
  }

  int get id {
    return requestOptions.id;
  }

  String get fullUrl {
    return requestOptions.fullUrl;
  }

  Map<String, dynamic> get detailLogJsonMap {
    Map<String, dynamic> detailLogJsonMap = {};

    ResOptions response = this;

    bool? isResponseFromCache = response.isResponseFromCache;
    if (isResponseFromCache == true) {
      detailLogJsonMap.addAll({"isRealApi": "====此次api结果为缓存数据，而不是后台实际结果===="});
    }

    detailLogJsonMap.addAll({"URL": response.fullUrl});

    Map<String, dynamic>? requestHeadersMap = response.requestOptions.headers;
    if (requestHeadersMap != null) {
      detailLogJsonMap.addAll({"HEADER(REQUEST)": requestHeadersMap});
    }

    if (response.headersMap != null) {
      detailLogJsonMap.addAll({"HEADER(RESPONSE)": response.headersMap});
    }

    if (response.requestOptions.method == "GET" &&
        response.requestOptions.params != null) {
      detailLogJsonMap.addAll({"GET params": response.requestOptions.params});
    }

    Map<String, dynamic> bodyJsonMap = response.requestOptions.bodyJsonMap;
    detailLogJsonMap.addAll({"BODY": bodyJsonMap});

    detailLogJsonMap.addAll({"STATUS": response.statusCode}); // 真正的 statusCode

    Map<String, dynamic> responseMap;
    if (response.data is String) {
      // 后台把data按字符串返回的时候
      if ((response.data as String).isEmpty) {
        String responseDataString = "\'\'"; // 空字符串
        String errorMessage =
            "Error:请求$fullUrl后台response用字符串返回,且值为$responseDataString,该字符串却无法转成标准的由code+msg+result组成的map结构(目前发现于503时候)";
        responseMap = {
          'data': response.data,
          'lichaoqian_log': {
            "code": -1001,
            "msg": errorMessage,
          }
        };
      } else {
        responseMap = convert.jsonDecode(response.data);
      }
    } else {
      responseMap = response.data;
    }
    detailLogJsonMap.addAll({
      "RESPONSE_Class": response.data.runtimeType.toString(),
      "RESPONSE_Data": responseMap,
    });

    return detailLogJsonMap;
  }
}
