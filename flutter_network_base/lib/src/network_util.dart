import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import './bean/net_options.dart';
import './bean/err_options.dart';
import './bean/net_options_convert_util.dart';
import './network_bean.dart';
import './url/url_util.dart';

import './mock/local_mock_util.dart';

import './log/dio_log_util.dart';
import './cache/dio_cache_util.dart';
import 'bean/req_options.dart';
import 'bean/res_options.dart';

typedef JsonParse<T> = T Function(dynamic data);

class NetworkUtil {
  // 网络请求的最底层方法
  static Future<ResponseModel> requestUrl(
    Dio dio,
    String url, {
    RequestMethod requestMethod = RequestMethod.post,
    Map<String, dynamic>? customParams,
    Options? options,
    Map<String, dynamic> Function()?
        optionsHeaderCommonChangeParamsGetBlock, // header 中公共但会变的参数
    CancelToken? cancelToken,
    required CJNetworkClientGetSuccessResponseModelBlock
        getSuccessResponseModelBlock,
    required CJNetworkClientGetFailureResponseModelBlock
        getFailureResponseModelBlock,
    required CJNetworkClientGetDioErrorResponseModelBlock
        getDioErrorResponseModelBlock,
  }) async {
    if (url.startsWith(LocalMockUtil.localApiHost)) {
      String loaclFilePath = url.substring(LocalMockUtil.localApiHost.length);
      return LocalMockUtil.requestLocalFilePath(
        loaclFilePath,
        getSuccessResponseModelBlock: getSuccessResponseModelBlock,
      );
    }

    cancelToken ??= CancelToken();

      customParams ??= {};

      DioLogUtil.debugApiWithLog(url, "请求开始...");
      Response response;

    DateTime myRequestTime = DateTime.now();
      options ??= Options(
        receiveTimeout: dio.options.receiveTimeout,
        contentType: dio.options.contentType,
        headers: dio.options.headers,
      );
    options.extra ??= {};
    options.extra?.addAll({'requestStartTime': myRequestTime});

      if (options.headers != null) {
        if (optionsHeaderCommonChangeParamsGetBlock != null) {
          Map<String, dynamic> customHeaders =
              optionsHeaderCommonChangeParamsGetBlock();
          options.headers!.addAll(customHeaders);
        }
      }

    try {
      if (requestMethod == RequestMethod.post) {
        response = await dio.post(
          url,
          data: customParams,
          options: options,
          cancelToken: cancelToken,
        );
      } else {
        response = await dio.get(
          url,
          queryParameters: customParams,
          options: options,
          cancelToken: cancelToken,
        );
      }
      DioLogUtil.debugApiWithLog(url, "请求结束...");

      bool? isFromCache;
      if (DioCacheUtil.isCacheResponseCheckFunction != null) {
        isFromCache = DioCacheUtil.isCacheResponseCheckFunction!(response);
      }

      DioLogUtil.debugApiWithLog(url, "请求后解析开始...");
      late ResponseModel responseModel;
      // ①.fullUrl
      String fullUrl;
      if (url.startsWith(RegExp(r'https?:'))) {
        fullUrl = url;
      } else {
        fullUrl = UrlUtil.fullUrlFromDioResponse(response);
      }

      ResOptions resOptions = NetworkModelConvertUtil.newResponse(response);
      if (response.statusCode == 200) {
        responseModel = getSuccessResponseModelBlock(
          fullUrl,
          response.statusCode ?? HttpStatusCode.Unknow,
          response.data,
          isFromCache,
          resOptions: resOptions,
        );
      } else {
        responseModel = getFailureResponseModelBlock(
          fullUrl,
          response.statusCode ?? HttpStatusCode.Unknow,
          response.data,
          isFromCache,
          resOptions: resOptions,
        );
      }
      DioLogUtil.debugApiWithLog(url, "请求后解析结束...");
      return responseModel;
    } catch (e) {
      if (e is DioError == false) {
        String fullUrl = url;
        String errorMessage = e.toString();
        String message = '请求$fullUrl的时候，发生网络错误:$errorMessage';

        return ResponseModel.tryCatchErrorResponseModel(
          message,
          isCache: null,
          requestTime: myRequestTime,
          errorTime: DateTime.now(),
        );
      }

      DioError err = e as DioError;
      ErrOptions newErrorModel = NetworkModelConvertUtil.newError(err);

      // ①.fullUrl
      String fullUrl;
      if (url.startsWith(RegExp(r'https?:'))) {
        fullUrl = url;
      } else {
        fullUrl = UrlUtil.fullUrlFromDioError(err);
      }
      String baseUrl = err.requestOptions.baseUrl;
      if (baseUrl.isEmpty) {
        debugPrint(
            "NetworkError:请求完整路径$fullUrl失败，原因未完成baseUrl设置,请检查是否忘了执行NetworkManager.start的初始化调用.(附未设置baseUrl时候,任何dio拦截器都走不到");
      }

      // ②.isFromCache
      bool? isFromCache;
      if (DioCacheUtil.isCacheErrorCheckFunction != null) {
        isFromCache = DioCacheUtil.isCacheErrorCheckFunction!(err);
      }

      ErrOptions errOptions = NetworkModelConvertUtil.newError(err);
      // NetOptions netOptions = NetOptions(
      //   reqOptions: reqOptions,
      //   errOptions: errOptions,
      //   getSuccessResponseModelBlock: getSuccessResponseModelBlock,
      // );
      ResponseModel responseModel = getDioErrorResponseModelBlock(
        fullUrl,
        newErrorModel,
        isFromCache,
        errOptions: errOptions,
      );
      return responseModel;
    }
  }

  Future<T> updateFile<T>(
    Dio dio,
    String url,
    String fileName,
    File file,
    Map<String, dynamic> formData, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    JsonParse<T>? jsonParse,
  }) async {
    cancelToken ??= CancelToken();

    try {
      formData[fileName] =
          await MultipartFile.fromFile(file.path, filename: fileName);

      FormData data = FormData.fromMap(formData);

      Response response = await dio.post(
        url,
        data: data,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      if (response.statusCode == 200) {
        var err = response.data['err'];
        if (err is int && err == 0) {
          if (jsonParse != null) {
            return jsonParse(response.data["data"]);
          } else {
            return response.data["data"] ?? true;
          }
        } else {
          var data = response.data['data'];
          if (data != null) {
            // AppUtil.makeToast(LangUtil.l(data));
          } else {
            // AppUtil.makeToast("${response.data}");
          }

          return Future.error(response.data);
        }
      } else {
        throw Exception('后端接口出现异常');
      }
    } catch (e) {
      // AppUtil.makeToast("url:$url \nbody:${e.toString()}");
      throw Exception('网络错误:======>url:$url \nbody:${e.toString()}');
    }
  }

  Future<T> updateMultiFile<T>(
    Dio dio,
    String url,
    Map<String, dynamic> formData, {
    List<File>? files,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    JsonParse<T>? jsonParse,
  }) async {
    cancelToken ??= CancelToken();

    try {
      FormData data = FormData.fromMap(formData);
      if (files != null) {
        // List<MultipartFile> list = [];
        // for (File file in files) {
        //   list.add(
        //       await MultipartFile.fromFile(file.path, filename: "media.jpg"));
        // }
        // formData["files"] = list;

        for (File file in files) {
          data.files.add(MapEntry("files",
              MultipartFile.fromFileSync(file.path, filename: "file.jpg")));
        }
      }

      Response response = await dio.post(
        url,
        data: data,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      if (response.statusCode == 200) {
        var err = response.data['err'];
        if (err is int && err == 0) {
          if (jsonParse != null) {
            return jsonParse(response.data["data"]);
          } else {
            return response.data["data"] ?? true;
          }
        } else {
          var data = response.data['data'];
          if (data != null) {
            //AppUtil.makeToast(LangUtil.l(data));
          } else {
            // AppUtil.makeToast("${response.data}");
          }
          return Future.error(response.data);
        }
      } else {
        throw Exception('后端接口出现异常');
      }
    } catch (e) {
      // AppUtil.makeToast("${e.toString()}");
      throw Exception('网络错误:======>${e.toString()}');
    }
  }
}
