/*
 * @Author: dvlproad
 * @Date: 2022-04-15 14:43:36
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-02-03 11:57:12
 * @Description: 个人主页我的标签
 */
import 'package:flutter/foundation.dart';

class MineTagModel {
  final String tagName;
  final String tagIconName;

  MineTagModel({
    @required this.tagName,
    this.tagIconName,
  });
}
