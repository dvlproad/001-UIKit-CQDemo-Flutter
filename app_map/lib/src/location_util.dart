/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-15 00:33:56
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

class LocationUtil {
  // 进入选择地址界面
  static goChooseLocationPage(
    BuildContext context, {
    @required Function({LocationBean bLocationBean}) chooseCompleteBlock,
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocationChoosePage(
            callBack: (BMFPoiInfo data) {
              if (data == null) {
                return;
              }
              double latitude = 0.0;
              double longitude = 0.0;

              if (data.detailInfo != null &&
                  data.detailInfo.naviLocation != null) {
                latitude = data.detailInfo.naviLocation.latitude ?? 0.0;
                longitude = data.detailInfo.naviLocation.longitude ?? 0.0;
              }

              String address = '';
              // if (data.province != null) {
              //   address += ' ${data.province}';
              // }
              // if (data.city != null) {
              //   address += ' ${data.city}';
              // }
              // if (data.area != null) {
              //   address += ' ${data.area}';
              // }
              if (data.name != null) {
                address = data.name;
              }

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
