/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-16 15:21:41
 * @Description: 用户基类
 */
class UserBaseModel {
  String? userId;
  String? avatar;
  String? nickname;
  int? sex;

  UserBaseModel({
    this.userId,
    this.avatar,
    this.nickname,
    this.sex,
  });
}
