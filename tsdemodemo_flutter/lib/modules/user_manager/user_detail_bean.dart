import 'user_base_bean.dart';

class UserDetailBean extends UserBaseBean {
  String detailAddress;

  UserDetailBean({
    this.detailAddress,
    String uid,
    String authToken,
    String avatar,
    int sex,
  }) : super(
          uid: uid,
          authToken: authToken,
          avatar: avatar,
          sex: sex,
        );

  UserDetailBean.fromJson(Map<String, dynamic> json) {
    UserBaseBean baseBean = UserBaseBean.fromJson(json);
    uid = baseBean.uid;
    authToken = baseBean.authToken;
    avatar = baseBean.avatar;
    sex = baseBean.sex;

    detailAddress = json["detailAddress"];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data["detailAddress"] = detailAddress;
    return data;
  }

  @override
  String toString() {
    return '{"uid": $uid,"authToken": $authToken,"avatar": $avatar,"sex": $sex,"detailAddress": $detailAddress}';
  }
}
