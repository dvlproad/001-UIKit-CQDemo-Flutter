/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 11:39:17
 * @Description: 
 */
import 'package:flutter/material.dart';

/// Icon 位于图片中心，可大小可定制的按钮
class CenterIconButton extends StatelessWidget {
  final String assestName; // 按钮的本地图片名
  final double iconButtonSize; // 按钮大小
  final double iconImageSize; // 按钮中的图片大小
  final VoidCallback onPressed; // 按钮点击事件

  const CenterIconButton({
    Key? key,
    required this.assestName,
    required this.iconButtonSize,
    iconImageSize,
    required this.onPressed,
  })  : this.iconImageSize = iconImageSize ??
            iconButtonSize, // iconImageSize 没设置时候，使用 iconButtonSize
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: iconButtonSize,
      width: iconButtonSize,
      child: IconButton(
        color: Colors.red,
        onPressed: onPressed,
        padding: EdgeInsets.fromLTRB(
          0,
          (iconButtonSize - iconImageSize) / 2,
          0,
          (iconButtonSize - iconImageSize) / 2,
        ),
        icon: Image.asset(
          assestName,
          width: iconImageSize,
          height: iconImageSize,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
