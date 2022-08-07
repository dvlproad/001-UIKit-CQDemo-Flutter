import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app_images_action_image_pickers/app_images_action_image_pickers.dart'
    show
        ImageChooseBean,
        ImageCompressBean,
        CompressInfoProcess,
        ImageInfoBean,
        UploadMediaType;
// import 'package:app_info_choose_kit/app_info_choose_kit.dart' show VoiceBean;
import './voice_bean.dart' show VoiceBean;
import 'package:app_network/app_network.dart' show AppNetworkKit_UploadUtil;
import 'package:flutter_effect/flutter_effect.dart' show ToastUtil;
import './app_upload_channel_util.dart';

import './app_upload_bean.dart';

enum UploadMediaResultType {
  UploadSuccess, // 上传成功
  ImageFailureBCThumbnailGet, // 缩略图片：获取失败
  ImageFailureBCThumbnailUpload, // 缩略图片：上传失败
  VideoFailureBCThumbnailSelfGet, // 缩略视频:获取失败
  VideoFailureBCThumbnailSelfUpload, // 缩略视频:上传失败
  VideoFailureBCThumbnailImageGet, // 视频缩略图:获取失败
  VideoFailureBCThumbnailImageUpload, // 视频缩略图:上传失败
}

class UploadApiUtil {
  static Future<bool> uploadVoiceModel({
    required BuildContext context,
    required VoiceBean voiceModel,
  }) async {
    bool isNetworkVoice = voiceModel.networkUrl != null;
    if (isNetworkVoice == true) {
      return true;
    }

    String? voicePath = voiceModel.localPath;
    if (voicePath == null) {
      return false;
    }
    UploadResultBean uploadResultBean =
        await _uploadLocalVoicePath(voicePath: voicePath);

    if (uploadResultBean.uploadResultType == UploadResultType.UploadSuccess) {
      voiceModel.networkUrl = uploadResultBean.url;
      return true;
    } else {
      ToastUtil.showMsg("抱歉！语音上传失败！", context);
      return false;
    }
  }

  // static Future<List<AppImageBean>> uploadMedias({
  //   BuildContext context,
  //   List<Media> medias,
  // }) async {}

  // static void getWidthAndHeight(List<Media> bMediaList) async {
  //   for (var media in bMediaList) {
  //     String imagePath = media.path;
  //     Image image = Image(
  //       image: AssetImage(imagePath),
  //     );

  //     ImageProvider<Object> imageProvider = image.image;
  //     Map<String, dynamic> imageWithHeight =
  //         await getWidthAndHeight(imageProvider);
  //   }
  // }

  static String getUploadMediaResultTypeString(
      UploadMediaResultType resultType) {
    switch (resultType) {
      case UploadMediaResultType.ImageFailureBCThumbnailGet:
        return "图片压缩失败";
        break;
      case UploadMediaResultType.ImageFailureBCThumbnailUpload:
        return "图片上传失败";
        break;
      case UploadMediaResultType.VideoFailureBCThumbnailSelfGet:
        return "视频压缩失败";
        break;
      case UploadMediaResultType.VideoFailureBCThumbnailSelfUpload:
        return "视频上传失败";
        break;
      case UploadMediaResultType.VideoFailureBCThumbnailImageGet:
        return "视频缩略图获取失败";
        break;
      case UploadMediaResultType.VideoFailureBCThumbnailImageUpload:
        return "视频缩略图上传失败";
        break;
      default:
        return "上传成功";
    }
  }

  static Future<UploadMediaResultType> uploadImageChooseModels({
    required BuildContext context,
    required List<ImageChooseBean> imageChooseModels,
    required UploadMediaType mediaType,
  }) async {
    // 串行
    for (ImageChooseBean imageChooseModel in imageChooseModels) {
      bool isNetworkImage = imageChooseModel.networkUrl != null;
      if (isNetworkImage == true) {
        continue;
      }

      if (imageChooseModel.mediaType == UploadMediaType.video) {
        /// 视频
        String? uploadVideoPath =
            await imageChooseModel.lastUploadThumbnailVideoPath();
        if (uploadVideoPath == null) {
          return UploadMediaResultType.VideoFailureBCThumbnailSelfGet;
        }
        UploadResultBean uploadVideoResultBean = await _uploadLocalMediaPath(
          context: context,
          mediaPath: uploadVideoPath,
          mediaType: mediaType,
        );
        if (uploadVideoResultBean.uploadResultType !=
            UploadResultType.UploadSuccess) {
          return UploadMediaResultType.VideoFailureBCThumbnailSelfUpload;
        }
        imageChooseModel.networkUrl = uploadVideoResultBean.url;

        /// 视频的缩略图
        String? uploadVideoThumbnailImagePath =
            await imageChooseModel.lastUploadThumbnailImagePath();
        if (uploadVideoThumbnailImagePath == null) {
          return UploadMediaResultType.VideoFailureBCThumbnailImageGet;
        }
        UploadResultBean uploadVideoThumbnailImageResultBean =
            await _uploadLocalMediaPath(
          context: context,
          mediaPath: uploadVideoThumbnailImagePath,
          mediaType: UploadMediaType.image,
        );
        if (uploadVideoThumbnailImageResultBean.uploadResultType !=
            UploadResultType.UploadSuccess) {
          return UploadMediaResultType.VideoFailureBCThumbnailImageUpload;
        }
        imageChooseModel.networkThumbnailUrl =
            uploadVideoThumbnailImageResultBean.url;
      } else if (imageChooseModel.mediaType == UploadMediaType.image) {
        // 图片本身
        String? uploadImageThumbnailImagePath =
            await imageChooseModel.lastUploadThumbnailImagePath();
        if (uploadImageThumbnailImagePath == null) {
          return UploadMediaResultType.ImageFailureBCThumbnailGet;
        }
        UploadResultBean uploadImageThumbnailImageResultBean =
            await _uploadLocalMediaPath(
          context: context,
          mediaPath: uploadImageThumbnailImagePath,
          mediaType: UploadMediaType.image,
        );

        if (uploadImageThumbnailImageResultBean.uploadResultType !=
            UploadResultType.UploadSuccess) {
          return UploadMediaResultType.ImageFailureBCThumbnailUpload;
        }
        imageChooseModel.networkUrl = uploadImageThumbnailImageResultBean.url;
      }
    }

    return UploadMediaResultType.UploadSuccess;

    // 并发
    /*
    List<Future> futures = [];
    List<ImageChooseBean> needUploadImageChooseModel = [];
    for (ImageChooseBean imageChooseModel in imageChooseModels) {
      bool isNetworkImage = imageChooseModel.networkUrl != null;
      if (isNetworkImage == true) {
        continue;
      }

      needUploadImageChooseModel.add(imageChooseModel);
      String imagePath = imageChooseModel.localPath;
      Future<UploadResultBean> future =
          _uploadLocalImage(context: context, imagePath: imagePath);
      futures.add(future);
    }

    int needUploadCount = needUploadImageChooseModel.length;
    debugPrint("==============图片并发上传开始，请等待");
    return Future.wait(futures).then((List results) {
      debugPrint("==============图片并发上传结束");
      for (var i = 0; i < needUploadCount; i++) {
        AppImageChooseBean imageChooseModel = needUploadImageChooseModel[i];

        UploadResultBean uploadResultBean = results[i];
        if (uploadResultBean.uploadResultType ==
            UploadResultType.UploadSuccess) {
          String imageUrl = uploadResultBean.url;
          imageChooseModel.networkUrl = imageUrl;
        }
      }
      return true;
    }).catchError((onError) {
      print(onError);
    });
    */
  }

  static Future<UploadResultBean> _uploadLocalVoicePath({
    String? voicePath,
  }) async {
    Completer<UploadResultBean> completer = Completer();

    UploadResultBean uploadResultBean = UploadResultBean();

    if (voicePath == null || voicePath.isEmpty) {
      uploadResultBean.uploadResultType = UploadResultType.UploadNone;
      uploadResultBean.url = null;
      completer.complete(uploadResultBean);
    } else {
      AppNetworkKit_UploadChannelUtil.uploadQCloud(
        voicePath,
        mediaType: UploadMediaType.audio,
      ).then((fullNetworkUrl) {
        if (fullNetworkUrl != null) {
          String voiceUrl = fullNetworkUrl;
          uploadResultBean.uploadResultType = UploadResultType.UploadSuccess;
          uploadResultBean.url = voiceUrl;
          completer.complete(uploadResultBean);
        } else {
          uploadResultBean.uploadResultType = UploadResultType.UploadFailure;
          uploadResultBean.url = null;
          completer.complete(uploadResultBean);
        }
        return;
      });
    }

    return completer.future;
  }

  static Future<UploadResultBean> _uploadLocalMediaPath({
    required BuildContext context,
    required String mediaPath,
    required UploadMediaType mediaType,
  }) async {
    Completer<UploadResultBean> completer = Completer();

    UploadResultBean uploadResultBean = UploadResultBean();

    if (mediaPath == null || mediaPath.isEmpty) {
      uploadResultBean.uploadResultType = UploadResultType.UploadNone;
      uploadResultBean.url = null;
      completer.complete(uploadResultBean);
    } else {
      AppNetworkKit_UploadChannelUtil.uploadQCloud(
        mediaPath,
        mediaType: mediaType,
      ).then((fullNetworkUrl) {
        if (fullNetworkUrl != null) {
          uploadResultBean.uploadResultType = UploadResultType.UploadSuccess;
          uploadResultBean.url = fullNetworkUrl;
          completer.complete(uploadResultBean);
        } else {
          uploadResultBean.uploadResultType = UploadResultType.UploadFailure;
          uploadResultBean.url = null;
          completer.complete(uploadResultBean);
          ToastUtil.showMsg("抱歉！图片上传失败！", context);
        }
        return;
      });
    }

    return completer.future;
  }
}
