/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-20 14:10:23
 * @Description: 用户各种状态变化的事件
 */
/// 当前用户状态
enum UserLoginState {
  unlogin, // 未登录状态
  logined, // 已登录状态
  overdue, // 已登录但 token 过期
}

class UserDataEvent {
  UserLoginState loginState;
  bool fromOverdue;

  UserDataEvent({this.loginState, this.fromOverdue});
}

class UserCacheGetCompleteEvent {
  UserLoginState cacheLoginState;

  UserCacheGetCompleteEvent({this.cacheLoginState});
}

class PopAllLoginEvent {}

class LoginSuccessEvent {
  String phone;
  LoginSuccessEvent({this.phone});
}

class LogoutSuccessEvent {}

class TokenOverdueEvent {}

/// 用户从登录页面点击返回，通知tab切换到商城
class LoginPageBack {}
