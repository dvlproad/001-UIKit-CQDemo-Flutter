/*
 * @Author: dvlproad
 * @Date: 2024-02-28 16:44:28
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-18 11:39:40
 * @Description: 海报(截屏、保存到相册)
 */

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../base_share_singleton.dart';

class PosterShareUtil {
  /// 获取并保存海报
  static Future<bool> getAndSaveScreensShot(
    BuildContext context, {
    required GlobalKey screenRepaintBoundaryGlobalKey,
  }) async {
    ui.Image? screenshotImage =
        await PosterShareUtil.getScreensShot(screenRepaintBoundaryGlobalKey);
    if (screenshotImage == null) {
      BaseShareSingleton.toastHandle?.call("海报绘制出错1");
      return false;
    }

    return PosterShareUtil.saveScreensShot(
      context,
      image: screenshotImage,
    );
  }

  /// 保存海报
  static Future<bool> saveScreensShot(
    BuildContext context, {
    required ui.Image image,
    int quality = 100,
  }) async {
    bool? isGranted =
        await BaseShareSingleton.checkStoragePermissionHandle?.call();
    if (isGranted != true) {
      return false;
    }

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      BaseShareSingleton.toastHandle?.call("海报绘制出错2");
      return false;
    }

    Uint8List pngBytes = byteData.buffer.asUint8List(); // 图片byte数据转化unit8
    await ImageGallerySaver.saveImage(
      pngBytes,
      quality: quality,
    );
    BaseShareSingleton.toastHandle?.call('已保存到手机相册');

    return true;
  }

  // 对页面进行截图
  static Future<ui.Image?> getScreensShot(
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

    ui.Image image =
        await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
    return image;
  }
}
