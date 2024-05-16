/*
 * @Author: dvlproad
 * @Date: 2024-05-11 09:51:58
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-11 14:09:19
 * @Description: 地图搜索附近选择的 poi
 */
import '../base_address_model.dart';

class NearbyAddressModel extends BaseAddressModel {
  final String name;
  final double latitude;
  final double longitude;

  NearbyAddressModel({
    required String provinceName,
    required String provinceCode,
    required String cityName,
    required String cityCode,
    required String areaName,
    required String areaCode,
    required String address,
    required this.name, // 比如 adress:xxx 1号  name:万达
    required this.latitude,
    required this.longitude,
  }) : super(
          provinceName: provinceName,
          provinceCode: provinceCode,
          cityName: cityName,
          cityCode: cityCode,
          areaName: areaName,
          areaCode: areaCode,
          address: address,
        );
}
