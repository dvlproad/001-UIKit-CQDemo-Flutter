/*
 * @Author: dvlproad
 * @Date: 2022-05-09 19:06:15
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-27 13:37:56
 * @Description: 
 */
import 'dart:io' show File;
import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';

class ImageProviderSizeUtil {
  static Future<Size> getImageWidthAndHeight(String imageUrlOrPath) async {
    ImageProvider imageProvider = _getImageProvider(imageUrlOrPath);
    return getWidthAndHeight(imageProvider);
  }

  static ImageProvider _getImageProvider(String imageUrlOrPath) {
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

  static Future<Size> getWidthAndHeight(
      ImageProvider<Object> imageProvider) async {
    Completer<Size> completer = Completer();

    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          int imageWidth = info.image.width;
          int imageHeight = info.image.height;
          debugPrint('imageWidth=$imageWidth, imageHeight=$imageHeight');
          Size imageSize = Size(imageWidth.toDouble(), imageHeight.toDouble());

          completer.complete(imageSize);
        },
      ),
    );

    return completer.future;
  }
}
