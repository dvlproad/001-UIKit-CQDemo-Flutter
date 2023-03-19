/*
 * @Author: dvlproad
 * @Date: 2022-04-23 23:56:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-27 11:33:26
 * @Description: 插件工具
 */
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:tim_ui_kit_lbs_plugin/pages/location_picker.dart';
import 'package:tim_ui_kit_lbs_plugin/utils/location_utils.dart';
import 'package:tim_ui_kit_lbs_plugin/utils/tim_location_model.dart';
export 'package:tim_ui_kit_lbs_plugin/utils/tim_location_model.dart'
    show LocationMessage;
import './lbs/baidu_implements/map_service_baidu_implement.dart';
import './lbs/baidu_implements/map_widget_baidu_implement.dart';

import 'package:flutter_bmflocation/flutter_bmflocation.dart'
    show LocationFlutterPlugin;

import './quick_location_choose_page.dart';

class PluginUtil {
  static String _baiduMapIOSAppKey = '';

  static String get baiduMapIOSAppKey => _baiduMapIOSAppKey;

  static initMap(String baiduMapIOSAppKey) {
    WidgetsFlutterBinding.ensureInitialized();

    /// 百度定位
    _baiduMapIOSAppKey = baiduMapIOSAppKey;
    BMFMapSDK.setAgreePrivacy(true);
    BMFMapSDK.setAgreePrivacy(true);
    LocationFlutterPlugin locationFlutterPlugin = LocationFlutterPlugin();
    locationFlutterPlugin.setAgreePrivacy(true);
    if (Platform.isIOS) {
      BMFMapSDK.setApiKeyAndCoordType(
          _baiduMapIOSAppKey, BMF_COORD_TYPE.BD09LL);
      locationFlutterPlugin.authAK(_baiduMapIOSAppKey);
    } else if (Platform.isAndroid) {
      // Android 目前不支持接口设置Apikey,
      // 请在主工程的Manifest文件里设置，详细配置方法请参考官网(https://lbsyun.baidu.com/)demo
      BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    }
    // BMKLocationAuth.setAgreePrivacy(true);
  }

  static onTapLocation(BuildContext context, {
    required ValueChanged<LocationMessage> onChange,
    required Function() onClear,
  }) {
    if (_baiduMapIOSAppKey == null || _baiduMapIOSAppKey.isEmpty) {
      // Utils.toast("请根据Demo的README指引，配置百度AK，体验DEMO的位置消息能力");
      print("请根据本文档指引 https://docs.qq.com/doc/DSVliWE9acURta2dL ， 快速体验位置消息能力");
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QuickLocationPicker(
              onChange: (LocationMessage location) async {
                print("location=$location");
                onChange(location);
              },
              onClear: onClear,
              mapBuilder: (onMapLoadDone, mapKey, onMapMoveEnd) =>
                  BaiduMap(
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
