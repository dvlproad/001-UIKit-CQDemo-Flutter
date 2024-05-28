/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 12:54:17
 * @Description: 用户基类
 */
import '../services/user/user_event.dart';
// import '../services/user/user_update_protocal.dart';

// 1、如果基类定义为 abstract 则子类无法使用 UserDetailModel.fromJson(Map<String, dynamic> json) 只能用 static UserDetailModel fromJson(Map<String, dynamic> json) 方法。
// abstract class UserBaseModel<T extends UserBaseModel<T>> with UserUpdateProtocal<T> {
class UserBaseModel {
  String userId;
  String nickname;
  String? avatar; // 不使用 final 怕有些地方需要修改头像
  int? sex;
  String? authToken; // 用户的token，一般只有登录接口才会返回。如果是过期，则一般也只会在请求接口的结果中告知是过期错误
  String? tel; // 现在的app都邀请绑定手机号了，但是服务端不一定每个地方都会返回

  UserBaseModel({
    required this.userId,
    required this.nickname,
    this.avatar,
    this.sex,
    this.authToken,
    this.tel,
  });

  /// 提供给监控系统(日志系统、Bugly、火山等) 的用户描述(含用户名、id、手机号)
  String get userLogId {
    String userName = nickname;
    String phone = tel ?? 'nophone';
    String userDescribe = "$userName($phone)-$userId";
    return userDescribe;
  }

  // 是否是登录状态【请不要直接调用此方法，请调用 Manager 中的 isLogin 方法，以保证初始化完成】
  bool get hasLogin {
    if (userId.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  /// 是否是token过期(常见于:异地登录/多设备登录)
  bool get isTokenOvdue => authToken == 'token_overdue';

  UserLoginState get loginState {
    if (hasLogin == true) {
      return isTokenOvdue == true
          ? UserLoginState.overdue
          : UserLoginState.logined;
    } else {
      return UserLoginState.unlogin;
    }
  }
}
