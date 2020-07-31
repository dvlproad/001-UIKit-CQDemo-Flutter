import 'dart:convert' show json;

import 'package:tsdemodemo_flutter/modules/user_bean.dart';

class RankingFullBean {
  num updateDate;
  List<RanklingRowBean> rows;
  RanklingMeBean me;

  RankingFullBean.fromParams({this.updateDate, this.rows, this.me});

  factory RankingFullBean(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? RankingFullBean._fromJson(json.decode(jsonStr))
          : RankingFullBean._fromJson(jsonStr);

  RankingFullBean._fromJson(jsonRes) {
    updateDate = jsonRes['updateDate'];
    rows = jsonRes['rows'] == null ? null : [];

    for (var rowsItem in rows == null ? [] : jsonRes['rows']) {
      rows.add(rowsItem == null ? null : RanklingRowBean._fromJson(rowsItem));
    }

    me = jsonRes['me'] == null ? null : RanklingMeBean._fromJson(jsonRes['me']);
  }

  @override
  String toString() {
    return '{"updateDate": $updateDate,"rows": $rows,"me": $me}';
  }
}

class RanklingRowBean {
  num fansCount;
  num followerCount;
  num influence;
  UserBean user;

  get influenceString {
    return influence.toString();
  }

  RanklingRowBean.fromParams(
      {this.fansCount, this.followerCount, this.influence, this.user});

  RanklingRowBean._fromJson(jsonRes) {
    fansCount = jsonRes['fansCount'];
    followerCount = jsonRes['followerCount'];
    influence = jsonRes['influence'];
    user = jsonRes['user'] == null ? null : UserBean(jsonRes['user']);
  }

  @override
  String toString() {
    return '{"fansCount": $fansCount,"followerCount": $followerCount,"influence": $influence,"user": $user}';
  }
}

class RanklingMeBean {
  num influence;
  num number;
  UserBean user;

  RanklingMeBean.fromParams({this.influence, this.number, this.user});

  get influenceString {
    return influence.toString();
  }

  RanklingMeBean._fromJson(jsonRes) {
    influence = jsonRes['influence'];
    number = jsonRes['number'];
    user = jsonRes['user'] == null ? null : UserBean(jsonRes['user']);
  }

  @override
  String toString() {
    return '{"influence": $influence,"number": $number,"user": $user}';
  }
}
