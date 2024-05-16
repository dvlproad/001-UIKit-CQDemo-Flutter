/*
 * @Author: dvlproad
 * @Date: 2024-05-11 09:51:24
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-15 18:50:08
 * @Description: 区域选择选择的位置
 */
import '../base_address_model.dart';
import './base_area_picker_model.dart';

class AreaPickerSelectedIndexsModel {
  final int? provinceIndex;
  final int? cityIndex;
  final int? districtIndex;

  AreaPickerSelectedIndexsModel({
    this.provinceIndex, // 选中的省份的index
    this.cityIndex, // 选中的市的index
    this.districtIndex, // 选中的区的index
  });

  @override
  String toString() {
    return "${provinceIndex ?? 0}, ${cityIndex ?? 0}, ${districtIndex ?? 0}";
  }
}

class AreaPickerAddressModel extends BaseAddressModel {
  final int provinceIndex;
  final int cityIndex;
  final int areaIndex;

  AreaPickerAddressModel({
    required String provinceName,
    required String provinceCode,
    required String cityName,
    required String cityCode,
    required String areaName,
    required String areaCode,
    required String address,
    required this.provinceIndex,
    required this.cityIndex,
    required this.areaIndex,
  }) : super(
          provinceName: provinceName,
          provinceCode: provinceCode,
          cityName: cityName,
          cityCode: cityCode,
          areaName: areaName,
          areaCode: areaCode,
          address: address,
        );

  static AreaPickerAddressModel fromSelectedIndex<T extends BaseCityModel<T>>({
    required List<T> provinceModels,
    required List<T> cityModels,
    required List<T> districtModels,
    required bool shouldAddAllProvinceItem,
    required bool shouldAddAllCityItem,
    required bool shouldAddAllAreaItem,
    required int proviceIndex,
    required int cityIndex,
    required int districtIndex,
  }) {
    String provinceName;
    String provinceCode;
    if (shouldAddAllProvinceItem) {
      if (proviceIndex == 0) {
        provinceName = "全部";
        provinceCode = "999999";
      } else {
        T model = provinceModels[proviceIndex - 1];
        provinceName = model.regionName;
        provinceCode = model.regionId.toString();
      }
    } else {
      T model = provinceModels[proviceIndex];
      provinceName = model.regionName;
      provinceCode = model.regionId.toString();
    }

    String cityName;
    String cityCode;
    if (shouldAddAllCityItem) {
      if (cityIndex == 0) {
        cityName = "全部";
        cityCode = "999999";
      } else {
        T model = cityModels[cityIndex - 1];
        cityName = model.regionName;
        cityCode = model.regionId.toString();
      }
    } else {
      T model = cityModels[cityIndex];
      cityName = model.regionName;
      cityCode = model.regionId.toString();
    }

    String areaName;
    String areaCode;
    if (shouldAddAllAreaItem) {
      if (districtIndex == 0) {
        areaName = "全部";
        areaCode = "999999";
      } else {
        T model = districtModels[districtIndex - 1];
        areaName = model.regionName;
        areaCode = model.regionId.toString();
      }
    } else {
      T model = districtModels[districtIndex];
      areaName = model.regionName;
      areaCode = model.regionId.toString();
    }

    String address = provinceName;
    if (cityName != "全部") {
      address += " $cityName";
    }
    if (areaName != "全部") {
      address += " $areaName";
    }

    return AreaPickerAddressModel(
      provinceName: provinceName,
      provinceCode: provinceCode,
      cityName: cityName,
      cityCode: cityCode,
      areaName: areaName,
      areaCode: areaCode,
      address: address,
      provinceIndex: proviceIndex,
      cityIndex: cityIndex,
      areaIndex: districtIndex,
    );
  }
}
