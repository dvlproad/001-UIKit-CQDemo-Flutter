// environment 的本地储存
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './environment_data_bean.dart';

import 'dart:convert';

class EnvironmentSharedPreferenceUtil {
  // network
  static const String EnvNetworkIdKey = "EnvNetworkIdKey";
  Future setNetworkId(String networkId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(EnvNetworkIdKey, networkId);
  }

  Future<String> getNetworkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String networkId = prefs.getString(EnvNetworkIdKey);
    return networkId;
  }

  // proxy

  // proxy:list
  static const String EnvProxyListKey = "EnvProxyListKey";
  Future setProxyList(List<TSEnvProxyModel> proxys) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> strings = [];
    for (TSEnvProxyModel proxy in proxys) {
      Map map = proxy.toJson();
      String mapString = json.encode(map);
      strings.add(mapString);
    }

    prefs.setStringList(EnvProxyListKey, strings);
  }

  Future<List<TSEnvProxyModel>> getProxyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List proxys = prefs.getStringList(EnvProxyListKey);
    if (proxys == null) {
      return null;
    }

    List<TSEnvProxyModel> proxyModels = [];
    for (String proxyString in proxys) {
      Map map = json.decode(proxyString);
      TSEnvProxyModel proxyModel = TSEnvProxyModel.fromJson(map);
      proxyModels.add(proxyModel);
    }
    return proxyModels;
  }

  // proxy:selectedId
  static const String EnvProxyIdKey = "EnvProxyIdKey";
  Future setProxykId(String proxykId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(EnvProxyIdKey, proxykId);
  }

  Future<String> getProxykId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String proxykId = prefs.getString(EnvProxyIdKey);
    return proxykId;
  }
}
