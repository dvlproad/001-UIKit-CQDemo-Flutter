/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-08 01:47:02
 * @Description: 
 */
import 'package:flutter/material.dart';

/// Icon 位于图片中心，可大小可定制的按钮
class CenterIconButton extends StatelessWidget {
  final String assestName; // 按钮的本地图片名
  final double iconButtonSize; // 按钮大小
  final double? iconImageSize; // 按钮中的图片大小
  final VoidCallback onPressed; // 按钮点击事件

  CenterIconButton({
    Key? key,
    required this.assestName,
    required this.iconButtonSize,
    this.iconImageSize,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _iconImageSize = iconImageSize ?? iconButtonSize;
    return Container(
      height: iconButtonSize,
      width: iconButtonSize,
      child: FlatButton(
        color: Colors.red,
        onPressed: this.onPressed,
        padding: EdgeInsets.fromLTRB(
          0,
          (iconButtonSize - _iconImageSize) / 2,
          0,
          (iconButtonSize - _iconImageSize) / 2,
        ),
        child: Image.asset(
          assestName,
          width: _iconImageSize,
          height: _iconImageSize,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
