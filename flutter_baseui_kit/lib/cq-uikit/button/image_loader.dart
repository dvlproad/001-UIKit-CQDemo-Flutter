/*
 * @Author: dvlproad
 * @Date: 2023-01-30 11:55:19
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 18:35:40
 * @Description: 
 */
/*
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
// 其他参考：
// [《Flutter入门疑难杂症》获取网络图片，并自适应屏幕宽度(适合文章/帖子详情)](https://blog.csdn.net/WZAHD/article/details/108578673)

typedef AsyncImageWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, String url);

typedef AsyncImageFileWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, File file);

typedef AsyncImageMemoryWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, Uint8List bytes);

enum AsperctRaioImageType { NETWORK, FILE, ASSET, MEMORY }


///有宽高的Image
class AsperctRaioImage extends StatelessWidget {
  String url;
  File file;
  Uint8List bytes;
  final ImageProvider provider;
  AsperctRaioImageType type;
  AsyncImageWidgetBuilder<ui.Image> builder;
  AsyncImageFileWidgetBuilder<ui.Image> filebBuilder;
  AsyncImageMemoryWidgetBuilder<ui.Image> memoryBuilder;

  AsperctRaioImage.network(url, {Key? key, required this.builder})
      : provider = NetworkImage(url),
        type = AsperctRaioImageType.NETWORK,
        this.url = url;

  AsperctRaioImage.file(
    file, {
    Key? key,
    required this.filebBuilder,
  })  : provider = FileImage(file),
        type = AsperctRaioImageType.FILE,
        this.file = file;

  AsperctRaioImage.asset(name, {Key? key, required this.builder})
      : provider = AssetImage(name),
        type = AsperctRaioImageType.ASSET,
        this.url = name;

  AsperctRaioImage.memory(bytes, {Key? key, required this.memoryBuilder})
      : provider = MemoryImage(bytes),
        type = AsperctRaioImageType.MEMORY,
        this.bytes = bytes;

  @override
  Widget build(BuildContext context) {
    final ImageConfiguration config = createLocalImageConfiguration(context);
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ImageStream stream = provider.resolve(config);
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo image, bool sync) {
        completer.complete(image.image);
        stream.removeListener(listener);
      },
      onError: (Object exception, StackTrace? stackTrace) {
        // ignore: null_argument_to_non_null_type
        completer.complete();
        stream.removeListener(listener);
        FlutterError.reportError(FlutterErrorDetails(
          context: ErrorDescription('image failed to precache'),
          library: 'image resource service',
          exception: exception,
          stack: stackTrace,
          silent: true,
        ));
      },
    );
    stream.addListener(listener);

    return FutureBuilder(
      future: completer.future,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        if (snapshot.hasData) {
          if (type == AsperctRaioImageType.FILE) {
            return filebBuilder(context, snapshot, file);
          } else if (type == AsperctRaioImageType.MEMORY) {
            return memoryBuilder(context, snapshot, bytes);
          } else {
            return builder(context, snapshot, url);
          }
        } else {
          return Container();
        }
      },
    );
  }
}
*/