/*
 * @Author: dvlproad
 * @Date: 2022-05-18 15:06:49
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-08 00:56:49
 * @Description: TODO:此类 fromJson和toJson待补充进去
 */
import 'dart:ffi';

import 'package:photo_manager/photo_manager.dart' show AssetEntity;
import 'package:app_images_action_image_pickers/app_images_action_image_pickers.dart';

const String CosHostVOICE = "http://tape.xxx.com/";
const String CosHostIMAGE = "http://image.xxx.com/";
const String CosHostVideo = "http://tape.xxx.com/";

enum AppGalleryMode {
  ///选择图片
  image,

  ///选择视频
  video,
}

class AppImageBean {
  String? url; // 视频或图片地址
  int? width;
  int? height;

  AppImageBean({
    this.url,
    this.width,
    this.height,
  });
}

class AppImageChooseBean extends ImageChooseBean {
  int? fileType; // 文件类型(1-图片;2-视频)

  int? sortNo; //排序
  int? isMain; // 是否主图(0:否;1:是)
  String? materialFolderId;
  String? sId;
  //照片墙
  int? materialType;
  String? subType;
  String? materialName;
  String? materialUrl;
  int? size;
  int? isDelete;
  int? auditStatus;
  String? remark;
  String? createUserId;
  String? modifyUserId;
  int? createdAt;
  int? updatedAt;

  AppImageChooseBean({
    AssetEntity? assetEntity,
    String? networkUrl, // 图片的网络地址

    int? width, // 图片宽度
    int? height, // 图片高度

    this.fileType,
    this.sortNo,
    this.isMain,
    this.materialFolderId,
    this.sId,

    //照片墙
    this.materialType,
    this.subType,
    this.materialName,
    this.materialUrl,
    this.size,
    this.isDelete,
    this.auditStatus,
    this.remark,
    this.createUserId,
    this.modifyUserId,
    this.createdAt,
    this.updatedAt,
  }) : super(
          assetEntity: assetEntity,
          networkUrl: networkUrl,
          width: width,
          height: height,
        );

  bool get hasGetSize {
    return width != null && height != null && width! > 0 && height! > 0;
  }
}

enum UploadResultType {
  UploadSuccess, // 上传成功
  UploadFailure, // 上传失败
  UploadNone, // 不需要上传
}

class UploadResultBean {
  UploadResultType? uploadResultType;
  String? url;

  UploadResultBean({this.uploadResultType, this.url});
}
