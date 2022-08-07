/*
 * @Author: dvlproad
 * @Date: 2022-05-19 11:38:16
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-05-23 14:58:11
 * @Description: 
 */
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../app_info_choose_kit_adapt.dart';

class SoundWaveWidget extends StatefulWidget {
  // final double height;

  SoundWaveWidget({
    Key key,
    // this.height,
  }) : super(key: key);

  @override
  State<SoundWaveWidget> createState() => _SoundWaveWidgetState();
}

class _SoundWaveWidgetState extends State<SoundWaveWidget> {
  Timer timer;

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 200), (time) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(13 * 6.w_pt_cj, 20.h_pt_cj),
      painter: SoundWavePainter(),
    );
  }
}

class SoundWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()
      ..color = Color(0xFFFF7F00) //画笔颜色
      ..strokeCap = StrokeCap.round //画笔笔触类型
      ..isAntiAlias = true //是否启动抗锯齿
      // ..blendMode = BlendMode.exclusion //颜色混合模式
      ..style = PaintingStyle.fill //绘画风格，默认为填充
      // ..colorFilter = ColorFilter.mode(Colors.blueAccent,
      //     BlendMode.exclusion) //颜色渲染模式，一般是矩阵效果来改变的,但是flutter中只能使用颜色混合模式
      // ..maskFilter = MaskFilter.blur(BlurStyle.inner, 3.0) //模糊遮罩效果，flutter中只有这个
      ..filterQuality = FilterQuality.high //颜色渲染模式的质量
      ..strokeWidth = 15.0; //画笔的宽度

    for (int i = 0; i < 13; i++) {
      var rng = Random();
      var nextInt = 4 + rng.nextInt(14);
      Rect rect = Rect.fromLTWH(
        (6 * i).w_pt_cj,
        (20 - nextInt / 2).h_pt_cj,
        2.w_pt_cj,
        nextInt.h_pt_cj,
      );
      RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(2.w_pt_cj));
      canvas.drawRRect(rrect, _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
