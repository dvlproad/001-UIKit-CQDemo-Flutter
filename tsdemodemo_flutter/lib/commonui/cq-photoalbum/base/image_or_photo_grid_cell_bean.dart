import 'package:flutter/material.dart';

class ImageCellBean {
  final ImageProvider image;
  final String message; // 相册的辅助信息，如视频 video 长度等，可为 null

  ImageCellBean(
    this.image,
    this.message,
  );
}
