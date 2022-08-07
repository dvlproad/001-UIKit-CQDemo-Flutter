/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-02 10:55:31
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

import '../app_info_choose_kit_adapt.dart';

class AppImageTitleTextValueCell extends StatelessWidget {
  final double leftRightPadding; // cell 内容的左右间距(未设置时候，默认20)
  final double leftMaxWidth;
  final double rightMaxWidth;
  String title;
  ImageProvider imageProvider;
  String textValue;
  String textValuePlaceHodler;
  void Function() onTap;

  AppImageTitleTextValueCell({
    Key key,
    this.leftRightPadding,
    this.leftMaxWidth,
    this.rightMaxWidth,
    this.title,
    this.imageProvider,
    this.textValue,
    this.textValuePlaceHodler,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageTitleTextValueCell(
      height: 52.h_pt_cj,
      leftMaxWidth: leftMaxWidth,
      rightMaxWidth: rightMaxWidth,
      leftRightPadding: leftRightPadding,
      title: title,
      imageProvider: imageProvider,
      imageWith: 22.w_pt_cj,
      imageTitleSpace: 10.w_pt_cj,
      textValue: textValue,
      textValuePlaceHodler: textValuePlaceHodler,
      onTap: onTap,
    );
  }
}
