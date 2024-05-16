/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-13 15:30:06
 * @Description: 位置数据模型
 */

///定位结果回调
///
///定位结果以map的形式透出，其中包含的key已经含义如下：
///
/// `callbackTime`:回调时间，格式为"yyyy-MM-dd HH:mm:ss"
///
/// `locationTime`:定位时间， 格式为"yyyy-MM-dd HH:mm:ss"
///
/// `locationType`:  定位类型， 具体类型可以参考https://lbs.amap.com/api/android-location-sdk/guide/utilities/location-type
///
/// `latitude`:纬度
///
/// `longitude`:精度
///
/// `accuracy`:精确度
///
/// `altitude`:海拔, android上只有locationType==1时才会有值
///
/// `bearing`: 角度，android上只有locationType==1时才会有值
///
/// `speed`:速度， android上只有locationType==1时才会有值
///
/// `country`: 国家，android上只有通过[AMapLocationOption.needAddress]为true时才有可能返回值
///
/// `province`: 省，android上只有通过[AMapLocationOption.needAddress]为true时才有可能返回值
///
/// `city`: 城市，android上只有通过[AMapLocationOption.needAddress]为true时才有可能返回值
///
/// `district`: 城镇（区），android上只有通过[AMapLocationOption.needAddress]为true时才有可能返回值
///
/// `street`: 街道，android上只有通过[AMapLocationOption.needAddress]为true时才有可能返回值
///
/// `streetNumber`: 门牌号，android上只有通过[AMapLocationOption.needAddress]为true时才有可能返回值
///
/// `cityCode`: 城市编码，android上只有通过[AMapLocationOption.needAddress]为true时才有可能返回值
///
/// `adCode`: 区域编码， android上只有通过[AMapLocationOption.needAddress]为true时才有可能返回值
///
/// `address`: 地址信息， android上只有通过[AMapLocationOption.needAddress]为true时才有可能返回值
///
/// `description`: 位置语义， android上只有通过[AMapLocationOption.needAddress]为true时才有可能返回值
///
/// `errorCode`: 错误码，当定位失败时才会返回对应的错误码， 具体错误请参考：https://lbs.amap.com/api/android-location-sdk/guide/utilities/errorcode
///
/// `errorInfo`: 错误信息， 当定位失败时才会返回
///
class BaseLocationModel {
  String? address;

  int? provinceId;
  String? province;

  int? cityId;
  String? city;

  int? districtId;
  String? district;

  int? provinceIndex;
  int? cityIndex;
  int? districtIndex;

  double? latitude;
  double? longitude;

  BaseLocationModel({
    this.address,
    this.provinceId,
    this.province,
    this.cityId,
    this.city,
    this.districtId,
    this.district,
    this.provinceIndex,
    this.cityIndex,
    this.districtIndex,
    this.longitude,
    this.latitude,
  });
}
