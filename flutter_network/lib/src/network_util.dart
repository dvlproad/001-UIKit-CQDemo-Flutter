import 'dart:async';
import 'dart:io';
import 'dart:convert' show json;
import 'dart:convert' as convert;

import 'package:dio/dio.dart';

import './network_bean.dart';
import './url/url_util.dart';

import './network_client.dart';
import './sp_util.dart';
import './lang_util.dart';

import './network_client.dart';
import './mock/mock_analy_util.dart';
import './mock/local_mock_util.dart';

import './interceptor/interceptor_log.dart';

typedef T JsonParse<T>(dynamic data);

class NetworkUtil {
  static String localApiHost = "local_api_json_file";
  static void postUrl<T>(
    url, {
    Map<String, dynamic> customParams,
    cancelToken,
    Options options,
    void Function(dynamic resultMap) onSuccess,
    void Function(String failureMessage) onFailure,
  }) {
    postRequestUrl(
      url,
      customParams: customParams,
      options: options,
      cancelToken: cancelToken,
    ).then((ResponseModel responseModel) {
      int errorCode = responseModel.statusCode;
      if (errorCode == 0) {
        if (onSuccess != null) {
          onSuccess(responseModel.result);
        }
      } else {
        if (onFailure != null) {
          onFailure(responseModel.message);
        }
      }
    });
  }

  static Future<ResponseModel> postRequestUrl(
    String url, {
    Map<String, dynamic> customParams,
    Options options,
    cancelToken,
  }) async {
    return _requestUrl(
      url,
      requestMethod: RequestMethod.post,
      customParams: customParams,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future<ResponseModel> getRequestUrl(
    url, {
    Map<String, dynamic> customParams,
    Options options,
    cancelToken,
  }) async {
    return _requestUrl(
      url,
      requestMethod: RequestMethod.get,
      customParams: customParams,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // 网络请求的最底层方法
  static Future<ResponseModel> _requestUrl(
    String url, {
    RequestMethod requestMethod,
    Map<String, dynamic> customParams,
    Options options,
    CancelToken cancelToken,
  }) async {
    await NetworkManager().initCompleter.future;
    // while (NetworkManager().hasStart == false) {
    //   print('NetworkManager:初始化未完成，等待中...');
    //   // sleep(Duration(milliseconds: 3500));
    //   await Future.delayed(Duration(milliseconds: 500));
    // }
    //print('NetworkManager:初始化已完成，开始进行请求');

    if (url.startsWith(localApiHost)) {
      String loaclFilePath = url.substring(localApiHost.length);
      return LocalMockUtil.requestLocalFilePath(loaclFilePath);
    }

    if (cancelToken == null) {
      cancelToken = CancelToken();
    }

    try {
      if (customParams == null) {
        customParams = {};
      }
      String sessionID = await SpUtil().getAccountSessionID();
      if (sessionID != null && sessionID.length > 0) {
        customParams['sessionID'] = sessionID;
      }

      Dio dio = NetworkManager.instance.serviceDio;

      Response response;
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

      bool isFromCache = false;
      if (DioLogInterceptor.isCacheResponseCheckFunction != null) {
        isFromCache = DioLogInterceptor.isCacheResponseCheckFunction(response);
      }

      if (response.statusCode == 200) {
        dynamic responseObject;
        if (response.data is String) {
          // 后台把data按字符串返回的时候
          responseObject = convert.jsonDecode(response.data);
        } else {
          //String dataString = response.data.toString();
          String dataJsonString = convert.jsonEncode(response.data);
          responseObject = convert.jsonDecode(dataJsonString);
        }

        Map<String, dynamic> responseMap;

        bool isMockEnvironment = MockAnalyUtil.isMockEnvironment(url);
        if (isMockEnvironment == true) {
          // 是模拟的环境，不是本项目
          responseMap = MockAnalyUtil.responseMapFromMock(responseObject, url);
        } else {
          responseMap = responseObject;
        }

        var errorCode = responseMap['code'];
        var msg = responseMap['msg'];
        dynamic result = responseMap["data"];
        ResponseModel responseModel = ResponseModel(
          statusCode: errorCode,
          message: msg,
          result: result,
          isCache: isFromCache,
        );
        return responseModel;
      } else {
        String errorMessage = '后端接口出现异常';
        String message = '请求$url的时候，发生网络错误:$errorMessage';
        ResponseModel responseModel = ResponseModel(
          statusCode: -500,
          message: message,
          result: null,
          isCache: isFromCache,
        );
        return responseModel;
      }
    } catch (e) {
      String errorMessage = e.toString();

      String fullUrl;
      if (url.startsWith(RegExp(r'https?:'))) {
        fullUrl = url;
      } else {
        if (e is DioError) {
          DioError err = e;
          fullUrl = UrlUtil.fullUrlFromDioError(err);

          String baseUrl = err.requestOptions.baseUrl;
          if (baseUrl.isEmpty) {
            print(
                "NetworkError:请求完整路径$fullUrl失败，原因未完成baseUrl设置,请检查是否忘了执行NetworkManager.start的初始化调用.(附未设置baseUrl时候,任何dio拦截器都走不到");
          }

          if (err.message.isNotEmpty) {
            errorMessage = err.message;
            if (err.type == DioErrorType.connectTimeout) {
              // errorMessage = '请求超时';
            }
          }
        } else {
          fullUrl = url;
        }
      }

      String message = '请求$fullUrl的时候，发生网络错误:$errorMessage';
      return ResponseModel.errorResponseModel(message);
    }
  }

  Future<T> updateFile<T>(
      url, String fileName, File file, Map<String, dynamic> formData,
      {cancelToken,
      ProgressCallback onSendProgress,
      JsonParse<T> jsonParse}) async {
    if (cancelToken == null) {
      cancelToken = CancelToken();
    }

    try {
      if (file != null) {
        formData[fileName] =
            await MultipartFile.fromFile(file.path, filename: fileName);
      }

      String sessionID = await SpUtil().getAccountSessionID();
      if (sessionID != null && sessionID.length > 0) {
        formData['sessionID'] = sessionID;
      }

      FormData data = FormData.fromMap(formData);

      Dio dio = NetworkManager.instance.serviceDio;
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

  Future<T> updateMultiFile<T>(url, Map<String, dynamic> formData,
      {List<File> files,
      cancelToken,
      ProgressCallback onSendProgress,
      JsonParse<T> jsonParse}) async {
    if (cancelToken == null) {
      cancelToken = CancelToken();
    }

    try {
      String sessionID = await SpUtil().getAccountSessionID();
      if (sessionID != null && sessionID.length > 0) {
        formData['sessionID'] = sessionID;
      }

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

      Dio dio = NetworkManager.instance.serviceDio;
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
