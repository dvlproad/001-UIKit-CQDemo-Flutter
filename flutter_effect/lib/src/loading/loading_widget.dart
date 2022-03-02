import 'package:flutter/material.dart';
import './loading_images_base_widget.dart'; // 使用 images 加载动画
import 'package:lottie/lottie.dart'; // 使用 json 加载动画

class LoadingWidget extends StatelessWidget {
  final double width;
  final double height;

  final int interval;

  LoadingWidget({this.width, this.height, this.interval});

  @override
  Widget build(BuildContext context) {
    return _loadingWidget_gif;
    // return _loadingWidget_images;
    // return _loadingWidget_json;
  }

  // 动画加载方法1：使用 gif 加载动画
  Widget get _loadingWidget_gif {
    return Image.asset(
      'assets/loading_gif/loading_bj2.gif',
      package: 'flutter_effect',
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
      height: 100,
      child: Lottie.asset(
        'assets/loading_json/footer.json',
        // 'assets/loading_json/undefined_ske.json',
        package: 'flutter_effect',
        fit: BoxFit.fill,
        alignment: Alignment.bottomCenter,
        repeat: true,
      ),
    );
  }
}
