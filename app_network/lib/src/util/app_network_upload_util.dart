// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_image_process/flutter_image_process.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart' show ToastUtil;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_network/app_network_manager.dart';
import '../upload/app_upload_channel_manager.dart';
import '../upload/app_compress_bean.dart';
import '../upload/app_upload_bean.dart';

enum UploadState {
  uploadStart, // 上传开始
  uploading, // 上传中
  uploadSuccess, // 上传结束且成功
  uploadFailure, // 上传结束因为失败
  videoTooLong, // 视频过长
}

class UploadApiUtil {
  static Future<UploadMediaResultType> uploadImageChooseModels({
    BuildContext? context,
    bool multipart = false,
    required List<ImageChooseBean> imageChooseModels,
    required UploadMediaType mediaType,
  }) async {
    return AppNetworkManager().uploadImageChooseModels(
      multipart: multipart,
      imageChooseModels: imageChooseModels,
      mediaType: mediaType,
    );
  }

  static Future<UploadMediaResultType> uploadImageChooseModelsByCallBack({
    required bool multipart,
    required List<ImageChooseBean> imageChooseModels,
    required UploadMediaType mediaType,
    required UploadMediaScene mediaScene,
    void Function({
      required double totalProgressValue, // 总的下载进度
      required int needUploadNumber, // 需要上传的个数
      required int successUploadNum, // 已成功上传的个数
      required int failureUploadNumber, // 失败的个数
    })?
        uploadProgress,
    void Function()? uploadSuccess,
    void Function(UploadMediaResultType errorResultType)? uploadFailure,
  }) {
    Completer<UploadMediaResultType> completer = Completer();
    AppNetworkManager().uploadImageChooseModelsByCallBack(
      multipart: multipart,
      imageChooseModels: imageChooseModels,
      mediaType: mediaType,
      mediaScene: mediaScene,
      uploadProgress: uploadProgress,
      uploadSuccess: () {
        completer.complete(UploadMediaResultType.UploadSuccess);
        if (uploadSuccess != null) {
          uploadSuccess();
        }
      },
      uploadFailure: (UploadMediaResultType errorType) {
        completer.complete(errorType);
        if (uploadFailure != null) {
          uploadFailure(errorType);
        }
      },
    );

    return completer.future;
  }

  static Future<bool> uploadVoiceModel({
    required BuildContext context,
    required bool multipart,
    required VoiceBaseBean voiceModel,
  }) async {
    return AppNetworkManager().uploadVoiceModel(
      context: context,
      multipart: multipart,
      voiceModel: voiceModel,
    );
  }

  static String getUploadMediaResultTypeString(
      UploadMediaResultType resultType) {
    return AppNetworkManager().getUploadMediaResultTypeString(resultType);
  }

  static Future<String?> channel_uploadQCloud(
    String? localPath, {
    UploadMediaType mediaType = UploadMediaType.unkonw,
    UploadMediaScene mediaScene = UploadMediaScene.unkonw,
    void Function({required double progressValue})? uploadProgress, // 上传进度监听
  }) async {
    return AppNetworkManager().channel_uploadQCloud(
      localPath ?? "",
      false,
      mediaType: mediaType,
      mediaScene: mediaScene,
      uploadProgress: uploadProgress,
    );
  }
}

extension UploadApi on AppNetworkManager {
  Future<bool> uploadVoiceModel({
    required BuildContext context,
    required bool multipart,
    required VoiceBaseBean voiceModel,
  }) async {
    bool isNetworkVoice = voiceModel.networkUrl != null;
    if (isNetworkVoice == true) {
      return true;
    }

    if (voiceModel.localPath == null) {
      return false;
    }
    String voicePath = voiceModel.localPath!;
    UploadResultBean uploadResultBean = await _uploadLocalVoicePath(
      voicePath: voicePath,
      multipart: multipart,
    );
    if (uploadResultBean.uploadResultType == UploadResultType.UploadSuccess) {
      voiceModel.networkUrl = uploadResultBean.url;
      return true;
    } else {
      ToastUtil.forceShowMessage("抱歉！语音上传失败！");
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

  String getUploadMediaResultTypeString(UploadMediaResultType resultType) {
    switch (resultType) {
      case UploadMediaResultType.ImageFailureBCThumbnailGet:
        return "图片压缩失败";
      case UploadMediaResultType.ImageFailureBCThumbnailUpload:
        return "图片上传失败";
      case UploadMediaResultType.VideoFailureBCSelfTooBig:
        return "您的视频太大，请上传小于200M的视频";
      case UploadMediaResultType.VideoFailureBCSelfTooLong:
        return "您的视频太长，请上传小于30分钟的视频";
      case UploadMediaResultType.VideoFailureBCThumbnailSelfGet:
        return "视频压缩失败";
      case UploadMediaResultType.VideoFailureBCThumbnailSelfUpload:
        return "视频上传失败";
      case UploadMediaResultType.VideoFailureBCThumbnailImageGet:
        return "视频缩略图获取失败";
      case UploadMediaResultType.VideoFailureBCThumbnailImageUpload:
        return "视频缩略图上传失败";
      default:
        return "上传成功";
    }
  }

  /// 对所有进行压缩检查，如果未压缩，则进行压缩
  static Future<bool> checkcCompressImageChooseModels({
    required BuildContext context,
    required List<ImageChooseBean> imageChooseModels,
  }) async {
    // 串行
    for (ImageChooseBean imageChooseModel in imageChooseModels) {
      CompressMediaResultType compressMediaResultType =
          await checkcCompressImageChooseModel(
        context: context,
        imageChooseModel: imageChooseModel,
      );
      if (compressMediaResultType !=
              CompressMediaResultType.NoNeedCompressAgain &&
          compressMediaResultType != CompressMediaResultType.CompressSuccess) {
        return false;
      }
    }
    return true;
  }

  /// 对指定数据进行压缩检查，如果未压缩，则进行压缩并返回状态(及TODO:返回压缩结果)
  static Future<CompressMediaResultType> checkcCompressImageChooseModel({
    required BuildContext context,
    required ImageChooseBean imageChooseModel,
  }) async {
    // 串行
    bool isNetworkImage = imageChooseModel.networkUrl != null;
    if (isNetworkImage == true) {
      return CompressMediaResultType.NoNeedCompressAgain;
    }

    if (imageChooseModel.mediaType == UploadMediaType.video) {
      /// 视频
      String? uploadVideoPath =
          await imageChooseModel.lastUploadThumbnailVideoPath();
      if (uploadVideoPath == null) {
        if (imageChooseModel.compressVideoResultType ==
            CompressResultType.failure_tooBig) {
          return CompressMediaResultType.VideoFailureBCSelfTooBig;
        }
        return CompressMediaResultType.VideoFailureBCThumbnailSelfGet;
      }

      /// 视频的缩略图
      String? uploadVideoThumbnailImagePath =
          await imageChooseModel.lastUploadThumbnailImagePath();
      if (uploadVideoThumbnailImagePath == null) {
        return CompressMediaResultType.VideoFailureBCThumbnailImageGet;
      }
    } else if (imageChooseModel.mediaType == UploadMediaType.image) {
      // 图片本身
      String? uploadImageThumbnailImagePath =
          await imageChooseModel.lastUploadThumbnailImagePath();
      if (uploadImageThumbnailImagePath == null) {
        return CompressMediaResultType.ImageFailureBCThumbnailGet;
      }
    }

    return CompressMediaResultType.CompressSuccess;
  }

  void uploadImageChooseModelsByCallBack({
    required bool multipart,
    required List<ImageChooseBean> imageChooseModels,
    required UploadMediaType mediaType,
    required UploadMediaScene mediaScene,
    void Function({
      required double totalProgressValue, // 总的下载进度
      required int needUploadNumber, // 需要上传的个数
      // required int unneedUploadNumber, // 不需要上传的个数
      required int successUploadNum, // 已成功上传的个数
      required int failureUploadNumber, // 失败的个数
    })?
        uploadProgress, // 总进度
    void Function()? uploadSuccess,
    void Function(UploadMediaResultType errorResultType)? uploadFailure,
  }) async {
    List<ImageChooseBean> needUploadImageChooseModels = [];
    int needUploadNumber = 0;
    HashMap<int, double> progressMap = HashMap();
    for (ImageChooseBean imageChooseModel in imageChooseModels) {
      bool isNetworkImage = imageChooseModel.networkUrl != null;
      if (isNetworkImage == true) {
        continue;
      } else {
        needUploadImageChooseModels.add(imageChooseModel);
        needUploadNumber++;
      }
    }

    int successUploadNum = 0;
    int failureUploadNumber = 0;
    UploadMediaResultType lastErrorType = UploadMediaResultType.Unknow;

    bool asyncUpload = true;
    //并行
    if (asyncUpload) {
      if (needUploadNumber == 0) {
        if (uploadSuccess != null) {
          uploadSuccess();
        }
      } else {
        if (multipart) {
          await AppNetworkManager().initQCloudCredential(mediaType, mediaScene);
        }
        for (var i = 0; i < needUploadNumber; i++) {
          ImageChooseBean imageChooseModel = needUploadImageChooseModels[i];
          _compressAndUploadLocalMediaPath(
            mediaType: mediaType,
            mediaScene: mediaScene,
            multipart: multipart,
            imageChooseModel: imageChooseModel,
            uploadProgress: ({required double progressValue}) {
              progressMap[i] = progressValue;
              double totalProgressValue = 0.0;
              progressMap.forEach((key, value) {
                totalProgressValue += value;
              });
              totalProgressValue /= needUploadNumber;
              debugPrint("totalProgressValue = $totalProgressValue");

              if (uploadProgress != null) {
                uploadProgress(
                  totalProgressValue: totalProgressValue,
                  needUploadNumber: needUploadNumber,
                  successUploadNum: successUploadNum,
                  failureUploadNumber: failureUploadNumber,
                );
              }
            },
          ).then((bean) {
            if (bean.resultType == UploadMediaResultType.UploadSuccess) {
              successUploadNum++;
              progressMap[i] = 100;
              debugPrint("progressValues = $progressMap");
              double totalProgressValue = 0.0;
              progressMap.forEach((key, value) {
                totalProgressValue += value;
              });
              totalProgressValue /= needUploadNumber;
              debugPrint("totalProgressValue = $totalProgressValue");
              if (uploadProgress != null) {
                uploadProgress(
                  totalProgressValue: totalProgressValue,
                  needUploadNumber: needUploadNumber,
                  successUploadNum: successUploadNum,
                  failureUploadNumber: failureUploadNumber,
                );
              }
              if (successUploadNum == needUploadNumber) {
                if (uploadSuccess != null) {
                  uploadSuccess();
                }
              }
            } else {
              failureUploadNumber++;
              lastErrorType = bean.resultType;
              if (uploadFailure != null) {
                uploadFailure(lastErrorType);
              }
            }
          });
        }
      }
      // ignore: dead_code
    } else {
      // 串行
      for (var i = 0; i < needUploadNumber; i++) {
        ImageChooseBean imageChooseModel = needUploadImageChooseModels[i];
        // double currentProgressValue = 0.0;
        UploadMediaResultBean bean = await _compressAndUploadLocalMediaPath(
          mediaType: mediaType,
          mediaScene: mediaScene,
          multipart: multipart,
          imageChooseModel: imageChooseModel,
          uploadProgress: ({required double progressValue}) {
            progressMap[i] = progressValue;
            debugPrint("progressValues = $progressMap");
            double totalProgressValue = 0.0;
            progressMap.forEach((key, value) {
              totalProgressValue += value;
            });
            totalProgressValue /= needUploadNumber;
            debugPrint("totalProgressValue = $totalProgressValue");

            if (uploadProgress != null) {
              uploadProgress(
                totalProgressValue: totalProgressValue,
                needUploadNumber: needUploadNumber,
                successUploadNum: successUploadNum,
                failureUploadNumber: failureUploadNumber,
              );
            }
          },
        );
        if (bean.resultType == UploadMediaResultType.UploadSuccess) {
          successUploadNum++;
        } else {
          failureUploadNumber++;
          lastErrorType = bean.resultType;
          break;
        }
      }

      if (successUploadNum == needUploadNumber) {
        if (uploadSuccess != null) {
          uploadSuccess();
        }
      } else {
        if (uploadFailure != null) {
          uploadFailure(lastErrorType);
        }
      }
    }
  }

  Future<UploadMediaResultType> uploadImageChooseModels({
    required bool multipart,
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
          if (imageChooseModel.compressVideoResultType ==
              CompressResultType.failure_tooBig) {
            return UploadMediaResultType.VideoFailureBCSelfTooBig;
          } else if (imageChooseModel.compressVideoResultType ==
              CompressResultType.failure_tooLong) {
            return UploadMediaResultType.VideoFailureBCSelfTooLong;
          }
          return UploadMediaResultType.VideoFailureBCThumbnailSelfGet;
        }
        UploadResultBean uploadVideoResultBean = await _uploadLocalMediaPath(
          multipart: multipart,
          mediaPath: uploadVideoPath,
          mediaType: mediaType,
          mediaScene: UploadMediaScene.unkonw,
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
          multipart: multipart,
          mediaPath: uploadVideoThumbnailImagePath,
          mediaType: UploadMediaType.image,
          mediaScene: UploadMediaScene.unkonw,
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
          multipart: multipart,
          mediaPath: uploadImageThumbnailImagePath,
          mediaType: UploadMediaType.image,
          mediaScene: UploadMediaScene.unkonw,
        );

        if (uploadImageThumbnailImageResultBean.uploadResultType !=
            UploadResultType.UploadSuccess) {
          return UploadMediaResultType.ImageFailureBCThumbnailUpload;
        }
        imageChooseModel.networkUrl = uploadImageThumbnailImageResultBean.url;
      }
    }

    return UploadMediaResultType.UploadSuccess;
  }

  Future<UploadResultBean> _uploadLocalVoicePath({
    required String voicePath,
    required bool multipart,
  }) async {
    Completer<UploadResultBean> completer = Completer();

    UploadResultBean uploadResultBean = UploadResultBean(
      uploadResultType: UploadResultType.Unknow,
    );

    if (voicePath.isEmpty) {
      uploadResultBean.uploadResultType = UploadResultType.UploadNone;
      uploadResultBean.url = null;
      completer.complete(uploadResultBean);
    } else {
      channel_uploadQCloud(
        voicePath,
        multipart,
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
      });
    }

    return completer.future;
  }

  Future<UploadMediaResultBean> _compressAndUploadLocalMediaPath({
    required bool multipart,
    required UploadMediaType mediaType,
    required UploadMediaScene mediaScene,
    required ImageChooseBean imageChooseModel,
    void Function({required double progressValue})? uploadProgress, // 上传进度监听
  }) async {
    UploadMediaResultBean bean = UploadMediaResultBean(
      resultType: UploadMediaResultType.Unknow,
    );

    if (imageChooseModel.mediaType == UploadMediaType.video) {
      /// 视频
      String? uploadVideoPath =
          await imageChooseModel.lastUploadThumbnailVideoPath();
      if (uploadVideoPath == null) {
        if (imageChooseModel.compressVideoResultType ==
            CompressResultType.failure_tooBig) {
          bean.resultType = UploadMediaResultType.VideoFailureBCSelfTooBig;
        } else if (imageChooseModel.compressVideoResultType ==
            CompressResultType.failure_tooLong) {
          bean.resultType = UploadMediaResultType.VideoFailureBCSelfTooLong;
        } else {
          bean.resultType =
              UploadMediaResultType.VideoFailureBCThumbnailSelfGet;
        }

        return bean;
      }

      UploadResultBean onlyUploadResultBean = await _uploadLocalMediaPath(
        multipart: multipart,
        mediaPath: uploadVideoPath,
        mediaType: mediaType,
        mediaScene: mediaScene,
        uploadProgress: uploadProgress,
      );
      if (onlyUploadResultBean.uploadResultType !=
          UploadResultType.UploadSuccess) {
        bean.resultType =
            UploadMediaResultType.VideoFailureBCThumbnailSelfUpload;
        return bean;
      }
      imageChooseModel.networkUrl = onlyUploadResultBean.url;

      /// 视频的缩略图
      if (multipart) {
        await AppNetworkManager()
            .initQCloudCredential(UploadMediaType.image, mediaScene);
      }
      String? uploadVideoThumbnailImagePath =
          await imageChooseModel.lastUploadThumbnailImagePath();
      if (uploadVideoThumbnailImagePath == null) {
        bean.resultType = UploadMediaResultType.VideoFailureBCThumbnailImageGet;
        return bean;
      }
      UploadResultBean uploadVideoThumbnailImageResultBean =
          await _uploadLocalMediaPath(
        multipart: multipart,
        mediaPath: uploadVideoThumbnailImagePath,
        mediaType: UploadMediaType.image,
        mediaScene: mediaScene,
        uploadProgress: uploadProgress,
      );
      if (uploadVideoThumbnailImageResultBean.uploadResultType !=
          UploadResultType.UploadSuccess) {
        bean.resultType =
            UploadMediaResultType.VideoFailureBCThumbnailImageUpload;
        return bean;
      }
      imageChooseModel.networkThumbnailUrl =
          uploadVideoThumbnailImageResultBean.url;

      bean.resultType = UploadMediaResultType.UploadSuccess;
      return bean;
    } else if (imageChooseModel.mediaType == UploadMediaType.image) {
      // 图片本身
      String? uploadImageThumbnailImagePath =
          await imageChooseModel.lastUploadThumbnailImagePath();
      if (uploadImageThumbnailImagePath == null) {
        bean.resultType = UploadMediaResultType.ImageFailureBCThumbnailGet;
        return bean;
      }
      UploadResultBean uploadImageThumbnailImageResultBean =
          await _uploadLocalMediaPath(
        multipart: multipart,
        mediaPath: uploadImageThumbnailImagePath,
        mediaType: UploadMediaType.image,
        mediaScene: mediaScene,
        uploadProgress: uploadProgress,
      );

      if (uploadImageThumbnailImageResultBean.uploadResultType !=
          UploadResultType.UploadSuccess) {
        bean.resultType = UploadMediaResultType.ImageFailureBCThumbnailUpload;
        return bean;
      }
      imageChooseModel.networkUrl = uploadImageThumbnailImageResultBean.url;
      bean.resultType = UploadMediaResultType.UploadSuccess;
      return bean;
    } else {
      return bean;
    }
  }

  Future<UploadResultBean> _uploadLocalMediaPath({
    required bool multipart,
    required String mediaPath,
    required UploadMediaType mediaType,
    required UploadMediaScene mediaScene,
    void Function({required double progressValue})? uploadProgress, // 上传进度监听
  }) async {
    Completer<UploadResultBean> completer = Completer();

    UploadResultBean uploadResultBean = UploadResultBean(
      uploadResultType: UploadResultType.Unknow,
    );

    if (mediaPath == null || mediaPath.isEmpty) {
      uploadResultBean.uploadResultType = UploadResultType.UploadNone;
      uploadResultBean.url = null;
      completer.complete(uploadResultBean);
    } else {
      if (multipart) {
        final sharedPreferences = await SharedPreferences.getInstance();
        final uploadIdStr =
            sharedPreferences.getString("multipart.uploadId") ?? "{}";
        final Map map = json.decode(uploadIdStr);
        String key = mediaPath.split("/").last;
        final complete = map["complete$key"] ?? false;
        if (complete) {
          final cos = map["complete_cos$key"];
          uploadResultBean.uploadResultType = UploadResultType.UploadSuccess;
          final pre = AppNetworkManager()
              .cosFileUrlPrefixGetFunction(mediaType, mediaScene);
          uploadResultBean.url = "$pre$cos";
          if (uploadProgress != null) {
            uploadProgress(progressValue: 100);
          }
          completer.complete(uploadResultBean);
          return completer.future;
        }
      }
      channel_uploadQCloud(
        mediaPath,
        multipart,
        mediaType: mediaType,
        uploadProgress: uploadProgress,
      ).then((fullNetworkUrl) {
        if (fullNetworkUrl != null) {
          uploadResultBean.uploadResultType = UploadResultType.UploadSuccess;
          uploadResultBean.url = fullNetworkUrl;
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
}
