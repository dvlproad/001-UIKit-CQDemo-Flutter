/*
 * @Author: dvlproad
 * @Date: 2024-05-11 09:52:45
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-11 15:58:15
 * @Description: 
 */
import 'area_picker/area_picker_address_model.dart';
import 'base_address_model.dart';
import 'map_poi/nearby_address_model.dart';

/// 地图搜索附近选择的 poi(NearbyAddressModel) 或 区域选择选择的位置(AreaPickerAddressModel)
class NearbyOrAreaPickerAddressModel extends BaseAddressModel {
  String? name;
  double? latitude;
  double? longitude;

  int? provinceIndex;
  int? cityIndex;
  int? areaIndex;

  NearbyOrAreaPickerAddressModel({
    required String provinceName,
    required String provinceCode,
    required String cityName,
    required String cityCode,
    required String areaName,
    required String areaCode,
    required String address,
    this.name,
    this.latitude,
    this.longitude,
    this.provinceIndex,
    this.cityIndex,
    this.areaIndex,
  }) : super(
          provinceName: provinceName,
          provinceCode: provinceCode,
          cityName: cityName,
          cityCode: cityCode,
          areaName: areaName,
          areaCode: areaCode,
          address: address,
        );

  static NearbyOrAreaPickerAddressModel fromNearbyAddressModel(
      NearbyAddressModel nearbyAddressModel) {
    return NearbyOrAreaPickerAddressModel(
      provinceName: nearbyAddressModel.provinceName,
      provinceCode: nearbyAddressModel.provinceCode,
      cityName: nearbyAddressModel.cityName,
      cityCode: nearbyAddressModel.cityCode,
      areaName: nearbyAddressModel.areaName,
      areaCode: nearbyAddressModel.areaCode,
      address: nearbyAddressModel.address,
      name: nearbyAddressModel.name,
      latitude: nearbyAddressModel.latitude,
      longitude: nearbyAddressModel.longitude,
    );
  }

  static NearbyOrAreaPickerAddressModel fromAreaPickerAddressModel(
      AreaPickerAddressModel areaPickerAddressModel) {
    return NearbyOrAreaPickerAddressModel(
      provinceName: areaPickerAddressModel.provinceName,
      provinceCode: areaPickerAddressModel.provinceCode,
      cityName: areaPickerAddressModel.cityName,
      cityCode: areaPickerAddressModel.cityCode,
      areaName: areaPickerAddressModel.areaName,
      areaCode: areaPickerAddressModel.areaCode,
      address: areaPickerAddressModel.address,
      name: areaPickerAddressModel.address, // 区域的 name 设为和 address 同值
      provinceIndex: areaPickerAddressModel.provinceIndex,
      cityIndex: areaPickerAddressModel.cityIndex,
      areaIndex: areaPickerAddressModel.areaIndex,
    );
  }
}
