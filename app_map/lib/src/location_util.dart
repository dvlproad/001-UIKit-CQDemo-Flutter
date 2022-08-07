/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-27 12:43:12
 * @Description: 位置工具类
 */
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_images_picker/src/permission_manager.dart';
import './location_bean.dart';
export './location_bean.dart';

import './location_choose_page.dart';

import './tim_uikit_plugin_lbs_util.dart';

class LocationUtil {
  // 进入选择地址界面
  static goChooseLocationPage(
    BuildContext context, {
    required Function({LocationBean? bLocationBean}) chooseCompleteBlock,
  }) async {
    // if (await Permission.location.isGranted) {
    //   print("位置权限申请通过");
    // } else {
    //   print("位置权限申请失败");

    //   Map<Permission, PermissionStatus> statuses =
    //       await [Permission.location].request();
    //   if (statuses[Permission.location] != PermissionStatus.granted) {
    //     openAppSettings();
    //     return;
    //   }
    // }

    bool isPermission = await PermissionsManager.checkLocationPermissions();
    if (isPermission == false) {
      return;
    }

    // PluginUtil.onTapLocation(
    //   context,
    //   onChange: (LocationMessage value) {
    //     double latitude = value.latitude;
    //     double longitude = value.longitude;

    //     List<String> addressComponents = value.desc.split('/////');
    //     String address = addressComponents[0];

    //     LocationBean locationBean = LocationBean(
    //       latitude: latitude,
    //       longitude: longitude,
    //       address: address,
    //     );

    //     chooseCompleteBlock(bLocationBean: locationBean);
    //   },
    //   onClear: () {
    //     chooseCompleteBlock(bLocationBean: null);
    //   },
    // );
    // return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocationChoosePage(
            callBack: (BMFPoiInfo? data) {
              if (data == null) {
                if (chooseCompleteBlock != null) {
                  chooseCompleteBlock(bLocationBean: null);
                }
                return;
              }

              BMFPoiInfo poiInfo = data;

              double latitude = 0.0;
              double longitude = 0.0;
              if (poiInfo.pt != null) {
                latitude = poiInfo.pt!.latitude;
                longitude = poiInfo.pt!.longitude;
              }

              String address = '';
              // if (poiInfo.province != null) {
              //   address += ' ${poiInfo.province}';
              // }
              // if (poiInfo.city != null) {
              //   address += ' ${poiInfo.city}';
              // }
              // if (poiInfo.area != null) {
              //   address += ' ${poiInfo.area}';
              // }
              address = poiInfo.name ?? '';

              LocationBean locationBean = LocationBean(
                latitude: latitude,
                longitude: longitude,
                address: address,
              );

              // if (latitude == 0 || longitude == 0) {
              //   ToastUtil.showMessage('当前经纬度为{$latitude,$longitude},请检查');
              // }

              if (chooseCompleteBlock != null) {
                chooseCompleteBlock(bLocationBean: locationBean);
              }
            },
          );
        },
      ),
    ).then((value) {
      print("退出定位选择界面了");
    });
  }
}
