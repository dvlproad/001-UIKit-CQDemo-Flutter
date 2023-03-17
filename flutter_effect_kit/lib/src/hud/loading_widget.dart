/*
 * @Author: dvlproad
 * @Date: 2022-07-22 14:50:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-22 16:21:04
 * @Description: 
 */
import 'package:flutter/material.dart';
import './loading_images_base_widget.dart'; // 使用 images 加载动画
import 'package:lottie/lottie.dart'; // 使用 json 加载动画

enum LoadingFor {
  normal,
  videoPalyer,
}

class LoadingWidget extends StatelessWidget {
  final LoadingFor loadingFor;
  final double? width;
  final double? height;

  final int? interval;

  LoadingWidget({
    this.width,
    this.height,
    this.interval,
    this.loadingFor = LoadingFor.normal,
  });

  @override
  Widget build(BuildContext context) {
    if (loadingFor == LoadingFor.videoPalyer) {
      // return const CircularProgressIndicator(color: Colors.grey);
      return _loadingWidget_json;
    }

    return _loadingWidget_gif;
    // return _loadingWidget_images;
  }

  // 动画加载方法1：使用 gif 加载动画
  Widget get _loadingWidget_gif {
    return Image.asset(
      'assets/loading_gif/loading_center.gif',
      package: 'flutter_effect_kit',
      width: width ?? 100,
      height: height ?? 100,
    );
  }

  // 动画加载方法2：使用 images 加载动画
  Widget get _loadingWidget_images {
    List<String> images = [];
    for (int i = 0; i < 37; ++i) {
      images.add("assets/loading_images/loading_$i.png");
    }

    return FrameAnimationImageWidget(
      images,
      width: width ?? 40,
      height: height ?? 40,
      interval: interval ?? 50,
    );
  }

  // 动画加载方法3：使用 json 加载动画
  Widget get _loadingWidget_json {
    return Container(
      // color: Colors.yellow,
      height: height ?? 40,
      child: Lottie.asset(
        'assets/loading_json/loading_center_video.json',
        // 'assets/loading_json/undefined_ske.json',
        package: 'flutter_effect_kit',
        fit: BoxFit.fill,
        alignment: Alignment.bottomCenter,
        repeat: true,
      ),
    );
  }
}
