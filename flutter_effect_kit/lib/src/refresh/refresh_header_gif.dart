/*
 * @Author: dvlproad
 * @Date: 2022-04-06 10:09:31
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-13 23:14:43
 * @Description: 下拉刷新视图
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshHeaderGif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget gifImageWidget = Image.asset(
      "assets/loading_gif/loading_top_refresh.gif",
      package: 'flutter_effect_kit',
      width: 30,
      height: 6,
      fit: BoxFit.cover,
    );

    Widget iconWidget(String text) {
      if (text == null || text.isEmpty) {
        return Container(
          // color: Colors.red,
          child: gifImageWidget,
        );
      }

      return Container(
        // color: Colors.red,
        child: Column(
          children: [
            gifImageWidget,
            Container(height: 3),
            Text(
              text,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }

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
      idleIcon: iconWidget('下拉加载'),
      releaseIcon: iconWidget('松手开始加载'),
      refreshingIcon: iconWidget('正在加载...'),
      completeIcon: iconWidget('加载完成'),
    );
  }
}
