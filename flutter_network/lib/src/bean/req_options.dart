/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-12 18:35:17
 * @Description: 请求Request信息模型
 */
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' show FormData;
import '../url/appendPathExtension.dart';

class ReqOptions {
  String? baseUrl;
  String path;

  String? method;
  String? contentType;
  late DateTime requestTime;
  Map<String, dynamic>? params;
  dynamic? data;
  Map<String, dynamic>? headers;

  bool? isRequestCache; // 是否是请求缓存数据(默认null，请求实际后台数据)

  ReqOptions({
    this.baseUrl,
    required this.path,
    this.method,
    this.contentType,
    this.headers,
    this.params,
    this.data,
    this.isRequestCache,
  }) {
    requestTime = DateTime.now();
  }

  /// generate uri
  Uri get uri {
    return Uri(
      host: baseUrl,
      path: path,
    );
    // var _url = path;
    // if (!_url.startsWith(RegExp(r'https?:'))) {
    //   _url = baseUrl + _url;
    //   var s = _url.split(':/');
    //   if (s.length == 2) {
    //     _url = s[0] + ':/' + s[1].replaceAll('//', '/');
    //   }
    // }
    // var query = Transformer.urlEncodeMap(queryParameters, listFormat);
    // if (query.isNotEmpty) {
    //   _url += (_url.contains('?') ? '&' : '?') + query;
    // }
    // // Normalize the url.
    // return Uri.parse(_url).normalizePath();
  }

  int get id {
    if (isRequestCache == true) {
      return this.uri.toString().hashCode;
    } else {
      return this.hashCode;
    }
    // response 和 error 的 id 都用 requestOptions 的 hashCode
    // int requestOptionsHashCode = DateTime.now().millisecondsSinceEpoch;
  }

  String get fullUrl {
    String url;
    if (path.startsWith(RegExp(r'https?:'))) {
      url = path;
    } else {
      if (baseUrl == null) {
        url = path;
      } else {
        url = baseUrl!.appendPathString(path);
      }
    }
    // url = this.uri.toString();

    return url;
  }

  Map<String, dynamic> get bodyJsonMap {
    // 参数params放Request模型的位置:GET请求时params中,POST请求时data中
    Map<String, dynamic> bodyJsonMap = {};
    final data = this.data;
    if (data != null) {
      if (data is Map) {
        bodyJsonMap = data as Map<String, dynamic>;
      } else if (data is FormData) {
        final formDataMap = Map()
          ..addEntries(data.fields)
          ..addEntries(data.files);

        bodyJsonMap = formDataMap as Map<String, dynamic>;
      } else {
        bodyJsonMap = {"string": data.toString()};
      }
    }

    return bodyJsonMap;
  }

  Map<String, dynamic> get detailLogJsonMap {
    Map<String, dynamic> detailLogJsonMap = {};

    ReqOptions options = this;

    bool? isRequestCache = options.isRequestCache;
    if (isRequestCache == true) {
      detailLogJsonMap.addAll({"isRealApi": "====此次api请求会去取缓存数据，而不是实际请求===="});
    }

    detailLogJsonMap.addAll({"URL": options.fullUrl});

    if (options.method != null) {}
    detailLogJsonMap.addAll({"METHOD": options.method ?? 'POST'});

    Map<String, dynamic>? headersMap = options.headers;
    if (headersMap != null) {
      detailLogJsonMap.addAll({"HEADER": headersMap});
    }

    if (options.method == "GET" && options.params != null) {
      detailLogJsonMap.addAll({"GET params": options.params});
    }

    Map<String, dynamic> bodyJsonMap = options.bodyJsonMap;
    detailLogJsonMap.addAll({"BODY": bodyJsonMap});

    return detailLogJsonMap;
  }
}
