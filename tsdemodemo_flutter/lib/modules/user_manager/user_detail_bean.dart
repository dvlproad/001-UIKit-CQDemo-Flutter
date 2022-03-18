import 'user_base_bean.dart';

class UserDetailBean extends UserBaseBean {
  String detailAddress;

  UserDetailBean({
    String detailAddress,
    String uid,
    String authToken,
    String avatar,
    int sex,
  }) : super(
          uid: uid,
          authToken: authToken,
          avatar: avatar,
          sex: sex,
        ) {
    this.detailAddress = detailAddress;
  }

  UserDetailBean.fromJson(Map<String, dynamic> json) {
    UserBaseBean.fromJson(json);

    detailAddress = json["detailAddress"];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data["detailAddress"] = this.detailAddress;
    return data;
  }
}
