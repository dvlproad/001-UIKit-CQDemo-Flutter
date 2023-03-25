/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 13:50:59
 * @Description: 用户各种状态变化的事件
 */
/// 当前用户状态
enum UserLoginState {
  unlogin, // 未登录状态
  logined, // 已登录状态
  overdue, // 已登录但 token 过期
}

class UserDataEvent {
  final UserLoginState loginState;
  final bool? fromOverdue;

  UserDataEvent({required this.loginState, this.fromOverdue});
}

class UserCacheGetCompleteEvent {
  final UserLoginState? cacheLoginState;

  UserCacheGetCompleteEvent({this.cacheLoginState});
}

class PopAllLoginEvent {}

class LoginSuccessEvent {
  final String? phone;
  LoginSuccessEvent({this.phone});
}

class LogoutSuccessEvent {}

class TokenOverdueEvent {}

/// 用户从登录页面点击返回，通知tab切换到商城
class LoginPageBack {}
