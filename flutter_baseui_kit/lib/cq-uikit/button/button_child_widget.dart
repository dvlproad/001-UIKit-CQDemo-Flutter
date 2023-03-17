/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-11-17 17:22:25
 * @Description: button 中 childWidget 的创建
 */
import 'package:flutter/material.dart';

import '../../flutter_baseui_kit_adapt.dart';
import './imagebutton.dart';

enum ButtonImagePosition {
  none, // 无图片
  left, // 图片在文字左侧
  right, // 图片在文字右侧
}

class ButtonChildWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String title;
  final TextStyle? titleStyle;
  final ButtonImagePosition? imagePosition;
  final Image? imageWidget; // 图片
  final double imageTitleGap; // 图片和文字之间的距离(imageWidget存在的时候才有效)

  ButtonChildWidget({
    Key? key,
    required this.title,
    this.width,
    this.height,
    this.titleStyle,
    this.imagePosition,
    this.imageWidget,
    this.imageTitleGap = 5,
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
              fontFamily: 'PingFang SC',
              // color: _currentTextColor, //不用设颜色，会自动使用外层样式
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }

  Widget get _childWidget_textAndImage {
    if (this.imagePosition == ButtonImagePosition.left) {
      return Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            this.imageWidget!,
            SizedBox(width: this.imageTitleGap),
            _childWidget_onlyText,
          ],
        ),
      );
    } else if (this.imagePosition == ButtonImagePosition.right) {
      return Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _childWidget_onlyText,
            SizedBox(width: this.imageTitleGap),
            this.imageWidget!,
          ],
        ),
      );
    } else {
      // if (this.imagePosition == ButtonImagePosition.none)
      return Container(
        constraints: width != null ? BoxConstraints(
            maxWidth: width!
        ) : null,
        child: _childWidget_onlyText,
      );
    }
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
