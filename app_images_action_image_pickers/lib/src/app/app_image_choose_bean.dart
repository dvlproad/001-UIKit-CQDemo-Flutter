/*
 * @Author: dvlproad
 * @Date: 2024-03-29 11:24:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-29 14:46:56
 * @Description: 
 */
import 'package:flutter_image_process/flutter_image_process.dart';

enum AddCellType {
  defalut_add, // ➕图片
  image_only_default, // 拍照图片(使用于愿望单创建)
  image_only_default_for_publish_wish, // 拍照图片(使用于愿望动态创建)
  image_text_default, // 图片+"添加照片"文字(使用于愿望单创建)
  image_text_for_user_photos, // 图片+"添加照片"文字(使用于个人主页照片墙)
  image_text_for_refund, //申请退款样式
  image_text_for_evaluate, //商品评价
}

class AppImageChooseBean extends ImageChooseBean {
  String? sId;

  AppImageChooseBean({
    AssetEntity? assetEntity,
    String? networkUrl, // 图片的网络地址

    int? width, // 图片宽度
    int? height, // 图片高度
    this.sId,
  }) : super(
          assetEntity: assetEntity,
          networkUrl: networkUrl,
          width: width,
          height: height,
        );

  AppImageChooseBean.fromJson(Map<String, dynamic> json) {
    ImageChooseBean baseBean = ImageChooseBean.fromJson(json);
    videoDuration = baseBean.videoDuration;
    frameDuration = baseBean.frameDuration;
    assetEntity = baseBean.assetEntity;

    networkUrl = baseBean.networkUrl;
    networkThumbnailUrl = baseBean.networkThumbnailUrl;
    width = baseBean.width;
    height = baseBean.height;

    sId = json['_id'];
  }
  //用于照片墙处理
  AppImageChooseBean.fromUserJson(Map<String, dynamic> json) {
    assetEntity = null;
    sId = json['_id'];
    networkUrl = json["material_url"];
    width = json["width"];
    height = json["height"];
    sId = json['_id'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();

    return data;
  }
}
