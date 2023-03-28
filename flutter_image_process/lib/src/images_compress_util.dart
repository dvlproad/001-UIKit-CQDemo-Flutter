/*
 * @Author: dvlproad
 * @Date: 2022-08-11 19:18:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-28 12:04:34
 * @Description: 
 */
import 'dart:core';
import 'package:flutter/foundation.dart';

import './bean/image_choose_bean.dart';

class ImageCompressUtil {
  /// 异步压缩所添加的文件
  static Future compressMediaBeans<T extends ImageChooseBean>(
    List<T> addMeidaBeans,
  ) async {
    int count = addMeidaBeans.length;
    for (var i = 0; i < count; i++) {
      T bean = addMeidaBeans[i];
      _log("bean.assetEntity.id=${bean.assetEntity?.id} begin...");
      bean.checkAndBeginCompressAssetEntity();
      if (i < count - 1) {
        // 异步压缩，并且不是最后一个时候,每个压缩间隔一下,防止内存还没释放,导致积累过多崩溃
        await Future.delayed(const Duration(milliseconds: 500));
      }
      _log("bean.assetEntity.id=${bean.assetEntity?.id} finish...");
    }
  }

  static Future proLoadVideoFramesFromList<T extends ImageChooseBean>(
    List<T> addMeidaBeans,
  ) async {
    int count = addMeidaBeans.length;
    for (var i = 0; i < count; i++) {
      T bean = addMeidaBeans[i];
      _log("bean.assetEntity.id=${bean.assetEntity!.id} begin...");
      await bean.checkAndBeginGetVideoFrames();
      // if (i < count - 1) {
      //   // 异步压缩，并且不是最后一个时候,每个压缩间隔一下,防止内存还没释放,导致积累过多崩溃
      //   await Future.delayed(Duration(milliseconds: 500));
      // }
      _log("bean.assetEntity.id=${bean.assetEntity!.id} finish...");
    }
    return true;
  }

  static void _log(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
