class UserBaseBean {
  String uid;
  String authToken;
  String avatar;
  int sex;

  UserBaseBean({
    this.uid,
    this.authToken,
    this.avatar,
    this.sex,
  });

  UserBaseBean.fromJson(Map<String, dynamic> json) {
    if (json["userId"] is String) uid = json["userId"];
    if (json["accessToken"] is String) authToken = json["accessToken"];
    if (json["avatar"] is String) avatar = json["avatar"];
    if (json["sex"] is int) sex = json["sex"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["userId"] = uid;
    data["accessToken"] = authToken;
    data["avatar"] = avatar;

    data["sex"] = sex;
    return data;
  }

  // 是否是登录状态
  bool get hasLogin {
    if (null != uid && uid.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
