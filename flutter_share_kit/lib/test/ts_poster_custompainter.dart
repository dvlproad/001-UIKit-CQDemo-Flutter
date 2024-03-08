/*
 * @Author: dvlproad
 * @Date: 2024-02-28 17:34:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-08 16:34:14
 * @Description: 
 */

import 'dart:async';
import "dart:ui" as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TSPosterCustomPainterUtil {
  static Future<Image?> savePictureRecorder(
      ui.PictureRecorder pictureRecorder) async {
    ui.Image picture =
        await pictureRecorder.endRecording().toImage(620, 1069); //设置生成图片的宽和高
    //ByteData对象 转成 Uint8List对象 给 Image.memory() 使用来显示
    ByteData? pngImageBytes =
        await picture.toByteData(format: ui.ImageByteFormat.png);
    if (pngImageBytes == null) {
      return null;
    }
    Uint8List pngBytes = pngImageBytes.buffer.asUint8List();
    Image image = Image.memory(pngBytes);
    return image;
  }
}

// 参考文档:
// [初识 Flutter 的绘图组件 — CustomPaint](https://juejin.cn/post/7072330519811194917?searchId=202403081015150182759FB087C4FE9BCD)
// [Flutter Canvas绘制文字和图片](https://www.jianshu.com/p/00c3738bd66c)
class TSPosterCustomPainter extends CustomPainter {
  final ui.PictureRecorder pictureRecorder; // 图片记录仪
  // ui.PictureRecorder pictureRecorder = ui.PictureRecorder(); // 图片记录仪
  final ui.Image? bgImage;
  final ui.Image? avatarImage;
  final ui.Image? qrCodeImage;

  TSPosterCustomPainter(
    this.pictureRecorder, {
    required this.bgImage,
    required this.avatarImage,
    required this.qrCodeImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Canvas canvas = Canvas(pictureRecorder); //canvas接受一个图片记录仪

    // 设置背景颜色/图片
    canvas.drawColor(Colors.cyan, BlendMode.color); // 超出 size 的区域不会截断
    // 画出背景边框，便于理解size的大小
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.pink,
    );

    Paint paint = Paint()
      ..filterQuality = FilterQuality.high // 创建一个画笔并配置其属性
      ..strokeWidth = 1 // 画笔的宽度
      ..isAntiAlias = true // 是否抗锯齿
      ..color = Colors.amber; // 画笔颜色

    // 设置背景图片
    if (bgImage != null) {
      // canvas.drawImageRect(
      //   bgImage!,
      //   Rect.fromLTWH(
      //       0, 0, bgImage!.width.toDouble(), bgImage!.height.toDouble()),
      //   Rect.fromLTWH(0, 0, size.width, size.height),
      //   paint,
      // );
    }

    double rectSize = 300;
    canvas.drawRect(
      Rect.fromLTWH((size.width - rectSize) / 2.0, (size.height - rectSize) / 2,
          rectSize, rectSize),
      paint,
    );

    // 头像居中显示
    if (avatarImage != null) {
      double srcWidth = avatarImage!.width.toDouble();
      double srcHeight = avatarImage!.height.toDouble();
      double dstSize = 100;

      // ②第二个参数为你需要截取的矩形Rect，举个栗子：截取一张图片，原图的宽高分别为w和h，
      // 将第二个参数设置为：Rect.fromLTRB(0, 0, w/2, h/2)。意思就是从原图片中截取一个矩形，矩形的坐标从(0.0)到（w/2, h/2)。
      // ③第三个为目标矩形Rect，即你想要在canvas上绘制的区域，
      // 举个栗子：接着上面所讲的，将第三个参数设置为Rect.fromLTWH(0, 0, 100, 100), paint);意思就是将上面截取的矩形，在canvas的（0，0）坐标开始绘制，绘制的宽和高为100，
      canvas.drawImageRect(
        avatarImage!,
        Rect.fromLTWH(0, 0, srcWidth, srcHeight),
        Rect.fromLTWH(
          (size.width - dstSize) / 2.0,
          100,
          dstSize,
          dstSize,
        ),
        paint,
      );
    }

    /// Canvas 绘制文字：方法一、使用 Paragraph
    /// 1.生成 ParagraphStyle，可设置文本的基本信息
    final paragraphStyle = ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 24.0,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    /// 2.根据 ParagraphStyle 生成 ParagraphBuilder，并添加样式和文字
    ui.ParagraphBuilder shopNameBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(
        ui.TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          textBaseline: ui.TextBaseline.alphabetic,
        ),
      )
      ..addText("苹果手机数据线")
      ..pushStyle(ui.TextStyle(color: Colors.red, fontSize: 14))
      ..addText('¥19.90');

    /// 3.通过 build 取到 Paragraph，并根据宽高进行布局layout
    ui.Paragraph shopNameParagraph = shopNameBuilder.build()
      ..layout(ui.ParagraphConstraints(width: size.width));

    /// 4.绘制
    canvas.drawParagraph(shopNameParagraph, const Offset(0, 200.0));

    /// Canvas 绘制文字：方法二、使用 TextPainter 绘制
    final textPainter = TextPainter()
      ..text = const TextSpan(
          text: '可多种不同效果的字体来支持富文本',
          style: TextStyle(color: Colors.white, fontSize: 20))
      ..textDirection = TextDirection.ltr

      /// 可以传入minWidth、maxWidth来限制宽度，若不传文字会绘制在一行
      ..layout(maxWidth: 120);

    /// 绘制矩形框，在文字绘制前可通过textPainter.width和textPainter.height来获取文字绘制的尺寸
    double textOriginX = (size.width - textPainter.width) / 2.0;
    double textOriginY = 250;
    canvas.drawRect(
      Rect.fromLTWH(
        textOriginX,
        textOriginY,
        textPainter.width,
        textPainter.height,
      ),
      Paint()..color = Colors.blue,
    );

    /// 绘制文字
    textPainter.paint(canvas, Offset(textOriginX, textOriginY));

    // 二维码图片
    if (qrCodeImage != null) {
      double srcWidth = qrCodeImage!.width.toDouble();
      double srcHeight = qrCodeImage!.height.toDouble();
      double dstSize = 100;

      canvas.drawImageRect(
        qrCodeImage!,
        Rect.fromLTWH(0, 0, srcWidth, srcHeight),
        Rect.fromLTWH(
          size.width - dstSize - 20,
          size.height - dstSize - 20,
          dstSize,
          dstSize,
        ),
        paint,
      );

      // canvas.drawImage(qrCodeImage!, const ui.Offset(20.0, 30.0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // return oldDelegate != this;
    return true;
  }
}

class ImageUtils {
  // ImageProvider转ui.Image
  static Future<ui.Image> loadImageByProvider(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    Completer<ui.Image> completer = Completer<ui.Image>(); //完成的回调

    ImageStream stream = provider.resolve(config); //获取图片流

    late ImageStreamListener listener; //监听
    listener = ImageStreamListener((ImageInfo imageInfo, bool sync) {
      final ui.Image image = imageInfo.image;
      completer.complete(image); //完成
      stream.removeListener(listener); //移除监听
    });
    stream.addListener(listener); //添加监听

    return completer.future; //返回
  }
}

class TSPosterBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFF1F1F1), BlendMode.color);
    var center = size / 2;
    var paint = Paint()..color = const Color(0xFF2080E5);
    paint.strokeWidth = 2.0;

    canvas.drawRect(
      Rect.fromLTWH(center.width - 120, center.height - 120, 240, 240),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TSPosterForegroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var center = size / 2;
    var paint = Paint()..color = const Color(0x80F53010);
    paint.strokeWidth = 2.0;

    canvas.drawCircle(
      Offset(center.width, center.height),
      100,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
