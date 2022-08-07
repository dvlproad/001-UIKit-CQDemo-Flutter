/*
 * @Author: dvlproad
 * @Date: 2022-04-23 23:56:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-26 12:52:50
 * @Description: 插件工具
 */
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:tim_ui_kit_lbs_plugin/pages/location_picker.dart';
import 'package:tim_ui_kit_lbs_plugin/utils/location_utils.dart';
import 'package:tim_ui_kit_lbs_plugin/utils/tim_location_model.dart';
import './lbs/baidu_implements/map_service_baidu_implement.dart';
import './lbs/baidu_implements/map_widget_baidu_implement.dart';

class PluginUtil {
  static String _baiduMapIOSAppKey = '';
  static initMap(String baiduMapIOSAppKey) {
    WidgetsFlutterBinding.ensureInitialized();

    _baiduMapIOSAppKey = baiduMapIOSAppKey;
    if (Platform.isIOS) {
      BMFMapSDK.setApiKeyAndCoordType(
          _baiduMapIOSAppKey, BMF_COORD_TYPE.BD09LL);
    } else if (Platform.isAndroid) {
      BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    }
    BMFMapSDK.setAgreePrivacy(true);
  }

  static onTapLocation(BuildContext context) {
    if (_baiduMapIOSAppKey == null || _baiduMapIOSAppKey.isEmpty) {
      // Utils.toast("请根据Demo的README指引，配置百度AK，体验DEMO的位置消息能力");
      print("请根据本文档指引 https://docs.qq.com/doc/DSVliWE9acURta2dL ， 快速体验位置消息能力");
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPicker(
          onChange: (LocationMessage location) async {
            print("location=$location");
          },
          mapBuilder: (onMapLoadDone, mapKey, onMapMoveEnd) => BaiduMap(
            onMapMoveEnd: onMapMoveEnd,
            onMapLoadDone: onMapLoadDone,
            key: mapKey,
          ),
          locationUtils: LocationUtils(BaiduMapService()),
        ),
      ),
    );
  }
}
