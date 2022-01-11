import 'package:dio/dio.dart';
import 'dart:io';

import 'package:flutter_log/flutter_log.dart';

import './network_client.dart';
import './sp_util.dart';
import './lang_util.dart';

import 'dart:convert' as convert;

import './network_client.dart';

typedef T JsonParse<T>(dynamic data);

class ResponseModel {
  int statusCode;
  String message;
  dynamic result;

  ResponseModel({this.statusCode, this.message, this.result});
}

enum RequestMethod {
  post,
  get,
}

class NetworkUtil {
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
    url, {
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

  static Future<ResponseModel> _requestUrl(
    url, {
    RequestMethod requestMethod,
    Map<String, dynamic> customParams,
    Options options,
    cancelToken,
  }) async {
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

      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap;
        if (response.data is String) {
          // 后台把data按字符串返回的时候
          responseMap = convert.jsonDecode(response.data);
        } else {
          //String dataString = response.data.toString();
          String dataJsonString = convert.jsonEncode(response.data);
          responseMap = convert.jsonDecode(dataJsonString);
        }

        var errorCode = responseMap['code'];
        var msg = responseMap['msg'];
        dynamic result = responseMap["data"];
        ResponseModel responseModel = ResponseModel(
          statusCode: errorCode,
          message: msg,
          result: result,
        );
        return responseModel;
      } else {
        String errorMessage = '后端接口出现异常';
        String message = '请求$url的时候，发生网络错误:$errorMessage';
        ResponseModel responseModel = ResponseModel(
          statusCode: -500,
          message: message,
          result: null,
        );
        return responseModel;
      }
    } catch (e) {
      String errorMessage = e.toString();
      String message = '请求$url的时候，发生网络错误:$errorMessage';
      LogUtil.v("请求失败的异常：" + message);
      ResponseModel responseModel = ResponseModel(
        statusCode: -1,
        message: message,
        result: null,
      );
      return responseModel;
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
