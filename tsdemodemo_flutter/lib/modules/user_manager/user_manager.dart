import 'package:event_bus/event_bus.dart';
import 'package:app_network/app_network.dart';
import 'package:flutter_cache_kit/flutter_cache_kit.dart';

import './user_detail_bean.dart';
import './user_event.dart';

EventBus eventBus = EventBus();

class UserManager {
  // 工厂模式
  factory UserManager() => _getInstance();
  static UserManager get instance => _getInstance();
  static UserManager _instance;
  static UserManager _getInstance() {
    _instance ??= UserManager._internal();
    return _instance;
  }

  UserManager._internal() {
    // 初始化
    _getCache();
  }

  // 获取缓存数据
  void _getCache() async {
    _userModel = await LocalStorage.getCustomBean(
      "user_cache_key",
      fromJson: (bMap) {
        return UserDetailBean.fromJson(bMap);
      },
    );
  }

  // 是否是登录状态
  static bool isLoginState() {
    UserDetailBean userModel = _instance._userModel;
    return userModel.hasLogin;
  }

  /// 退出登录，保存用户信息
  void logout() {
    userModel = null;
  }

  /// 登录成功，保存用户信息
  void loginSuccessWithUserMap(Map baseUserMap) {
    UserDetailBean baseUserModel;
    if (baseUserMap != null) {
      baseUserModel = UserDetailBean.fromJson(baseUserMap);
    } else {
      baseUserModel = null;
    }

    UserDetailBean newUserModel = _newUserWithNewBaseUserModel(baseUserModel);
    newUserModel.authToken = baseUserModel.authToken;

    userModel = newUserModel;
  }

  /// 已登录用户的 token 过期
  void overdueUserToken() {
    UserDetailBean newUserModel;
    if (_userModel == null) {
      // 之前未登录
    } else {
      // 之前已登录
      Map<String, dynamic> oldUserMap = _userModel.toJson();
      newUserModel = UserDetailBean.fromJson(oldUserMap);

      newUserModel.authToken = null;

      userModel = newUserModel;
    }
  }

  /// 获取用户信息成功，保存用户信息
  void getDetailSuccessWithUserMap(Map baseUserMap) {
    UserDetailBean baseUserModel;
    if (baseUserMap != null) {
      baseUserModel = UserDetailBean.fromJson(baseUserMap);
    } else {
      baseUserModel = null;
    }

    UserDetailBean newUserModel = _newUserWithNewBaseUserModel(baseUserModel);

    userModel = newUserModel;
  }

  /// 获取使用新的 baseUserModel 信息后，的新用户的信息(不会修改 authToken)
  UserDetailBean _newUserWithNewBaseUserModel(UserDetailBean baseUserModel) {
    UserDetailBean newUserModel;
    if (_userModel == null) {
      // 之前未登录
      newUserModel = baseUserModel;
    } else {
      // 之前已登录
      Map<String, dynamic> oldUserMap = _userModel.toJson();
      newUserModel = UserDetailBean.fromJson(oldUserMap);
      newUserModel.uid = baseUserModel.uid;
      newUserModel.avatar = baseUserModel.avatar;
      newUserModel.sex = baseUserModel.sex;
    }

    return newUserModel;
  }

  /// 更新用户信息
  UserDetailBean _userModel;
  UserDetailBean get userModel => _userModel;
  set userModel(UserDetailBean newUserModel) {
    UserDetailBean oldUserModel;
    if (_userModel == null) {
      oldUserModel = null;
    } else {
      Map<String, dynamic> oldUserMap = _userModel.toJson();
      oldUserModel = UserDetailBean.fromJson(oldUserMap);
    }

    _userModel = newUserModel;

    if (_userModel?.hasLogin == true) {
      LocalStorage.saveCustomBean(
        "user_cache_key",
        _userModel,
        valueToJson: (bItem) {
          return bItem.toJson();
        },
      );
    } else {
      LocalStorage.remove("user_cache_key");
    }

    _checkUserModel(oldUserModel, userModel);
  }

  void _checkUserModel(
    UserDetailBean oldUserModel,
    UserDetailBean newUserModel,
  ) async {
    bool newIsLogin = newUserModel?.hasLogin ?? false;
    bool oldIsLogin = oldUserModel?.hasLogin ?? false;

    UserLoginState loginState;
    if (newIsLogin != oldIsLogin) {
      loginState = newIsLogin ? UserLoginState.login : UserLoginState.logout;
    }

    String newToken = newUserModel?.authToken;
    String oldToken = oldUserModel?.authToken;
    if (newToken != oldToken) {
      AppNetworkManager().addOrUpdateToken(newToken);

      if (oldToken != null && newToken == null) {
        loginState = UserLoginState.tokenOverdue;
      }
    }

    UserDataEvent event = UserDataEvent(loginState: loginState);
    eventBus.fire(event);
  }
}
