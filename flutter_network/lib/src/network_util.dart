import 'package:dio/dio.dart';
import 'dart:io';

import './network_client.dart';
import './log_util.dart';
import './sp_util.dart';
import './lang_util.dart';

import 'dart:convert' as convert;

import './network_client.dart';

typedef T JsonParse<T>(dynamic data);

class ResponseModel {
  int statusCode;
  String message;
  dynamic result;

  ResponseModel(this.statusCode, this.message, this.result);
}

class NetworkUtil {
  static void postUrl<T>(
    url, {
    Map<String, dynamic> formData,
    cancelToken,
    void Function(dynamic resultMap) onSuccess,
    void Function(String failureMessage) onFailure,
  }) {
    postRequestUrl(url, formData: formData, cancelToken: cancelToken)
        .then((ResponseModel responseModel) {
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
    Map<String, dynamic> formData,
    cancelToken,
  }) async {
    if (cancelToken == null) {
      cancelToken = CancelToken();
    }
    LogUtil.v("请求：" + formData.toString());
    try {
      Response response;
      if (formData == null) {
        formData = {};
      }
      String sessionID = await SpUtil().getAccountSessionID();
      if (sessionID != null && sessionID.length > 0) {
        formData['sessionID'] = sessionID;
      }

      Dio dio = NetworkManager.instance.serviceDio;
      response = await dio.post(url, data: formData, cancelToken: cancelToken);
      LogUtil.v("回复：" + response.data.toString());

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
        Map<String, dynamic> result = responseMap["data"];
        ResponseModel responseModel = ResponseModel(errorCode, msg, result);
        return responseModel;
      } else {
        throw Exception('后端接口出现异常');
      }
    } catch (e) {
      // AppUtil.makeToast("url:$url \nbody:${e.toString()}");
      throw Exception('网络错误:======>url:$url \nbody:${e.toString()}');
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
