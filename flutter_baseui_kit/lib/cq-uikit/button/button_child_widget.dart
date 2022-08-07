/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-05 14:58:46
 * @Description: button 中 childWidget 的创建
 */
import 'package:flutter/material.dart';

import '../../flutter_baseui_kit_adapt.dart';
import './imagebutton.dart';

class ButtonChildWidget extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Image? imageWidget; // 图片
  final double? imageTitleGap; // 图片和文字之间的距离(imageWidget存在的时候才有效)

  const ButtonChildWidget({
    Key? key,
    required this.title,
    this.titleStyle,
    this.imageWidget,
    this.imageTitleGap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.imageWidget != null) {
      return _childWidget_textAndImage;

      // return LeftImageTextDeleteButton(
      //   textLabel: Text(
      //     title,
      //     textAlign: TextAlign.left,
      //     overflow: TextOverflow.ellipsis,
      //     style: this.titleStyle ??
      //         TextStyle(
      //           // color: _currentTextColor, //不用设颜色，会自动使用外层样式
      //           fontSize: 13.0,
      //         ),
      //   ),
      //   iconTitleSpace: 5.w_pt_cj,
      //   imageView: this.imageWidget,
      // );
    } else {
      return _childWidget_onlyText;
    }
  }

  // 为什么 Button 里 不要再设置颜色。猜测是由于[DefaultTextStyle](https://blog.csdn.net/jungle_pig/article/details/94383759)
  Widget get _childWidget_onlyText {
    return Center(
      child: Text(
        title,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: this.titleStyle ??
            TextStyle(
              // color: _currentTextColor, //不用设颜色，会自动使用外层样式
              fontSize: 13.0,
            ),
      ),
    );
  }

  Widget get _childWidget_textAndImage {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          this.imageWidget!,
          SizedBox(width: this.imageTitleGap ?? 5),
          _childWidget_onlyText,
        ],
      ),
    );
  }

  Widget get _testWidget {
    String _currentTitle = '临时标题';
    return Column(
      children: [
        Text(
          _currentTitle,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: this.titleStyle ??
              TextStyle(
                // color: _currentTextColor,
                fontSize: 18.0,
              ),
        ),
        Text(
          _currentTitle,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: this.titleStyle ??
              TextStyle(
                // color: _currentTextColor,
                fontSize: 18.0,
              ),
        ),
      ],
    );
  }
}
