/*
 * @Author: dvlproad
 * @Date: 2024-05-11 09:40:20
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-11 18:21:11
 * @Description: 基础的位置数据模型（兼容地图搜索附近选择的 poi(NearbyAddressModel) 或 区域选择选择的位置(AreaPickerAddressModel))
 */

abstract class BaseAddressModel {
  String provinceName;
  String provinceCode;

  String cityName;
  String cityCode;

  String areaName;
  String areaCode;

  String address;

  BaseAddressModel({
    required this.provinceName,
    required this.provinceCode,
    required this.cityName,
    required this.cityCode,
    required this.areaName,
    required this.areaCode,
    required this.address,
  });
}
