/*
 * @Author: dvlproad
 * @Date: 2024-03-07 16:39:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 11:09:50
 * @Description: 
 */

import 'dart:async';
import 'package:flutter_cache_kit/flutter_cache_kit.dart';

import '../../user/user_base_model.dart';
import './user_event.dart';
import './user_cache_protocal.dart';

abstract class BaseUserManager<T extends UserBaseModel>
    with UserCacheProtocal<T> {
  T? _oldUserModel; // 增加上次登录用户的信息保存，用于未登录时候追踪用户的日志输出
  T? get oldLoginUserModel => _oldUserModel;

  T? _userModel;
  T? get userModel => _userModel;

  /// 发送通知--1、用户缓存数据获取完成
  fireCacheGetCompleteEvent(UserCacheGetCompleteEvent event);

  /// 发送通知--2、用户登录状态变更
  fireUserLoginStateChangeEvent(UserLoginStateChangeEvent event);

  /// 退出登录
  void logout() {
    // userModel = null; 会触发 set userModel(T? newUserModel); 方法，并在其内部判断状态变化后发出正确的通知
    userModel = null;
  }

  // 用户数据的缓存
  // Future<bool> requestSaveCacheUser(String cacheUserKey, T? value);
  // Future<T?> requestGetCacheUser(String cacheUserKey);
  // Future<bool> requestRemoveCacheUser(String cacheUserKey);
  Future<bool> requestSaveCacheUser(String cacheUserKey, T? value) {
    return LocalStorage.saveCustomBean(
      cacheUserKey,
      value,
      valueToJson: (T bItem) {
        return toCacheJson(bItem);
      },
    );
  }

  Future<T?> requestGetCacheUser(String cacheUserKey) {
    return LocalStorage.getCustomBean(
      cacheUserKey,
      fromJson: (bMap) {
        return fromUserCacheJson(bMap);
      },
    );
  }

  Future<bool> requestRemoveCacheUser(String cacheUserKey) {
    return LocalStorage.remove(cacheUserKey);
  }

  Future<String?> getCacheUserAuthToken() async {
    T? userModelCache = await requestGetCacheUser("user_cache_key");

    String? cacheUserAuthToken = userModelCache?.authToken;
    return cacheUserAuthToken;
  }

  // 获取缓存数据(只能在初始化 manager 的时候执行一次)
  Future<void> getCurrentAndOldCacheUser() async {
    _userModel = await requestGetCacheUser("user_cache_key");
    _oldUserModel = await requestGetCacheUser("old_user_cache_key");
    if (!initCompleter.isCompleted) {
      initCompleter.complete('获取上次退出的缓存用户数据成功');
    }

    /// 完成获取上次退出后登录信息时发送通知
    UserLoginState cacheLoginState =
        _userModel?.loginState ?? UserLoginState.unlogin;
    UserCacheGetCompleteEvent event = UserCacheGetCompleteEvent(
      cacheLoginState: cacheLoginState,
    );
    fireCacheGetCompleteEvent(event);
  }

  /// BaseUserManager 的实现类会调用此方法
  set userModel(T? newUserModel) {
    T? oldUserModel;
    if (_userModel == null) {
      oldUserModel = null;

      requestRemoveCacheUser("old_user_cache_key");
    } else {
      Map<String, dynamic> oldUserMap = toCacheJson(_userModel!);
      oldUserModel = fromUserCacheJson(oldUserMap);
      requestSaveCacheUser("old_user_cache_key", oldUserModel);
    }
    _oldUserModel = oldUserModel;

    _userModel = newUserModel;

    if (_userModel?.hasLogin == true) {
      requestSaveCacheUser("user_cache_key", _userModel);
    } else {
      requestRemoveCacheUser("user_cache_key");
    }

    _checkUserModel(oldUserModel, userModel);
  }

  void _checkUserModel(
    T? oldUserModel,
    T? newUserModel,
  ) async {
    UserLoginState newLoginState =
        newUserModel?.loginState ?? UserLoginState.unlogin;
    UserLoginState oldLoginState =
        oldUserModel?.loginState ?? UserLoginState.unlogin;
    if (newLoginState != oldLoginState) {
      bool? fromOverdue = oldUserModel?.isTokenOvdue;
      UserLoginStateChangeEvent event = UserLoginStateChangeEvent(
        loginState: newLoginState,
        fromOverdue: fromOverdue,
      );
      fireUserLoginStateChangeEvent(event);
    }

    // 已放到 用户登录状态 变化的通知中处理
    // String? newToken = newUserModel?.authToken;
    // String? oldToken = oldUserModel?.authToken;
    // if (newToken != oldToken) {
    //   AppNetworkManager().updateToken(newToken);
    // }
  }

  Completer initCompleter = Completer<String>();
  // 是否是登录状态
  Future<bool> get isLogin async {
    await initCompleter.future;
    return _userModel?.hasLogin ?? false;
  }

  /// 根据登录状态，提供给监控系统(日志系统、Bugly、火山等) 的用户描述(含用户名、id、手机号)
  Future<String> get userLogDescription async {
    bool isLoginState = await isLogin;
    return getUserLogDescription(isLoginState);
  }

  String getUserLogDescription(bool isLogin) {
    if (isLogin) {
      T? user = userModel;
      // if (user == null) {
      //   debugPrint("已登录的用户，这个值可能为空");
      //   return;
      // }
      String userDescribe = user!.userLogId;
      return userDescribe;
    } else {
      T? user = oldLoginUserModel;
      if (user != null) {
        String userDescribe = user.userLogId;
        return "上次登录($userDescribe)";
      } else {
        return '从未登录的用户';
      }
    }
  }
}
