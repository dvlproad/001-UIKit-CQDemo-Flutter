/*
 * @Author: dvlproad
 * @Date: 2024-02-28 16:44:28
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-08 17:04:32
 * @Description: 海报(截屏、保存到相册)
 */

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
// import 'package:flutter_effect_kit/flutter_effect_kit.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_permission_manager/flutter_permission_manager.dart';

class PosterShareUtil {
  /// 获取并保存海报
  static Future<void> getAndSaveScreensShot(
    BuildContext context, {
    required GlobalKey screenRepaintBoundaryGlobalKey,
    required void Function(bool isSuccess) completeBlock,
  }) async {
    Uint8List? screenshotBytes =
        await PosterShareUtil.getScreensShot(screenRepaintBoundaryGlobalKey);

    if (screenshotBytes == null) {
      return completeBlock(false);
    }

    PosterShareUtil.saveScreensShot(
      context,
      pngBytes: screenshotBytes,
      saveCompleteBlock: () {
        completeBlock(true);
      },
    );
  }

  /// 保存海报
  static saveScreensShot(
    BuildContext context, {
    required Uint8List pngBytes,
    required void Function() saveCompleteBlock,
  }) async {
    bool isGranted = await PermissionsManager.storage();
    if (!isGranted) {
      return;
    }

    await ImageGallerySaver.saveImage(
      pngBytes,
      quality: 100,
    );
    ToastUtil.showMsg('已保存到手机相册', context);

    saveCompleteBlock();
  }

  // 对页面进行截图
  static Future<Uint8List?> getScreensShot(
    GlobalKey screenRepaintBoundaryGlobalKey,
  ) async {
    BuildContext? buildContext = screenRepaintBoundaryGlobalKey.currentContext;
    if (buildContext == null) {
      return null;
    }

    RenderRepaintBoundary? boundary =
        buildContext.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return null;
    }

    var image = await boundary.toImage(pixelRatio: window.devicePixelRatio);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData == null) {
      return null;
    }

    Uint8List? pngBytes = byteData.buffer.asUint8List(); // 图片byte数据转化unit8
    return pngBytes;
  }
}
