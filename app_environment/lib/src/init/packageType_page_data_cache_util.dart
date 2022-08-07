/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 17:48:03
 * @Description: 平台的本地缓存
 */
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './packageType_page_data_bean.dart';

import 'dart:convert';

class PackageTargetPageDataCacheUtil {
  // network
  static const String EnvPackageTargetIdKey = "EnvPackageTargetIdKey";
  // 删除选中的网络环境id
  Future removePackageTargetId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(EnvPackageTargetIdKey);
  }

  // 缓存选中的网络环境id
  static Future<bool> setPackageTargetId(String networkId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(EnvPackageTargetIdKey, networkId);
  }

  // 获取选中的网络环境id
  static Future<String> getPackageTargetId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String networkId = prefs.getString(EnvPackageTargetIdKey);
    return networkId;
  }

  static Future<PackageTargetType> get packageTargetType async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String envId = prefs.getString('cache_packageTargetString');

    PackageTargetType packageTargetType =
        PackageTargetModel.getTargetType(envId);

    return packageTargetType;
  }

  static Future<bool> update(PackageTargetType packageTargetType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String packageTargetString = packageTargetType.toString().split('.').last;
    return prefs.setString(
      'cache_packageTargetString',
      packageTargetString,
    );
  }
}