/// 用户登录状态
enum UserLoginState {
  login, // 登录
  logout, // 登出
  tokenOverdue, // token 过期
}

/// 用户信息状态
class UserDataEvent {
  UserLoginState loginState;

  UserDataEvent({this.loginState});
}
