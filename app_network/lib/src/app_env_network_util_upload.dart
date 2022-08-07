/*
 * @Author: dvlproad
 * @Date: 2022-06-20 18:46:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-20 00:32:06
 * @Description: 应用层网络上抽离的管理上传方法的类
 */
import 'package:flutter/foundation.dart'; // 为了使用 required
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:tencent_cos/tencent_cos.dart';
import 'dart:convert';

import './app_env_network_util.dart';
import './app_response_model_util.dart';
import './app_api_simulate_util.dart';

class AppNetworkKit_UploadUtil {
  static Future<String?> uploadQCloud(
    String localPath, {
    bool isImage = true,
  }) async {
    if (localPath == null) {
      return Future.value(null);
    }
    String bucket = "";
    if (isImage) {
      bucket = "bjh-image-1302324914";
    } else {
      bucket = "bjh-media-1302324914";
    }
    String region = "ap-guangzhou";

    //获取腾讯云上传相关
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
    }

    if (tencent_cos_credentials == null) {
      return Future.value(null);
    }

    String originFileName = localPath.split('/').last;
    String fileExtensionType = localPath.split('.').last;
    originFileName = 'test.$fileExtensionType';

    int nowTime = DateTime.now().microsecondsSinceEpoch;
    String cosFileName = "${nowTime.toString()}_$originFileName";
    String cosPath = "wish/$cosFileName";

    return _uploadQCloud(
      localPath,
      tencent_cos_credentials,
      cosPath: cosPath,
      bucket: bucket,
      region: region,
    );
  }

  static Future<String?> _uploadQCloud(
    String localPath,
    Map<String, dynamic> tencent_cos_credentials, {
    required String cosPath,
    required String bucket,
    required String region,
  }) {
    String secretId = tencent_cos_credentials["tmpSecretId"];
    String secretKey = tencent_cos_credentials["tmpSecretKey"];
    String sessionToken = tencent_cos_credentials["sessionToken"];

    return COSClient(COSConfig(
      secretId,
      secretKey,
      bucket,
      region,
    )).putObject(cosPath, localPath, token: sessionToken);
  }
}
