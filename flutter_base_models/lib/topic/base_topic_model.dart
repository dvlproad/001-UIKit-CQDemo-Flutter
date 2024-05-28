/*
 * @Author: dvlproad
 * @Date: 2024-05-28 13:08:38
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 13:24:34
 * @Description: 
 */

import '../pickers/base_choose_item_model.dart';

class BaseTopicModel extends BaseChooseItemModel {
  String? summary; // 话题简介
  String? coverImageUrl; // 话题封面图
  String? link; // 话题链接（可能①为空，使用id跳转；②为http链接；③app路由）

  BaseTopicModel({
    required String id,
    required String name,
    this.summary,
    this.coverImageUrl,
    this.link,
  }) : super(
          id: id,
          name: name,
        );
}
