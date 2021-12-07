import 'package:flutter/material.dart';
import './loading_images_widget.dart';

class C1440Loading extends StatelessWidget {
  final double size;

  final int interval;

  C1440Loading({this.size, this.interval});

  @override
  Widget build(BuildContext context) {
    List<String> images = [];

    for (int i = 0; i < 37; ++i) {
      images.add("assets/loading_images/loading_$i.png");
    }

    return FrameAnimationImageWidget(
      images,
      width: size ?? 40,
      height: size ?? 40,
      interval: interval ?? 50,
    );
  }
}
