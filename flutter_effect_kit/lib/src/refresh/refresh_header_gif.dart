/*
 * @Author: dvlproad
 * @Date: 2022-04-06 10:09:31
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 17:20:50
 * @Description: 下拉刷新视图
 */
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshHeaderGifNew extends StatefulWidget {
  final double? height;

  const RefreshHeaderGifNew({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  State<RefreshHeaderGifNew> createState() => RefreshHeaderGifNewState();
}

class RefreshHeaderGifNewState extends State<RefreshHeaderGifNew> {
  String _text = '';

  updateText(String text) {
    setState(() {
      _text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Container(
      height: widget.height,
      width: 100,
      color: Colors.red,
      child: Column(
        children: [
          // RefreshHeaderGif(),
          Text(_text),
          const Text(
            "加载中...",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class RefreshHeaderGif extends StatelessWidget {
  const RefreshHeaderGif({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    //转动loading
    Widget circular = SizedBox(
      width: 25,
      height: 25,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(Color(0xFFFF7F00)),
      ),
    );
    //满额loading
    Widget circularMax = SizedBox(
      width: 25,
      height: 25,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(Color(0xFFFF7F00)),
        value: 1,
      ),
    );
    */
    //gif图片
    Widget gifImageWidget = Image.asset(
      "assets/loading_gif/loading_top_refresh.gif",
      package: 'flutter_effect_kit',
      width: 30,
      height: 6,
      fit: BoxFit.cover,
    );
    //icon+gif
    Widget iconWidget(String text) {
      bool isIdle = text != '下拉加载' ? true : false;
      // ignore: avoid_unnecessary_containers
      return Container(
        // color: Colors.red,
        child: Column(
          children: [
            isIdle ? const SizedBox(height: 11) : const SizedBox(),
            gifImageWidget,
            const SizedBox(height: 3),
            Text(
              text,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }

    //引用loading下拉
    // return WaterDropHeader(
    //   refresh: circular,
    //   complete: circularMax,
    //   idleIcon: circular,
    //   waterDropColor: Colors.transparent,
    // );
    //引用icon+gif下拉
    return WaterDropHeader(
      refresh: iconWidget('正在加载'),
      complete: iconWidget('加载完成'),
      idleIcon: iconWidget('下拉加载'),
      waterDropColor: Colors.transparent,
      failed: iconWidget('加载错误'),
    );
  }
}
// class RefreshHeaderGif extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {

//     return ClassicHeader(
//       refreshStyle: RefreshStyle.Behind,
//       // completeText: "加载完成",
//       // refreshingText: "正在加载...",
//       // idleText: "下拉加载",
//       // releaseText: "松手开始加载",
//       completeText: "",
//       refreshingText: "",
//       idleText: "",
//       releaseText: "",
//       idleIcon: iconWidget('下拉加载'),
//       releaseIcon: iconWidget('松手开始加载'),
//       refreshingIcon: iconWidget('正在加载...'),
//       completeIcon: iconWidget('加载完成'),
//     );
//   }
// }
