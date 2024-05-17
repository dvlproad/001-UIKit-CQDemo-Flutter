/*
 * @Author: dvlproad
 * @Date: 2024-01-26 15:29:54
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-17 13:04:06
 * @Description: 
 */

/// regionId : 110000
/// regionName : "北京市"
/// level : 1
/// parentId : 0
/// childList : [{"regionId":110001,"regionName":"北京市","level":2,"parentId":110000,"childList":[{"regionId":110101,"regionName":"东城区","level":2,"parentId":110001,"childList":[],"postCode":"100010","shortName":"东城区","pinyinName":"DongChengQu","pinyinShortName":"DCQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110102,"regionName":"西城区","level":2,"parentId":110001,"childList":[],"postCode":"100032","shortName":"西城区","pinyinName":"XiChengQu","pinyinShortName":"XCQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110105,"regionName":"朝阳区","level":2,"parentId":110001,"childList":[],"postCode":"100011","shortName":"朝阳区","pinyinName":"ChaoYangQu","pinyinShortName":"CYQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110106,"regionName":"丰台区","level":2,"parentId":110001,"childList":[],"postCode":"100071","shortName":"丰台区","pinyinName":"FengTaiQu","pinyinShortName":"FTQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110107,"regionName":"石景山区","level":2,"parentId":110001,"childList":[],"postCode":"100071","shortName":"石景山区","pinyinName":"ShiJingShanQu","pinyinShortName":"SJSQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110108,"regionName":"海淀区","level":2,"parentId":110001,"childList":[],"postCode":"100091","shortName":"海淀区","pinyinName":"HaiDianQu","pinyinShortName":"HDQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110109,"regionName":"门头沟区","level":2,"parentId":110001,"childList":[],"postCode":"102300","shortName":"门头沟区","pinyinName":"MenTouGouQu","pinyinShortName":"MTGQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110111,"regionName":"房山区","level":2,"parentId":110001,"childList":[],"postCode":"102488","shortName":"房山区","pinyinName":"FangShanQu","pinyinShortName":"FSQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110112,"regionName":"通州区","level":2,"parentId":110001,"childList":[],"postCode":"101100","shortName":"通州区","pinyinName":"TongZhouQu","pinyinShortName":"TZQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110113,"regionName":"顺义区","level":2,"parentId":110001,"childList":[],"postCode":"101300","shortName":"顺义区","pinyinName":"ShunYiQu","pinyinShortName":"SYQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110114,"regionName":"昌平区","level":2,"parentId":110001,"childList":[],"postCode":"102200","shortName":"昌平区","pinyinName":"ChangPingQu","pinyinShortName":"CPQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110115,"regionName":"大兴区","level":2,"parentId":110001,"childList":[],"postCode":"102600","shortName":"大兴区","pinyinName":"DaXingQu","pinyinShortName":"DXQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110116,"regionName":"怀柔区","level":2,"parentId":110001,"childList":[],"postCode":"101400","shortName":"怀柔区","pinyinName":"HuaiRouQu","pinyinShortName":"HRQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110117,"regionName":"平谷区","level":2,"parentId":110001,"childList":[],"postCode":"101200","shortName":"平谷区","pinyinName":"PingGuQu","pinyinShortName":"PGQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110228,"regionName":"密云县","level":2,"parentId":110001,"childList":[],"postCode":"101500","shortName":"密云","pinyinName":"MiYun","pinyinShortName":"MY","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000},{"regionId":110229,"regionName":"延庆县","level":2,"parentId":110001,"childList":[],"postCode":"102100","shortName":"延庆","pinyinName":"YanQing","pinyinShortName":"YQ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000}],"postCode":"100000","shortName":"北京","pinyinName":"BeiJing","pinyinShortName":"BJ","isAvailable":1,"isDeleted":0,"createTime":1498719890000,"updateTime":1498719890000}]
/// postCode : "100000"
/// shortName : "北京"
/// pinyinName : "BeiJing"
/// pinyinShortName : "BJ"
/// isAvailable : 1
/// isDeleted : 0
/// createTime : 1498719890000
/// updateTime : 1498719890000

// Important: 实现泛型，子类的childList元素是子类，而不是 BaseCityModel
abstract class BaseCityModel<T extends BaseCityModel<T>> {
  final String regionId;
  final String regionName;
  final List<T>? children;

  BaseCityModel({
    required this.regionId,
    required this.regionName,
    this.children,
  });
}


/*

class AppCityModel extends BaseCityModel<AppCityModel> {
  final int? level;
  final int? parentId;
  final String? postCode;
  final String? shortName;
  final String? pinyinName;
  final String? pinyinShortName;
  final int? isAvailable;
  final int? isDeleted;

  final int? createTime;
  final int? updateTime;

  AppCityModel({
    required String regionId,
    required String regionName,
    List<AppCityModel>? children,
    this.level,
    this.parentId,
    this.postCode,
    this.shortName,
    this.pinyinName,
    this.pinyinShortName,
    this.isAvailable,
    this.isDeleted,
    this.createTime,
    this.updateTime,
  }) : super(
          regionId: regionId,
          regionName: regionName,
          children: children,
        );

  static AppCityModel fromJson(dynamic json) {
    List<AppCityModel>? children;
    if (json['childList'] != null) {
      children = [];
      json['childList'].forEach((v) {
        children?.add(AppCityModel.fromJson(v));
      });
    }

    return AppCityModel(
      regionId: ValueConvertUtil.stringFrom(json['regionId']),
      regionName: json['regionName'],
      level: json['level'],
      parentId: json['parentId'],
      children: children,
      postCode: json['postCode'],
      shortName: json['shortName'],
      pinyinName: json['pinyinName'],
      pinyinShortName: json['pinyinShortName'],
      isAvailable: json['isAvailable'],
      isDeleted: json['isDeleted'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['regionId'] = regionId;
    map['regionName'] = regionName;
    if (children != null) {
      List<Map> childListMaps = [];
      for (AppCityModel element in children!) {
        Map map = element.toJson();
        childListMaps.add(map);
      }
      map['childList'] = childListMaps;
    }

    map['level'] = level;
    map['parentId'] = parentId;
    map['postCode'] = postCode;
    map['shortName'] = shortName;
    map['pinyinName'] = pinyinName;
    map['pinyinShortName'] = pinyinShortName;
    map['isAvailable'] = isAvailable;
    map['isDeleted'] = isDeleted;
    map['createTime'] = createTime;
    map['updateTime'] = updateTime;
    return map;
  }
}

*/