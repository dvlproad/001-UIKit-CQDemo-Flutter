/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-28 15:49:56
 * @Description: 位置数据模型
 */
class LocationBean {
  late double? latitude;
  late double? longitude;
  late String? address;

  LocationBean({
    this.longitude,
    this.latitude,
    this.address,
  });

  LocationBean.fromJson(dynamic json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (latitude != null) {
      map['latitude'] = latitude!;
    }

    if (longitude != null) {
      map['longitude'] = longitude!;
    }

    if (address != null) {
      map['address'] = address!;
    }

    return map;
  }
}
