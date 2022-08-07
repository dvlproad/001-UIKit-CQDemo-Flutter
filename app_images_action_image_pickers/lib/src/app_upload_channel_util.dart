/*
 * @Author: dvlproad
 * @Date: 2022-06-20 18:46:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-08 01:38:58
 * @Description: 应用层网络上抽离的管理上传方法的类
 */
import 'package:app_images_action_image_pickers/app_images_action_image_pickers.dart';
import 'package:app_network/app_network.dart';
import 'package:flutter/foundation.dart'; // 为了使用  required
import 'package:flutter/services.dart';
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_network/src/bean/req_options.dart';
import 'package:flutter_network/src/bean/res_options.dart';
import 'package:flutter_network_kit/src/log/api_log_util.dart';
import 'dart:convert';

import './app_upload_bean.dart';

class AppNetworkKit_UploadChannelUtil {
  static Future<String?> uploadQCloud(
    String localPath, {
    UploadMediaType mediaType = UploadMediaType.unkonw,
  }) async {
    if (localPath == null) {
      return Future.value(null);
    }

    String originFileName = localPath.split('/').last;
    String fileExtensionType = localPath.split('.').last;
    originFileName = 'test.$fileExtensionType';
    if (mediaType == UploadMediaType.unkonw) {
      mediaType = getMediaType(localPath);
    }

    String bucket = "";
    if (mediaType == UploadMediaType.image) {
      bucket = "bjh-image-1302324914";
    } else {
      bucket = "bjh-media-1302324914";
    }
    String region = "ap-guangzhou";

    //获取腾讯云上传相关
    int startTime = 0; // 安卓会用到(搜 "bucket" 可以定位到)
    int expiredTime = 0; // 安卓会用到(搜 "bucket" 可以定位到)

    // 此处加判断的话
    ResponseModel responseModel =
        await AppNetworkKit.post("oos/getOosCredential", params: {
      "allowPrefix": ["wish/*"],
      "bucket": bucket,
      "durationSeconds": 1800,
      "region": "region"
    });
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

    int nowTime = DateTime.now().microsecondsSinceEpoch;
    String cosFileName = "${nowTime.toString()}_$originFileName";
    String cosPath = "wish/$cosFileName";

    return _uploadQCloud(
      localPath,
      mediaType,
      tencent_cos_credentials: tencent_cos_credentials,
      cosPath: cosPath,
      bucket: bucket,
      region: region,
      startTime: startTime,
      expiredTime: expiredTime,
    );
  }

  static Future<String?> _uploadQCloud(
    String localPath,
    UploadMediaType mediaType, {
    required Map<String, dynamic> tencent_cos_credentials,
    required String cosPath,
    required String bucket,
    required String region,
    required int startTime,
    required int expiredTime,
  }) {
    String secretId = tencent_cos_credentials["tmpSecretId"] ?? '';
    String secretKey = tencent_cos_credentials["tmpSecretKey"] ?? '';
    String sessionToken = tencent_cos_credentials["sessionToken"] ?? '';

    Map<String, dynamic> params = {
      "localPath": localPath,
      "appid": "1302324914",
      "region": "ap-guangzhou",
      "cosPath": cosPath,
      "bucket": bucket,
      "secretId": secretId,
      "secretKey": secretKey,
      "sessionToken": sessionToken,
      "startTime": "$startTime", // android 要用
      "expiredTime": "$expiredTime" // android 要用
    };

    NetOptions apiInfo = NetOptions(
      reqOptions: ReqOptions(
        baseUrl: 'tencent_cos',
        path: 'uploadFile',
        params: params,
      ),
      getSuccessResponseModelBlock:
          (String fullUrl, dynamic responseObject, bool? isCacheData) {
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
    return platform.invokeMethod('TencentCos.uploadFile', params).then((value) {
      apiInfo.resOptions = ResOptions(
        requestOptions: apiInfo.reqOptions,
        statusCode: 200,
        data: {
          "code": 0,
          "message": "成功",
          "result": value,
        },
      );
      LogApiUtil.logApiInfo(
        apiInfo,
        ApiProcessType.response,
        apiEnvInfo: apiEnvInfo,
      );

      if (value == "0") {
        String fullNetworkUrl;
        if (mediaType == UploadMediaType.image) {
          fullNetworkUrl = "$CosHostIMAGE$cosPath";
        } else if (mediaType == UploadMediaType.video) {
          fullNetworkUrl = "$CosHostVideo$cosPath";
        } else {
          fullNetworkUrl = "$CosHostVOICE$cosPath";
        }
        debugPrint("上传结果成功:fullNetworkUrl=$fullNetworkUrl");

        return fullNetworkUrl;
      } else {
        debugPrint("上传结果失败:value=$value");
        return null;
      }
    });
  }
}
