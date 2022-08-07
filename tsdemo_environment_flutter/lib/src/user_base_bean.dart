/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-05 19:32:02
 * @Description: 用户基类
 */
import 'dart:convert' show json;
import 'package:flutter/foundation.dart';

//TODO:是否引入 JsonConvert 类

class UserBaseBean {
  String userId;
  String avatar;
  String nickname;

  UserBaseBean({
    @required this.userId,
    @required this.avatar,
    @required this.nickname,
  });

  UserBaseBean.fromJson(jsonRes) {
    if (jsonRes == null) {
      return;
    }
    userId = jsonRes['userId'];
    avatar = jsonRes['avatar'];
    nickname = jsonRes['nickName'];
  }

  @override
  String toString() {
    return '{"avatar": ${avatar != null ? json.encode(avatar) : 'null'},"userId": ${userId != null ? json.encode(userId) : 'null'},"nickname": ${nickname != null ? json.encode(nickname) : 'null'}}';
  }
}
