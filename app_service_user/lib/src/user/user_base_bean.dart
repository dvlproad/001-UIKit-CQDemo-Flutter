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
  int consumerLevel;

  UserBaseBean({
    @required this.userId,
    @required this.avatar,
    @required this.nickname,
    this.consumerLevel
  });

  UserBaseBean.fromJson(jsonRes) {
    if (jsonRes == null) {
      return;
    }
    userId = jsonRes['userId']??jsonRes['accountId'];
    avatar = jsonRes['avatar'];
    nickname = jsonRes['nickName']??jsonRes['nickname']??jsonRes['userName'];
    consumerLevel = jsonRes['consumerLevel']??0;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['accountId'] = userId;
    map['avatar'] = avatar;
    map['nickname'] = nickname;
    map['consumerLevel'] = consumerLevel;
    return map;
  }

  @override
  String toString() {
    return '{"avatar": ${avatar != null ? json.encode(avatar) : 'null'},"userId": ${userId != null ? json.encode(userId) : 'null'},"nickname": ${nickname != null ? json.encode(nickname) : 'null'}}';
  }
}
