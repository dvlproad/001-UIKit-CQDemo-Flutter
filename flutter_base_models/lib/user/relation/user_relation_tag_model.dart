/*
 * @Author: dvlproad
 * @Date: 2024-05-28 13:24:23
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 13:41:48
 * @Description: 
 */
import '../../pickers/base_choose_item_model.dart';

class UserRelationTagModel extends BaseChooseItemModel {
  UserRelationTagModel({
    required String id,
    required String name,
  }) : super(
          id: id,
          name: name,
        );
}
