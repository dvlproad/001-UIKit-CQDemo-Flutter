/*
 * @Author: dvlproad
 * @Date: 2022-06-20 18:46:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 23:03:36
 * @Description: 应用层网络上抽离的管理上传方法的类
 */
import 'dart:convert';
import 'package:flutter/foundation.dart'; // 为了使用 required
import 'package:flutter/services.dart';
import 'package:flutter_network_base/flutter_network_base.dart';
import 'package:flutter_network_base/src/bean/req_options.dart';
import 'package:flutter_network_base/src/bean/res_options.dart';
import 'package:flutter_network_kit/src/log/api_log_util.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_image_process/flutter_image_process.dart';
import '../app_network/app_network_manager.dart';
import '../app_env_network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './app_upload_bean.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:collection';
import 'dart:io';

extension UploadByChannel on AppNetworkManager {
  Future<String?> channel_uploadQCloud(
    String localPath,
    bool multipart, {
    UploadMediaType mediaType = UploadMediaType.unkonw,
    void Function({required double progressValue})? uploadProgress, // 上传进度监听
    // required void Function(String mediaUrl) uploadSuccess,
    // required void Function() uploadFailure,
  }) async {
    if (localPath == null) {
      return Future.value(null);
    }

    if (mediaType == UploadMediaType.unkonw) {
      mediaType = getMediaType(localPath);
    }

    String bucket = bucketGetFunction(mediaType);
    String region = regionGetFunction();
    String cosFilePrefix = cosFilePrefixGetFunction();
    String cosPath;
    String? uploadId;
    if (multipart) {
      final sharedPreferences = await SharedPreferences.getInstance();
      final uploadIdStr =
          sharedPreferences.getString("multipart.uploadId") ?? "{}";
      final Map map = json.decode(uploadIdStr);
      final cacheDir = (await getApplicationDocumentsDirectory()).path;
      String key = localPath.split("/").last;
      final id = map[key];
      if (id != null) {
        uploadId = id.toString();
        debugPrint("找到未上传完uploadId: $uploadId");
        cosPath = map["cos_$key"];
      } else {
        cosPath = cosFileRelativePathGetFunction(
          localPath,
          mediaType: mediaType,
        );
      }
    } else {
      cosPath = cosFileRelativePathGetFunction(
        localPath,
        mediaType: mediaType,
      );
      await initQCloudCredential(mediaType);
    }

    return _channel_uploadQCloud(
      localPath,
      multipart,
      mediaType,
      cosPath: cosPath,
      bucket: bucket,
      uploadId: uploadId,
      region: region,
      uploadProgress: uploadProgress,
      // uploadSuccess: uploadSuccess,
      // uploadFailure: uploadFailure,
    );
  }

  Future<bool> hasBreakPoint(String localPath) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final uploadIdStr =
        sharedPreferences.getString("multipart.uploadId") ?? "{}";
    final Map map = json.decode(uploadIdStr);
    final cacheDir = (await getApplicationDocumentsDirectory()).path;
    String key;
    if (localPath.startsWith(cacheDir)) {
      key = localPath.replaceAll(cacheDir, "");
    } else {
      key = localPath;
    }
    return map["hasBreakPoint$key"] ?? false;
  }

  Future initQCloudCredential(UploadMediaType mediaType) async {
    //获取腾讯云上传相关
    int startTime = 0; // 安卓会用到(搜 "bucket" 可以定位到)
    int expiredTime = 0; // 安卓会用到(搜 "bucket" 可以定位到)
    // 此处加判断的话
    final cosFilePrefix = cosFilePrefixGetFunction();
    final bucket = bucketGetFunction(mediaType);
    final region = regionGetFunction();
    ResponseModel responseModel = await AppNetworkKit.post(
      "oos/getOosCredential",
      params: {
        "allowPrefix": ['${cosFilePrefix}/*'],
        "bucket": bucket,
        "durationSeconds": 1800,
        "region": region,
      },
    );

    Map<String, dynamic>? tencent_cos_credentials;
    if (responseModel.isSuccess) {
      Map map = json.decode(responseModel.result);
      tencent_cos_credentials = map["credentials"];

      startTime = map["startTime"];
      expiredTime = map["expiredTime"];
    }

    if (tencent_cos_credentials == null) {
      return Future.value(null);
    }
    const platform = MethodChannel('tencent_cos');
    final map = HashMap<String, String>();
    map["secretKey"] = tencent_cos_credentials["tmpSecretKey"];
    map["sessionToken"] = tencent_cos_credentials["sessionToken"];
    map["secretId"] = tencent_cos_credentials["tmpSecretId"];
    map["startTime"] = startTime.toString();
    map["appid"] = "1302324914";
    map["region"] = region;
    map["expiredTime"] = expiredTime.toString();
    await platform.invokeMethod("TencentCos.multipart.credential", map);
  }

  Future<String?> _channel_uploadQCloud(
    String localPath,
    bool multipart,
    UploadMediaType mediaType, {
    required String cosPath,
    String? uploadId,
    required String bucket,
    required String region,
    void Function({required double progressValue})? uploadProgress, // 上传进度监听
    // required void Function(String mediaUrl) uploadSuccess,
    // required void Function() uploadFailure,
  }) async {
    Map<String, dynamic> params = {
      "localPath": localPath,
      "cosPath": cosPath,
      "bucket": bucket,
      "uploadId": uploadId,
      "cosPath": cosPath,
    };
    NetOptions apiInfo = NetOptions(
      reqOptions: ReqOptions(
        baseUrl: 'tencent_cos',
        path: 'uploadFile',
        // params: params,
        method: 'POST',
        data: params, // 参数params放Request模型的位置:GET请求时params中,POST请求时data中
      ),
      getSuccessResponseModelBlock: (String fullUrl, int statusCode,
          dynamic responseObject, bool? isCacheData) {
        return ResponseModel(
          statusCode: responseObject["code"],
          message: responseObject["message"],
          result: responseObject["result"],
        );
      },
    );

    ApiEnvInfo apiEnvInfo = ApiEnvInfo(
      serviceValidProxyIp: AppNetworkManager().serviceValidProxyIp,
    );
    LogApiUtil.logApiInfo(
      apiInfo,
      ApiProcessType.request,
      apiEnvInfo: apiEnvInfo,
    );
    const platform = MethodChannel('tencent_cos');

    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onProgress') {
        Map data = call.arguments;
        double progress = data['progress'];
        print('progress = $progress');
        if (uploadProgress != null) {
          uploadProgress(progressValue: progress);
        }
      } else if (call.method == "multiPartProgress") {
        Map data = call.arguments;
        dynamic percent = data['percent'];
        double progress;
        if (percent is int) {
          progress = percent.toDouble();
        } else {
          progress = percent;
        }
        print('progress = $progress');
        if (uploadProgress != null) {
          uploadProgress(progressValue: progress);
        }
      }
    });
    return platform
        .invokeMethod(
            multipart
                ? "TencentCos.multipart.uploadFile"
                : "TencentCos.uploadFile",
            params)
        .then((value) {
      int errorCode = 0;
      if (value["errorCode"] is String) {
        errorCode = int.parse(value["errorCode"] as String);
      } else {
        errorCode = value["errorCode"];
      }

      apiInfo.resOptions = ResOptions(
        requestOptions: apiInfo.reqOptions,
        statusCode: 200,
        data: {
          "code": errorCode,
          "message": errorCode == 0 ? "上传成功" : "上传失败",
          "result": value,
        },
      );
      LogApiUtil.logApiInfo(
        apiInfo,
        ApiProcessType.response,
        apiEnvInfo: apiEnvInfo,
      );

      if (errorCode == 0) {
        String cosFileUrlPrefix = cosFileUrlPrefixGetFunction(mediaType);
        String fullNetworkUrl = "$cosFileUrlPrefix$cosPath";
        debugPrint("上传结果成功:fullNetworkUrl=$fullNetworkUrl");

        // uploadSuccess(fullNetworkUrl);
        return fullNetworkUrl;
      } else {
        debugPrint("上传结果失败:value=$value");
        // uploadFailure();
        return null;
      }
    });
  }
}
