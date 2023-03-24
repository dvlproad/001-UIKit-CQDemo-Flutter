/*
 * @Author: dvlproad
 * @Date: 2022-07-20 01:41:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-20 11:32:19
 * @Description: 代理环境的本地储存
 */
import 'package:shared_preferences/shared_preferences.dart';
import './proxy_page_data_bean.dart';
export './proxy_page_data_bean.dart';

import 'dart:convert';

class ProxyPageDataCacheUtil {
  // proxy
  // 缓存如果代理数据有更改，那是否已经更改过了
  static Future<bool> setHasChangeProxyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("hasChangeProxyDataKey", true);
  }

  // 获取如果代理数据有更改，那是否已经更改过了
  static Future<bool> getHasChangeProxyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isHappenChange = prefs.getBool("hasChangeProxyDataKey") ?? false;
    return isHappenChange;
  }

  // proxy:list
  static const String EnvProxyListKey = "EnvProxyListKey";
  // 删除代理数据
  static Future<bool> removeProxyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(EnvProxyListKey);
  }

  // 缓存代理数据
  static Future<bool> setProxyList(List<TSEnvProxyModel> proxys) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> strings = [];
    for (TSEnvProxyModel proxy in proxys) {
      Map map = proxy.toJson();
      String mapString = json.encode(map);
      strings.add(mapString);
    }

    return prefs.setStringList(EnvProxyListKey, strings);
  }

  // 获取缓存中的代理数据
  static Future<List<TSEnvProxyModel>> getProxyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List? proxys = prefs.getStringList(EnvProxyListKey);
    if (proxys == null) {
      return [];
    }

    List<TSEnvProxyModel> proxyModels = [];
    for (String proxyString in proxys) {
      Map<String, dynamic> map = json.decode(proxyString);
      TSEnvProxyModel proxyModel = TSEnvProxyModel.fromJson(map);
      proxyModels.add(proxyModel);
    }
    return proxyModels;
  }

  // proxy:selectedId
  static const String EnvProxyIdKey = "EnvProxyIdKey";
  // 删除选中的代理环境id
  static Future<bool> removeProxykId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(EnvProxyIdKey);
  }

  // 缓存选中的代理环境id
  static Future<bool> setProxykId(String proxykId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(EnvProxyIdKey, proxykId);
  }

  // 获取选中的代理环境id
  static Future<String?> getProxykId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? proxykId = prefs.getString(EnvProxyIdKey);
    return proxykId;
  }
}
