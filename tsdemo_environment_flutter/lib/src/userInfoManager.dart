/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-08 01:24:01
 * @Description: 
 */
import './user_base_bean.dart';
import 'package:flutter_cache_kit/flutter_cache_kit.dart';

class UserInfoManager {
  // 工厂模式
  factory UserInfoManager() => _getInstance();
  static UserInfoManager get instance => _getInstance();
  static UserInfoManager _instance;
  static UserInfoManager _getInstance() {
    _instance ??= UserInfoManager._internal();
    return _instance;
  }

  UserInfoManager._internal() {
    // 初始化
  }

  User_manager_bean _userModel;
  User_manager_bean get userModel => _userModel;

  // 是否是登录状态
  static bool get isLoginState {
    _instance ??= UserInfoManager();
    User_manager_bean userModel = _instance._userModel;
    return userModel?.hasLogin ?? false;
  }

  ///用户退出登录
  Future<bool> userLoginOut() async {
    return true;
  }

  /// 退出登录，保存用户信息
  void logout() {
    userModel = null;
  }

  set userModel(User_manager_bean newUserModel) {
    _userModel = newUserModel;
  }

  Future<String> getCacheUserAuthToken() async {
    User_manager_bean userModel_cache = await LocalStorage.getCustomBean(
      "user_cache_key",
      fromJson: (bMap) {
        return User_manager_bean.fromJson(bMap);
      },
    );

    String cacheUserAuthToken = userModel_cache?.authToken;
    return cacheUserAuthToken;
  }
}

class User_manager_bean extends UserBaseBean {
  String authToken;
  String tel;

  // 是否是登录状态
  bool get hasLogin {
    var uid = userId; // 兼容null
    if (null != uid && uid.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static User_manager_bean fromJson(Map<String, dynamic> json) {
    return User_manager_bean();
  }
}
