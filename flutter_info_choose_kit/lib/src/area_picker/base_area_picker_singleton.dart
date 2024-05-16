// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-16 13:43:06
 * @Description: 收货地址工具类
 */

import 'package:flutter/material.dart';
import 'package:flutter_base_models/flutter_base_models.dart';

import './area_picker.dart';

import '../../flutter_info_choose_kit_adapt.dart';

abstract class BaseAreaPickerSingleton<
    TCityModel extends BaseCityModel<TCityModel>,
    TLocation extends BaseLocationModel> {
  /// 获取提供给选择器的城市资源
  Future<List<TCityModel>> getCityModels();

  /// 启动定位
  void startLocation({
    bool isFullAccuracy = false,
    bool showLocationPermissionDialog = true,
    required void Function(TLocation? model) completeBack,
  });

  showAreaPickerToLocation({
    required BuildContext context,
    double? height, // 为空，默认300.h_pt_cj
    bool showAllCityType = false,
    bool showAllAreaType = false,
    bool needLocationIfNull = true,
    bool isFullAccuracy = false,
    bool showLocationPermissionDialog = true, // 是否展示权限提示
    AreaPickerSelectedIndexsModel? selectedIndexModel,
    TLocation? locationModel,
    required void Function(AreaPickerAddressModel areaPickerAddressModel)
        onConfirmHandle,
  }) {
    void showPickerWithLocation(
      BuildContext context, {
      TLocation? locationModel, // 定位失败
    }) {
      AreaPickerSelectedIndexsModel locationSelectedIndexModel =
          AreaPickerSelectedIndexsModel(
        provinceIndex: locationModel?.provinceIndex ?? 0,
        cityIndex: locationModel?.cityIndex ?? 0,
        districtIndex: locationModel?.districtIndex ?? 0,
      );

      _showAreaPicker(
        context: context,
        height: height,
        showAllCityType: showAllCityType,
        showAllAreaType: showAllAreaType,
        needLocationIfNull: needLocationIfNull,
        isFullAccuracy: isFullAccuracy,
        showLocationPermissionDialog: showLocationPermissionDialog,
        selectedIndexModel: locationSelectedIndexModel,
        onConfirmHandle: onConfirmHandle,
      );
    }

    if (selectedIndexModel == null && needLocationIfNull == true) {
      if (locationModel == null) {
        startLocation(
          isFullAccuracy: isFullAccuracy,
          showLocationPermissionDialog: showLocationPermissionDialog,
          completeBack: (TLocation? locationModel) async {
            showPickerWithLocation(context, locationModel: locationModel);
          },
        );
      } else {
        showPickerWithLocation(context, locationModel: locationModel);
      }
    } else {
      showPickerWithLocation(context, locationModel: null);
    }
  }

  AreaPickerSelectedIndexsModel getAreaPickerSelectedIndexs(
    List<TCityModel> value, {
    required String provinceId,
    required String cityId,
    required String districtId,
  }) {
    int provinceIndex = -1;
    int cityIndex = -1;
    int districtIndex = -1;

    List<TCityModel> provinceList = value;
    // 匹配省
    for (TCityModel p in provinceList) {
      int provinceIndex = provinceList.indexOf(p);
      if (p.regionId == provinceId) {
        List<TCityModel>? cityList = p.children;
        // 匹配城市
        for (TCityModel city in (cityList ?? [])) {
          int? cityIndex = cityList?.indexOf(city);
          // cityList.length == 1 加这个判断条件是因为像北京是国家直辖市，这种情况下 regionId 和 districtId 是不匹配的，所以这里做了这个兼容
          if (city.regionId == cityId || cityList?.length == 1) {
            List<TCityModel>? districtList = city.children;
            // 匹配区
            for (TCityModel district in districtList!) {
              int districtIndex = districtList.indexOf(district);
              // districtList.length == 1 加这个判断条件是因为部分城市没有区，
              // 例如：广东省-东莞市-东莞市 这种情况下 regionId 和 districtId 是不匹配的，所以这里做了这个兼容
              if (district.regionId == districtId || districtList.length == 1) {
                provinceIndex = provinceIndex;
                cityIndex = cityIndex;
                districtIndex = districtIndex;
              }
            }
          }
        }
      }
    }

    return AreaPickerSelectedIndexsModel(
      provinceIndex: provinceIndex,
      cityIndex: cityIndex,
      districtIndex: districtIndex,
    );
  }

  _showAreaPicker({
    required BuildContext context,
    double? height, // 为空，默认300.h_pt_cj
    bool showAllCityType = false,
    bool showAllAreaType = false,
    bool needLocationIfNull = true,
    bool isFullAccuracy = false,
    bool showLocationPermissionDialog = true, // 是否展示权限提示
    AreaPickerSelectedIndexsModel? selectedIndexModel,
    required void Function(AreaPickerAddressModel areaPickerAddressModel)
        onConfirmHandle,
  }) async {
    GlobalKey<AreaPickerState> areaPickerKey = GlobalKey();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return AreaPicker<TCityModel>(
          key: areaPickerKey,
          // color: Colors.green,
          height: height ?? 300.h_pt_cj,
          shouldAddAllCityItem: showAllCityType,
          shouldAddAllAreaItem: showAllAreaType,
          selectModel: selectedIndexModel,
          cityModelsGetHandle: () {
            return getCityModels();
          },
          onConfirmHandle: onConfirmHandle,
        );
      },
    );

    // 开始定位
    if (needLocationIfNull == true) {
      await Future.delayed(const Duration(milliseconds: 300), () {});
      startLocation(
        isFullAccuracy: isFullAccuracy,
        showLocationPermissionDialog: showLocationPermissionDialog,
        completeBack: (TLocation? locationModel) async {
          AreaPickerSelectedIndexsModel locationSelectedModel =
              AreaPickerSelectedIndexsModel(
            provinceIndex: locationModel?.provinceIndex,
            cityIndex: locationModel?.cityIndex,
            districtIndex: locationModel?.districtIndex,
          );
          if (areaPickerKey.currentState != null) {
            AreaPickerState areaPickerState = areaPickerKey.currentState!;
            // await Future.delayed(const Duration(milliseconds: 1000), () {});
            areaPickerState.jumpTo(locationSelectedModel);
          }
        },
      );
    }
  }
}
