class UserInfoManager {
  // 是否是登录状态
  static bool isLoginState() {
    String uid = '123';
    if (null != uid && uid.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  ///用户退出登录
  Future<bool> userLoginOut() async {
    return true;
  }
}
