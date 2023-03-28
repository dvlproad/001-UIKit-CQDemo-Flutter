/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-18 22:16:37
 * @Description: 图片/视频等浏览方法
 */
import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_image_process/flutter_image_process.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetEntity, AssetPicker, SpecialPickerType;
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetPickerViewer;
// import './asset_picker_viewer.dart' show AssetPickerViewer;

import '../widget/network_video_page.dart';

class PreviewUtil {
  static preview(
    BuildContext context, {
    required List<ImageChooseBean> imageChooseModels,
    required int imageIndex,
  }) async {
    ImageChooseBean selectedImageChooseModel = imageChooseModels[imageIndex];

    /// 视图视频的处理如下：
    if (selectedImageChooseModel.mediaType == UploadMediaType.video) {
      if (selectedImageChooseModel.assetEntity != null) {
        List<AssetEntity> assets = [];
        for (ImageChooseBean item in imageChooseModels) {
          if (item.assetEntity != null) {
            AssetEntity assetEntity = item.assetEntity!;
            assets.add(assetEntity);
          } else if (item.networkUrl != null && item.networkUrl!.isNotEmpty) {
            // File file = File(item.networkUrl);
          }
        }
        int index = imageIndex;

        Color themeColor = Color(0xff00bc56);
        List<AssetEntity>? result = await AssetPickerViewer.pushToViewer(
          context,
          currentIndex: index,
          previewAssets: assets,
          themeData: AssetPicker.themeData(themeColor),
          specialPickerType: SpecialPickerType.wechatMoment,
        );
      } else if (selectedImageChooseModel.compressVideoBean != null) {
        // 草稿里的视频的预览
        String? fileUrl =
            selectedImageChooseModel.compressVideoBean!.compressPath ??
                selectedImageChooseModel.compressVideoBean!.originPath;
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return NetworkVideoPage(
              fileUrl: fileUrl,
            );
          },
        ));
      } else if (selectedImageChooseModel.networkUrl != null &&
          selectedImageChooseModel.networkUrl!.isNotEmpty) {
        String networkUrl = selectedImageChooseModel.networkUrl!;
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return NetworkVideoPage(
              networkUrl: networkUrl,
            );
          },
        ));
      }

      return;
    }

    /// 图片时候的处理如下：
    // MediaBrowserInterface.goMediaBrowser();
    // route.RouteManager.pushPage(
    //   context,
    //   RouteNames.mediaBrowerPage,
    //   transition: TransitionType.fadeIn,
    //   arguments: {
    //     "imageBeans": imageChooseModels,
    //     "index": imageIndex,
    //     "giveUpSave": true,
    //   },
    // );
    return;

    List<String> imagePaths = [];
    for (ImageChooseBean item in imageChooseModels) {
      String imagePathOrUrl = '';

      // 修复【异步压缩，并且每个压缩间隔一下,防止内存还没释放,导致积累过多崩溃】时候，因间隔处理，导致提前预览时候，数据没出来的问题
      // TODO: 换个预览控制器
      if (item.compressImageBean != null) {
        imagePathOrUrl = item.compressImageBean!.originPathOrUrl;
      } else if (item.assetEntity != null) {
        File? file =
            await AssetEntityInfoGetter.getAssetEntityFile(item.assetEntity!);
        imagePathOrUrl = file?.path ?? '';
      } else if (item.networkUrl != null) {
        imagePathOrUrl = item.networkUrl!;
      }

      imagePaths.add(imagePathOrUrl);
    }
    /*
    ImagePickers.previewImages(imagePaths, imageIndex);
    */
    /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoViewGalleryScreen(
          images: imagePaths, //传入图片list
          index: imageIndex, //传入当前点击的图片的index
        ),
      ),
    );
    */

    // route.RouteManager.pushPage(
    //   context,
    //   RouteNames.mediaBrowerPage,
    //   transition: TransitionType.fadeIn,
    //   arguments: {
    //     "images": imagePaths,
    //     "index": imageIndex,
    //     "giveUpSave": true,
    //   },
    // );

    /*
    List<AssetEntity> assets = [];
    for (ImageChooseBean item in imageChooseModels) {
      if (item.assetEntity != null) {
        AssetEntity assetEntity = item.assetEntity;
        assets.add(assetEntity);
      } else if (item.networkUrl != null && item.networkUrl.isNotEmpty) {
        // File file = File(item.networkUrl);
      }
    }
    int index = imageIndex;

    Color themeColor = Color(0xff00bc56);
    List<AssetEntity> result = await AssetPickerViewer.pushToViewer(
      context,
      currentIndex: index,
      previewAssets: assets,
      themeData: AssetPicker.themeData(themeColor),
    );
    */
  }
}
