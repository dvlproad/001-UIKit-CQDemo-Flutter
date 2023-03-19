import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:app_devtool_framework/app_devtool_framework.dart';
import 'package:app_network/app_network.dart';
import 'package:flutter_cache_kit/flutter_cache_kit.dart';
// import 'package:wish/common/event_bus.dart';
// import 'package:wish/module/im/app_im_util.dart';
import 'package:app_service_user/app_service_user.dart';

import './user_event.dart';
import './user_detail_bean.dart';
export './user_detail_bean.dart';

class UserInfoManager {
  Completer initCompleter = Completer<String>();
  // 工厂模式
  factory UserInfoManager() => _getInstance();
  static UserInfoManager get instance => _getInstance();
  static UserInfoManager _instance;
  static UserInfoManager _getInstance() {
    _instance ??= UserInfoManager._internal();
    return _instance;
  }

  /// im登录后获取到的即时通讯专用的userId
  /// 登录态下打开app注册 ｜ 登录成功后注册
  static String imUserId = '';
  static String userSign = '';

  EventBus eventBus = EventBus();

  UserInfoManager._internal() {
    // 初始化
    _getCache();
  }

  // 获取缓存数据
  void _getCache() async {
    _userModel = await LocalStorage.getCustomBean(
      "user_cache_key",
      fromJson: (bMap) {
        return User_manager_bean.fromJson(bMap);
      },
    );
    _oldUserModel = await LocalStorage.getCustomBean(
      "old_user_cache_key",
      fromJson: (bMap) {
        return User_manager_bean.fromJson(bMap);
      },
    );
    if (!initCompleter.isCompleted) {
      initCompleter.complete('获取上次退出的缓存用户数据成功');
    }

    /// 完成获取上次退出后登录信息时发送通知
    UserLoginState cacheLoginState =
        _userModel?.loginState ?? UserLoginState.unlogin;
    UserCacheGetCompleteEvent event = UserCacheGetCompleteEvent(
      cacheLoginState: cacheLoginState,
    );
    eventBus.fire(event);
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

  // 是否是登录状态
  static bool get isLoginState {
    _instance ??= UserInfoManager();
    User_manager_bean userModel = _instance._userModel;
    return userModel?.hasLogin ?? false;
  }

  Future<bool> get isLogin async {
    await initCompleter.future;
    return _userModel?.hasLogin ?? false;
  }

  /// 退出登录，保存用户信息
  void logout() {
    userModel = null;
    AppNetworkManager().updateToken(null);
  }

  /// 登录成功，保存用户信息
  void loginSuccessWithUserMap(Map baseUserMap) {
    User_manager_bean baseUserModel;
    bool exsitToken = false;
    if (baseUserMap != null) {
      baseUserModel = User_manager_bean.fromJson(baseUserMap);
      if (baseUserMap.containsKey('headerValue')) {
        exsitToken = true;
      }
    } else {
      baseUserModel = null;
    }

    User_manager_bean newUserModel =
        _newUserWithNewBaseUserModel(baseUserModel, exsitToken);
    // newUserModel.authToken = baseUserModel.authToken;

    userModel = newUserModel;
  }

  /// 获取用户信息成功，保存用户信息
  void getDetailSuccessWithUserMap(Map baseUserMap) {
    User_manager_bean baseUserModel;
    bool exsitToken = false;
    if (baseUserMap != null) {
      baseUserModel = User_manager_bean.fromJson(baseUserMap);
      if (baseUserMap.containsKey('headerValue')) {
        exsitToken = true;
      }
    } else {
      baseUserModel = null;
    }

    User_manager_bean newUserModel =
        _newUserWithNewBaseUserModel(baseUserModel, exsitToken);

    userModel = newUserModel;
  }

  /// 获取使用新的 baseUserModel 信息后，的新用户的信息(不会修改 authToken)
  User_manager_bean _newUserWithNewBaseUserModel(
      User_manager_bean baseUserModel, bool exsitToken) {
    User_manager_bean newUserModel;
    if (_userModel == null) {
      // 之前未登录
      newUserModel = baseUserModel;
    } else {
      // 之前已登录
      newUserModel = baseUserModel;
      if (exsitToken != true) {
        newUserModel.authToken = _userModel.authToken;
      }
      newUserModel.privacy_mode = _userModel.privacy_mode;

      /*
      Map<String, dynamic> oldUserMap = _userModel.toJson();
      newUserModel = User_manager_bean.fromJson(oldUserMap);

      newUserModel.id = baseUserModel.id;
      newUserModel.tel = baseUserModel.tel;
      newUserModel.privacy_mode = baseUserModel.privacy_mode;
      newUserModel.address = baseUserModel.address;
      newUserModel.anchorNo = baseUserModel.anchorNo;
      newUserModel.areaId = baseUserModel.areaId;
      newUserModel.auditState = baseUserModel.auditState;
      newUserModel.authMode = baseUserModel.authMode;
      newUserModel.authNo = baseUserModel.authNo;
      newUserModel.avatar = baseUserModel.avatar;
      newUserModel.birthday = baseUserModel.birthday;
      newUserModel.cardBack = baseUserModel.cardBack;
      newUserModel.cardFront = baseUserModel.cardFront;
      newUserModel.cardNum = baseUserModel.cardNum;
      newUserModel.cityId = baseUserModel.cityId;
      newUserModel.createUserId = baseUserModel.createUserId;
      newUserModel.gmtCreate = baseUserModel.gmtCreate;
      newUserModel.gmtModified = baseUserModel.gmtModified;
      newUserModel.handCard = baseUserModel.handCard;
      newUserModel.intro = baseUserModel.intro;
      newUserModel.modifyUserId = baseUserModel.modifyUserId;
      newUserModel.nickname = baseUserModel.nickname;
      newUserModel.provinceId = baseUserModel.provinceId;
      newUserModel.levelValue = baseUserModel.levelValue;
      newUserModel.remark = baseUserModel.remark;
      newUserModel.sex = baseUserModel.sex;
      newUserModel.state = baseUserModel.state;
      newUserModel.userId = baseUserModel.userId;
      newUserModel.userSource = baseUserModel.userSource;
      newUserModel.userType = baseUserModel.userType;
      */
    }

    return newUserModel;
  }

  void overdueUserToken() {
    if (_userModel == null) {
      print('token过期，只会发生在已登录状态下，所以走到此方法，肯定是哪里数据出错了，请检查');
      return;
    }

    Map<String, dynamic> oldUserMap = _userModel.toJson();
    User_manager_bean newUserModel = User_manager_bean.fromJson(oldUserMap);
    newUserModel.authToken = 'token_overdue';
    // newUserModel.isTokenOvdue = true;

    userModel = newUserModel;
  }

  /// 提供给监控系统(日志系统、Bugly等)
  String get userDescription {
    if (isLoginState) {
      User_manager_bean user = userModel;
      String userDescribe = "${user.nickname ?? ''}(${user.tel ?? ''})";
      return userDescribe;
    } else {
      User_manager_bean user = oldLoginUserModel;
      if (user != null) {
        String userDescribe = "${user.nickname ?? ''}(${user.tel ?? ''})";
        return "上次登录($userDescribe)";
      }

      return '从未登录';
    }
  }

  User_manager_bean _oldUserModel; // 增加上次登录用户的信息保存，用于未登录时候追踪用户的日志输出
  User_manager_bean get oldLoginUserModel => _oldUserModel;

  User_manager_bean _userModel;
  User_manager_bean get userModel => _userModel;
  set userModel(User_manager_bean newUserModel) {
    User_manager_bean oldUserModel;
    if (_userModel == null) {
      oldUserModel = null;

      LocalStorage.remove("old_user_cache_key");
    } else {
      Map<String, dynamic> oldUserMap = _userModel.toJson();
      oldUserModel = User_manager_bean.fromJson(oldUserMap);

      LocalStorage.saveCustomBean(
        "old_user_cache_key",
        oldUserModel,
        valueToJson: (bItem) {
          return bItem.toJson();
        },
      );
    }
    _oldUserModel = oldUserModel;

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
    User_manager_bean oldUserModel,
    User_manager_bean newUserModel,
  ) async {
    UserLoginState newLoginState =
        newUserModel?.loginState ?? UserLoginState.unlogin;
    UserLoginState oldLoginState =
        oldUserModel?.loginState ?? UserLoginState.unlogin;
    if (newLoginState != oldLoginState) {
      bool fromOverdue = oldUserModel?.isTokenOvdue;
      UserDataEvent event =
          UserDataEvent(loginState: newLoginState, fromOverdue: fromOverdue);
      eventBus.fire(event);

      if (newLoginState == UserLoginState.logined) {
        // eventBus.fire(LoginSuccessEvent());
      } else if (newLoginState == UserLoginState.unlogin) {
        eventBus.fire(LogoutSuccessEvent());
      } else if (newLoginState == UserLoginState.overdue) {
        eventBus.fire(TokenOverdueEvent());
      }
    }

    String newToken = newUserModel?.authToken;
    String oldToken = oldUserModel?.authToken;
    if (newToken != oldToken) {
      AppNetworkManager().updateToken(newToken);
    }
  }
}
