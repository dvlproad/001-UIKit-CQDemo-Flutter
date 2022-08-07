/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 23:13:43
 * @Description: 图片/视频等选择方法
 */

import 'dart:io' show File, Directory;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_images_picker/flutter_images_picker.dart'
    show PermissionsManager;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../bean/image_choose_bean.dart';

import '../get_image_info_util/get_image_info_util.dart';
import '../image_compress_util/assetEntity_info_getter.dart';

enum PickPhotoAllowType {
  imageOnly, // 只允许图片(默认值)
  videoOnly, // 只允许视频
  imageOrVideo, // 图片或视频(常见于刚开始的时候不知道列表上是要用什么类型的资源)
}

class PickAssetEntityUtil {
  static Future<List<AssetEntity>?> _pickPhoto(
    BuildContext context, {
    PickPhotoAllowType pickAllowType = PickPhotoAllowType.imageOnly,
    int maxAssetsCount = defaultMaxAssetsCount,
    Function(BuildContext, AssetEntity)? handleResult,
  }) {
    AssetPickerTextDelegate textDelegate = AssetPickerTextDelegate();

    if (pickAllowType == PickPhotoAllowType.imageOrVideo) {
      return AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: maxAssetsCount,
          // selectedAssets: selectedAssets,
          specialPickerType: SpecialPickerType.wechatMoment, // 一个视频或多个图片,且互斥
          specialItemPosition: SpecialItemPosition.prepend,
          specialItemBuilder:
              (BuildContext context, AssetPathEntity? path, int length) =>
                  _specialItem(context, path, length, textDelegate),
        ),
      );
    }

    return AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: maxAssetsCount,
        // selectedAssets: selectedAssets,
        requestType: pickAllowType == PickPhotoAllowType.videoOnly
            ? RequestType.video
            : RequestType.image, // 只允许选视频或只允许选图片,
        specialItemPosition: SpecialItemPosition.prepend,
        specialItemBuilder: (
          BuildContext context,
          AssetPathEntity? path,
          int length,
        ) {
          return _specialItem(context, path, length, textDelegate);
        },
      ),
    );
  }

  static Widget? _specialItem(
    BuildContext context,
    AssetPathEntity? path,
    int length,
    AssetPickerTextDelegate textDelegate,
  ) {
    if (path?.isAll != true) {
      return null;
    }
    return Semantics(
      label: textDelegate.sActionUseCameraHint,
      button: true,
      onTapHint: textDelegate.sActionUseCameraHint,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          // 相机拍完，直接退出相册页，并使用拍摄的照片
          // Feedback.forTap(context);
          // final AssetEntity result =
          //     await PickAssetEntityUtil._pickFromCamera(context);
          // if (result != null) {
          //   handleResult(context, result);
          // }
          // 相机拍完，先停留在相册页，并选中拍摄的照片
          final AssetEntity? result = await _pickFromCamera(context);
          if (result == null) {
            return;
          }
          final AssetPicker<AssetEntity, AssetPathEntity>? picker =
              context.findAncestorWidgetOfExactType();
          if (picker == null) {
            return;
          }
          final DefaultAssetPickerBuilderDelegate builder =
              picker.builder as DefaultAssetPickerBuilderDelegate;
          final DefaultAssetPickerProvider p = builder.provider;
          if (p.currentPath == null) {
            return;
          }
          p.currentPath = await p.currentPath!.obtainForNewProperties();
          await p.switchPath(p.currentPath);
          p.selectAsset(result);
        },
        child: const Center(
          child: Icon(Icons.camera_enhance, size: 42.0),
        ),
      ),
    );
  }

  static Future<List<AssetEntity>?> _pickVideo(
    BuildContext context, {
    required int maxAssetsCount,
    Function(BuildContext, AssetEntity)? handleResult,
  }) {
    AssetPickerTextDelegate textDelegate = AssetPickerTextDelegate();
    return AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: maxAssetsCount,
        // selectedAssets: selectedAssets,
        requestType: RequestType.video, // 只选图片
        specialItemPosition: SpecialItemPosition.prepend,
        specialItemBuilder: (
          BuildContext context,
          AssetPathEntity? path,
          int length,
        ) {
          if (path?.isAll != true) {
            return null;
          }
          return Semantics(
            label: textDelegate.sActionUseCameraHint,
            button: true,
            onTapHint: textDelegate.sActionUseCameraHint,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                // 相机拍完，直接退出相册页，并使用拍摄的照片
                // Feedback.forTap(context);
                // final AssetEntity result =
                //     await PickAssetEntityUtil._pickFromCamera(context);
                // if (result != null) {
                //   handleResult(context, result);
                // }
                // 相机拍完，先停留在相册页，并选中拍摄的照片
                final AssetEntity? result = await _pickFromCamera(context);
                if (result == null) {
                  return;
                }
                final AssetPicker<AssetEntity, AssetPathEntity>? picker =
                    context.findAncestorWidgetOfExactType();
                if (picker == null) {
                  return;
                }
                final DefaultAssetPickerBuilderDelegate builder =
                    picker.builder as DefaultAssetPickerBuilderDelegate;
                final DefaultAssetPickerProvider p = builder.provider;
                if (p.currentPath == null) {
                  return;
                }
                p.currentPath = await p.currentPath!.obtainForNewProperties();
                await p.switchPath(p.currentPath);
                p.selectAsset(result);
              },
              child: const Center(
                child: Icon(Icons.camera_enhance, size: 42.0),
              ),
            ),
          );
        },
      ),
    );
  }

  static void pickPhoto(
    BuildContext context, {
    int maxCount = defaultMaxAssetsCount,
    List<ImageChooseBean>? selectImageChooseModels,
    bool showCamera = true,
    PickPhotoAllowType pickAllowType = PickPhotoAllowType.imageOnly,
    required void Function({
      List<ImageChooseBean>? newAddedImageChooseModels,
      List<ImageChooseBean>? newCancelImageChooseModels,
    })
        imagePickerCallBack,
  }) async {
    // 图片
    int currentmaxAssetsCount =
        maxCount - (selectImageChooseModels?.length ?? 0);
    List<AssetEntity>? assetEntitys = await _pickPhoto(
      context,
      maxAssetsCount: currentmaxAssetsCount,
      pickAllowType: pickAllowType,
      // handleResult: (BuildContext context, AssetEntity assetEntity) {
      //   print("相机拍摄完毕");
      //   // Navigator.of(context).pop(<AssetEntity>[...assets, result]),
      //   _dealNewAdd(
      //     assetEntitys: [assetEntity],
      //     imagePickerCallBack: imagePickerCallBack,
      //   );
      // },
    );

    _dealNewAdd(
      assetEntitys: assetEntitys,
      imagePickerCallBack: imagePickerCallBack,
    );
  }

  static void _dealNewAdd({
    List<AssetEntity>? assetEntitys,
    required void Function({
      List<ImageChooseBean>? newAddedImageChooseModels,
      List<ImageChooseBean>? newCancelImageChooseModels,
    })
        imagePickerCallBack,
  }) async {
    _log('PickAssetEntityUtil 01');
    List<ImageChooseBean> newAddImageChooseModels = [];
    for (AssetEntity assetEntity in assetEntitys ?? []) {
      ImageChooseBean imageChooseModel = ImageChooseBean(
        assetEntity: assetEntity,
      );

      // File? file = await AssetEntityInfoGetter.getAssetEntityFile(assetEntity); // 不能 await 不然会阻塞添加操作
      // if (file == null) {
      //   debugPrint("file null 了");
      // } else {
      //   String localPath = file.path;
      //   imageChooseModel.assetEntityPath = localPath;
      // }

      // 不在选择图片的过程中。1如果同步的话，那会阻塞线程;②如果异步的话，那因为

      newAddImageChooseModels.add(imageChooseModel);
    }

    _log('PickAssetEntityUtil 02');

    imagePickerCallBack(
      newAddedImageChooseModels: newAddImageChooseModels,
      newCancelImageChooseModels: null,
    );
  }

  static Future<AssetEntity?> _pickFromCamera(BuildContext c) async {
    bool allowCamera = await PermissionsManager.checkCarmePermissions();
    if (allowCamera != true) {
      return null;
    }

    return CameraPicker.pickFromCamera(
      c,
      pickerConfig: const CameraPickerConfig(enableRecording: true),
    );
  }

  static void pickPhotoWithSelected(
    BuildContext context, {
    List<ImageChooseBean>? selectImageChooseModels,
    bool showCamera = true,
    required void Function({
      List<ImageChooseBean> newAddedImageChooseModels,
      List<ImageChooseBean> newCancelImageChooseModels,
    })
        imagePickerCallBack,
  }) async {
    // 图片
    _log('PickAssetEntityUtil 21');

    List<AssetEntity> selectedAssets = [];
    for (ImageChooseBean item in selectImageChooseModels ?? []) {
      if (item.assetEntity != null) {
        selectedAssets.add(item.assetEntity!);
      }
    }

    int currentmaxAssetsCount = 9;
    AssetPickerTextDelegate textDelegate = AssetPickerTextDelegate();
    List<AssetEntity>? pickAssetEntitys = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: currentmaxAssetsCount,
        selectedAssets: selectedAssets,
        requestType: RequestType.common,
        specialItemPosition: SpecialItemPosition.prepend,
        specialItemBuilder: (
          BuildContext context,
          AssetPathEntity? path,
          int length,
        ) {
          if (path?.isAll != true) {
            return null;
          }
          return Semantics(
            label: textDelegate.sActionUseCameraHint,
            button: true,
            onTapHint: textDelegate.sActionUseCameraHint,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                Feedback.forTap(context);
                // final AssetEntity result = await _pickFromCamera(context);
                // if (result != null) {
                //   handleResult(context, result);
                // }
              },
              child: const Center(
                child: Icon(Icons.camera_enhance, size: 42.0),
              ),
            ),
          );
        },
      ),
    );
    List<AssetEntity> assetEntitys = pickAssetEntitys ?? [];

    List<ImageChooseBean> newAddImageChooseModels = [];
    for (AssetEntity assetEntity in assetEntitys) {
      if (selectedAssets.contains(assetEntity)) {
        continue;
      }

      // File? file = await AssetEntityInfoGetter.getAssetEntityFile(assetEntity); // 不能 await 不然会阻塞添加操作
      // // 压缩图片
      // String targetPath = await getFileTargetPath(file);
      // file = await testCompressAndGetFile(file, targetPath);
      // 获取最终的图片路径

      ImageChooseBean imageChooseModel = ImageChooseBean(
        assetEntity: assetEntity,
      );

      newAddImageChooseModels.add(imageChooseModel);
    }

    List<ImageChooseBean> newCancelImageChooseModels = [];
    for (ImageChooseBean item in selectImageChooseModels ?? []) {
      if (item.assetEntity != null) {
        if (assetEntitys.contains(item.assetEntity)) {
          continue;
        } else {
          newCancelImageChooseModels.add(item);
        }
      }
    }

    _log('PickAssetEntityUtil 22');

    imagePickerCallBack(
      newAddedImageChooseModels: newAddImageChooseModels,
      newCancelImageChooseModels: newCancelImageChooseModels,
    );
  }

  static void _log(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
