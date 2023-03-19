/*
 * @Author: dvlproad
 * @Date: 2023-01-30 11:55:19
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 14:14:20
 * @Description: 
 */
// ignore_for_file: file_names

import 'dart:convert';
import '../user_manager.dart';
export '../user_manager.dart';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

extension Other on UserInfoManager {
  bool get isLogin => userModel?.hasLogin == true;

  Future<User_manager_bean> getUserInfo() async {
    return userModel;
  }

  Future<String> getToken() async {
    return userModel?.authToken;
  }
}
