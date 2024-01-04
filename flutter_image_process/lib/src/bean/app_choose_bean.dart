/*
 * @Author: dvlproad
 * @Date: 2022-05-18 15:06:49
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-04 14:52:44
 * @Description: 
 */
import 'package:photo_manager/photo_manager.dart' show AssetEntity;
import './image_choose_bean.dart';

// class AppImageBean {
//   String url; // 视频或图片地址
//   int width;
//   int height;

//   AppImageBean({
//     this.url,
//     this.width,
//     this.height,
//   });
// }

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

  AppImageChooseBean.fromJson(Map<String, dynamic> json) {
    ImageChooseBean baseBean = ImageChooseBean.fromJson(json);
    compressImageBean = baseBean.compressImageBean;
    compressVideoBean = baseBean.compressVideoBean;
    videoDuration = baseBean.videoDuration;
    frameDuration = baseBean.frameDuration;
    assetEntity = baseBean.assetEntity;

    networkUrl = baseBean.networkUrl;
    networkThumbnailUrl = baseBean.networkThumbnailUrl;
    width = baseBean.width;
    height = baseBean.height;

    sId = json['_id'];
    materialFolderId = json["material_folder_id"];
    fileType = json["fileType"];

    sortNo = json["sortNo"];
    isMain = json["isMain"];
  }
  //用于照片墙处理
  AppImageChooseBean.fromUserJson(Map<String, dynamic> json) {
    assetEntity = null;
    sId = json['_id'];
    materialFolderId = json["material_folder_id"];
    fileType = json["fileType"];
    networkUrl = json["material_url"];
    width = json["width"];
    height = json["height"];
    sortNo = json["sort_no"];
    isMain = json["isMain"];
    sId = json['_id'];
    materialFolderId = json['material_folder_id'];
    materialType = json['material_type'];
    subType = json['sub_type'];
    materialName = json['material_name'];
    size = json['size'];
    isDelete = json['is_delete'];
    auditStatus = json['audit_status'];
    remark = json['remark'];
    createUserId = json['create_user_id'];
    modifyUserId = json['modify_user_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    if (fileType != null) {
      data["fileType"] = fileType;
    }
    if (sortNo != null) {
      data["sortNo"] = sortNo;
    }
    if (isMain != null) {
      data["isMain"] = isMain;
    }

    data['_id'] = sId;
    data["material_folder_id"] = materialFolderId;
    return data;
  }

  bool get hasGetSize {
    return width != null && height != null && width! > 0 && height! > 0;
  }
}
