import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshHeaderGif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget gifImageWidget = Image.asset(
      "assets/loading_gif/loading_top_refresh.gif",
      package: 'flutter_effect',
      width: 45,
      height: 10,
      fit: BoxFit.cover,
    );
    return ClassicHeader(
      refreshStyle: RefreshStyle.Behind,
      // completeText: "加载完成",
      // refreshingText: "正在加载...",
      // idleText: "下拉加载",
      // releaseText: "松手开始加载",
      completeText: "",
      refreshingText: "",
      idleText: "",
      releaseText: "",
      idleIcon: gifImageWidget,
      releaseIcon: gifImageWidget,
      refreshingIcon: gifImageWidget,
      completeIcon: gifImageWidget,
    );
  }
}
