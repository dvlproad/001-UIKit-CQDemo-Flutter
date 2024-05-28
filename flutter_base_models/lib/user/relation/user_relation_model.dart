/*
 * @Author: dvlproad
 * @Date: 2024-05-28 13:30:31
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 13:39:47
 * @Description: 用户关系模型（参考：微信备注）
 */
import 'user_relation_tag_model.dart';

class UserRelationModel {
  String? noteName; // 备注名
  String? bewrite; // 描述
  List<String>? notePhones; // 备注电话，可以多个
  List<UserRelationTagModel>? tagModels; // 关系标签（同学、朋友、后者其他自定义的标签）

  UserRelationModel({
    this.noteName,
    this.bewrite,
    this.notePhones,
    this.tagModels,
  });
}
