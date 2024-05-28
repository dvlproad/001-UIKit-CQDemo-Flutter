/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 11:03:55
 * @Description: 用户各种状态变化的事件
 */
/// 当前用户状态
enum UserLoginState {
  unlogin, // 未登录状态
  logined, // 已登录状态
  overdue, // 已登录但 token 过期，一般都在请求接口的时候，后台通过请求结果告知。且出现该结果要直接退出登录并跳到请登录页面，所以不会有此状态
}

/// 用户登录状态变化的通知事件(状态变化的时候，必然伴随用户 token 的变更，请务必更新网络库的 token 值)
class UserLoginStateChangeEvent {
  UserLoginState? loginState;
  bool? fromOverdue;

  UserLoginStateChangeEvent({required this.loginState, this.fromOverdue});
}

// /// 用户 token 变更，需要更新网络库的 token （常见场景：登录状态变化时候 token 变化)
// class UserTokenChangeEvent {
//   final String? newToken;
//   final String? oldToken;

//   UserTokenChangeEvent({this.newToken, this.oldToken});
// }

class UserCacheGetCompleteEvent {
  UserLoginState? cacheLoginState;

  UserCacheGetCompleteEvent({this.cacheLoginState});
}
