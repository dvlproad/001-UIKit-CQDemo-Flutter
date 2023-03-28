/*
 * @Author: dvlproad
 * @Date: 2022-05-09 19:06:15
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-05-11 10:53:08
 * @Description: 
 */
import 'dart:io' show File;
import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';

class GetImageInfoUtil {
  static ImageProvider getImageProvider(String imageUrlOrPath) {
    Image image;
    if (imageUrlOrPath.startsWith('http')) {
      image = Image.network(imageUrlOrPath);
    } else {
      image = Image.file(File(imageUrlOrPath));
    }
    // debugPrint('$imageUrlOrPath 图片的宽高如下:\nimageWidth111=${image.width}, imageHeight=${image.height}');

    ImageProvider imageProvider = image.image;

    return imageProvider;
  }

  static Future<Map<String, dynamic>> getImageWidthAndHeight(
      String imageUrlOrPath) async {
    ImageProvider imageProvider = getImageProvider(imageUrlOrPath);
    return getWidthAndHeight(imageProvider);
  }

  static Future<Map<String, dynamic>> getWidthAndHeight(
      ImageProvider<Object> imageProvider) async {
    Completer<Map<String, dynamic>> completer = Completer();

    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          int imageWidth = info.image.width;
          int imageHeight = info.image.height;
          debugPrint('imageWidth=$imageWidth, imageHeight=$imageHeight');

          Map<String, dynamic> imageWithHeight = {
            "width": imageWidth,
            "height": imageHeight,
          };
          completer.complete(imageWithHeight);
        },
      ),
    );

    return completer.future;
  }
}
