/*
 * ranking_list_bean.dart
 *
 * @Description: 排名列表的单元数据模型
 *
 * @author      ciyouzen
 * @email       dvlproad@163.com
 * @date        2020/7/28 10:51
 *
 * Copyright (c) dvlproad. All rights reserved.
 */

import 'dart:convert' show json;

/// 排名列表的单元数据模型
class RankingBean {
  String id;
  String nickName; // 用户名
  String avatar; // 头像
  int fansCount; // 粉丝数
  int followerCount; // 关注数
  int influence; // 影响力

  RankingBean(
      {this.id = '',
      this.nickName = '',
      this.avatar = '',
      this.fansCount = 0,
      this.followerCount = 0,
      this.influence = 0})
      : super();

  //factory RankingBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? RankingBean._fromJson(json.decode(jsonStr)) : RankingBean._fromJson(jsonStr);
  factory RankingBean.fromJson(jsonStr) {
    if (jsonStr == null) {
      return null;
    }

    Map<String, dynamic> beanMap = Map();
    if (jsonStr is String) {
      beanMap = json.decode(jsonStr);
    }
    if (jsonStr is Map) {
      beanMap = jsonStr;
    }

    RankingBean _rankingBean = RankingBean._fromJson(beanMap);
    return _rankingBean;
  }

  RankingBean._fromJson(Map<String, dynamic> beanMap) {
    id = beanMap['id'] ?? '';

    //nickName2 = beanMap['user']['nickName'] ?? '';   //用户名
    nickName = ''; //用户名
    avatar = ''; // 头像
    if (null != beanMap['user']) {
      Map<String, dynamic> userMap = beanMap['user'];
      nickName = userMap['nickName'] ?? '';
      avatar = userMap['avatar'] ?? '';
    }

    fansCount = beanMap['fansCount'] ?? 0; //粉丝数
    followerCount = beanMap['followerCount'] ?? 0; //关注数
    influence = beanMap['influence'] ?? 0; //影响力
  }
//  factory RankingBean._fromJson(Map<String, dynamic> beanMap) {
//    String _id = beanMap['id'] ?? '';
//
//    //String _nickName2 = beanMap['user']['nickName'] ?? '';   //用户名
//    String _nickName = '';   //用户名
//    if(null != beanMap['user']) {
//      _nickName = beanMap['user']['nickName'] ?? '';
//    }
//    int _fansCount = beanMap['fansCount'] ?? 0;          //粉丝数
//    int _followerCount = beanMap['followerCount'] ?? 0;  //关注数
//    int _influence = beanMap['influence'] ?? 0;          //影响力
//
//    return RankingBean(
//        id: _id,
//        nickName: _nickName,
//        fansCount: _fansCount,
//        followerCount: _followerCount,
//        influence: _influence
//    );
//  }

  // ignore: unused_element
  Map<String, dynamic> _toJson() {
    return {
      'id': id,
      'nickName': nickName,
      'fansCount': fansCount,
      'followerCount': followerCount,
      'influence': influence,
    };
  }

  @override
  String toString() {
    return '{"id": $id,"nickName": ${nickName != null ? '$nickName' : 'null'},"fansCount": $fansCount,"followerCount": $followerCount,"influence": $influence}';
  }
}

/// 排名列表的列表数据模型
class RankingListBean {
  List<RankingBean> beans;

  RankingListBean({this.beans});

  factory RankingListBean.fromJson(List beanMaps) {
    if (beanMaps == null) {
      return null;
    }

    RankingListBean _rankingListBean = RankingListBean._fromJson(beanMaps);
    return _rankingListBean;
  }

  RankingListBean._fromJson(List beanMaps) {
    List<RankingBean> _beans = [];
    for (var beanMap in beanMaps ?? []) {
      RankingBean rankingBean = RankingBean.fromJson(beanMap);
      if (rankingBean == null) {
        print('rankingBean == null');
      }
      _beans.add(rankingBean);
    }
    beans = _beans;
  }

  @override
  String toString() {
    return '{"beans": $beans}';
  }
}
