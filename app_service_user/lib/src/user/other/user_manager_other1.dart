/*
 * @Author: dvlproad
 * @Date: 2023-01-30 11:55:19
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 14:14:20
 * @Description: 
 */
// ignore_for_file: file_names

import '../user_manager.dart';
export '../user_manager.dart';

extension Other on UserInfoManager {
  bool get isLogin => userModel.hasLogin == true;

  Future<User_manager_bean> getUserInfo() async {
    return userModel;
  }

  Future<String?> getToken() async {
    return userModel.authToken;
  }
}
