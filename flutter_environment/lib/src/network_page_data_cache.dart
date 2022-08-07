/*
 * @Author: dvlproad
 * @Date: 2022-07-20 01:41:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-20 11:29:59
 * @Description: 网络环境的本地储存
 */
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './network_page_data_bean.dart';
import './proxy_page_data_bean.dart';

import 'dart:convert';

class NetworkPageDataCacheUtil {
  // network
  static const String EnvNetworkIdKey = "EnvNetworkIdKey";
  // 删除选中的网络环境id
  static Future<bool> removeNetworkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(EnvNetworkIdKey);
  }

  // 缓存选中的网络环境id
  static Future<bool> setNetworkId(String networkId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(EnvNetworkIdKey, networkId);
  }

  // 获取选中的网络环境id
  static Future<String?> getNetworkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? networkId = prefs.getString(EnvNetworkIdKey);
    return networkId;
  }
}
