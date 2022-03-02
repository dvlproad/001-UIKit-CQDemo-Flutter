// environment 的本地储存
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './proxy_page_data_bean.dart';
export './proxy_page_data_bean.dart';

import 'dart:convert';

class EnvironmentSharedPreferenceUtil {
  // network
  static const String EnvNetworkIdKey = "EnvNetworkIdKey";
  // 删除选中的网络环境id
  Future removeNetworkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(EnvNetworkIdKey);
  }

  // 缓存选中的网络环境id
  Future setNetworkId(String networkId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(EnvNetworkIdKey, networkId);
  }

  // 获取选中的网络环境id
  Future<String> getNetworkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String networkId = prefs.getString(EnvNetworkIdKey);
    return networkId;
  }

  // proxy
  // 缓存如果代理数据有更改，那是否已经更改过了
  Future setHasChangeProxyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("hasChangeProxyDataKey", true);
  }

  // 获取如果代理数据有更改，那是否已经更改过了
  Future<bool> getHasChangeProxyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isHappenChange = prefs.getBool("hasChangeProxyDataKey");
    return isHappenChange;
  }

  // proxy:list
  static const String EnvProxyListKey = "EnvProxyListKey";
  // 删除代理数据
  Future removeProxyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(EnvProxyListKey);
  }

  // 缓存代理数据
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

  // 获取缓存中的代理数据
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
  // 删除选中的代理环境id
  Future removeProxykId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(EnvProxyIdKey);
  }

  // 缓存选中的代理环境id
  Future setProxykId(String proxykId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(EnvProxyIdKey, proxykId);
  }

  // 获取选中的代理环境id
  Future<String> getProxykId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String proxykId = prefs.getString(EnvProxyIdKey);
    return proxykId;
  }
}
