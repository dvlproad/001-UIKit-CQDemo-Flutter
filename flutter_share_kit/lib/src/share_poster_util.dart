/*
 * @Author: dvlproad
 * @Date: 2024-02-28 16:44:28
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-29 10:30:12
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

class SharePosterUtil {
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
  static Future<Uint8List?> getScreensShot(BuildContext buildContext) async {
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
