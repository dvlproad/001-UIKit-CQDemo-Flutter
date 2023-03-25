// ignore_for_file: constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 11:45:14
 * @Description: 上传请求的各种参数获取
 */
import 'package:flutter_environment_base/flutter_environment_base.dart';
import 'package:flutter_image_process/flutter_image_process.dart';

class AppUploadArgumentUtil {
  static Map<String, dynamic> getUploadOssCustomParams(
      UploadMediaType mediaType) {
    TSEnvNetworkModel currentNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;
    // region
    String region = currentNetworkModel.cosParamModel.region;

    // bucket
    String bucket = "";
    if (mediaType == UploadMediaType.image) {
      bucket = currentNetworkModel.cosParamModel.bucket_image;
    } else {
      bucket = currentNetworkModel.cosParamModel.bucket_other;
    }

    // cosFilePrefix
    String cosFilePrefix = currentNetworkModel.cosParamModel.cosFilePrefix;

    Map<String, dynamic> customParams = {
      "allowPrefix": ['$cosFilePrefix/*'],
      "bucket": bucket,
      "durationSeconds": 1800,
      "region": region,
    };

    return customParams;
  }

  static Map<String, dynamic> getUploadActionCustomParams(
    String localPath,
    UploadMediaType mediaType, {
    required String cosPath, // 断点续传时候，使用之前的值
    String? uploadId,
  }) {
    TSEnvNetworkModel currentNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;

    // bucket
    String bucket = "";
    if (mediaType == UploadMediaType.image) {
      bucket = currentNetworkModel.cosParamModel.bucket_image;
    } else {
      bucket = currentNetworkModel.cosParamModel.bucket_other;
    }

    Map<String, dynamic> customParams = {
      "localPath": localPath,
      "cosPath": cosPath,
      "bucket": bucket,
      "uploadId": uploadId,
    };

    return customParams;
  }

  static String getUploadToCosFileRelativePath({
    required String cosFilePrefix,
    required String localPath,
    UploadMediaType mediaType = UploadMediaType.unkonw,
    // 应用层信息的获取
    required String Function() uidGetBlock,
  }) {
    String uid = uidGetBlock();

    String fileOriginNameAndExtensionType = localPath.split('/').last;

    // String str = " Hello Word! ";
    RegExp regExp = RegExp(r"\s+\b|\b\s"); // 去除字符串中的所有空格
    fileOriginNameAndExtensionType =
        fileOriginNameAndExtensionType.replaceAll(regExp, "");

    /*
      String fileExtensionType = fileOriginNameAndExtensionType.split('.').last;
      String fileOriginName = fileOriginNameAndExtensionType.substring(
          0, fileOriginNameAndExtensionType.length - fileExtensionType.length);
      fileOriginNameAndExtensionType = 'test.$fileExtensionType';
      */

    int nowTime = DateTime.now().microsecondsSinceEpoch;
    String cosFileName = nowTime.toString();
    cosFileName += "_$fileOriginNameAndExtensionType";

    // 头
    String cosPath = cosFilePrefix;

    // 类别
    if (mediaType == UploadMediaType.image) {
      // 图片有自己的桶
    } else {
      // 视频、音频共用一个桶，需要再区分
      if (mediaType == UploadMediaType.audio) {
        cosPath += "/audio";
      } else if (mediaType == UploadMediaType.video) {
        cosPath += "/video";
      } else {
        cosPath += "/other";
      }
    }

    // 用户1级
    int uidMode = int.parse(uid) % 1000; // 取余数
    cosPath += "/$uidMode";
    // 用户2级
    cosPath += "/$uid";

    // 年月
    String dirTime = DateTime.now().toString().substring(0, 7);
    cosPath += "/$dirTime";

    // 文件名
    cosPath += "/$cosFileName";

    return cosPath;
  }

  static String getUploadResultCosFileUrlPrefix(UploadMediaType mediaType) {
    TSEnvNetworkModel currentNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;
    if (mediaType == UploadMediaType.image) {
      return currentNetworkModel.cosParamModel.cosFileUrlPrefix_image;
    } else if (mediaType == UploadMediaType.video) {
      return currentNetworkModel.cosParamModel.cosFileUrlPrefix_video;
    } else if (mediaType == UploadMediaType.audio) {
      return currentNetworkModel.cosParamModel.cosFileUrlPrefix_audio;
    } else {
      return currentNetworkModel.cosParamModel.cosFileUrlPrefix_image;
    }
  }
}
