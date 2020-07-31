import 'dart:convert' show json;


class UserBean {
  num grade;
  // bool isFollow;
  String avatar;
  String id;
  String nickName;

  UserBean.fromParams({this.grade, this.avatar, this.id, this.nickName});

  factory UserBean(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? UserBean._fromJson(json.decode(jsonStr))
          : UserBean._fromJson(jsonStr);

  UserBean._fromJson(jsonRes) {
    grade = jsonRes['grade'];
    // isFollow = jsonRes['isFollow'];
    avatar = jsonRes['avatar'];
    id = jsonRes['id'];
    nickName = jsonRes['nickName'];
  }


  @override
  String toString() {
    return '{"grade": $grade,"avatar": ${avatar != null ? '${json.encode(avatar)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"nickName": ${nickName != null ? '${json.encode(nickName)}' : 'null'}}';
  }
}