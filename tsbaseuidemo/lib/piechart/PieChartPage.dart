import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'PieChartWidget.dart';

class PieChartPage extends StatefulWidget {
  @override
  _PieChartPageState createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  late List<double> angles;

  late List<Color> colors;
  late List<String> contents;
  ui.Image? image;

  @override
  void initState() {
    super.initState();

    colors = [Colors.red, Colors.cyan, Colors.blue, Colors.yellow, Colors.grey];
    angles = [1 / 7, 2 / 7, 2 / 7, 1 / 14, 3 / 14];
    contents = ["梁朝伟", "刘德华", "郭富城", "周星驰", "张学友"];

    getImage('1').then((ui.Image bImage) {
      setState(() {
        image = bImage;
      });
    });
  }

  Future<ui.Image> getImage(String path) async {
    path = './images/turntable_wishbeans_10.png';
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image image = frameInfo.image;
    return image;
  }

  Future<ui.Image> makeBitmap(ui.Image image) async {
    double eachBitmapWidth = 100;
    double ww = eachBitmapWidth.toDouble();
    Rect rect = Rect.fromLTRB(0.0, 0.0, eachBitmapWidth, eachBitmapWidth);
    rect = rect.shift(
        Offset(eachBitmapWidth.toDouble() * 1, eachBitmapWidth.toDouble() * 1));

    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder, Rect.fromLTWH(0.0, 0.0, ww, ww));

    Rect rect2 = Rect.fromLTRB(0.0, 0.0, rect.width, rect.height);

    Paint paint = Paint();
    canvas.drawImageRect(image, rect, rect2, paint);

    // ImageNode node = ImageNode();
    ui.Image lastImage =
        await recorder.endRecording().toImage(ww.floor(), ww.floor());

    return lastImage;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PieChartWidget(
        angles,
        colors,
        startTurns: .0,
        radius: 200,
        contents: contents,
        image: image,
      ),
    );
  }
}
