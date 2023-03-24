/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 15:56:08
 * @Description: environment 的本地储存
 */
import 'package:shared_preferences/shared_preferences.dart';
import './api_data_bean.dart';

import 'dart:convert';

class ApiSharedPreferenceUtil {
  // api

  // api:list
  static const String ApiMockListKey = "ApiMockListKey";
  Future setApiList(List<ApiModel> apiModels) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> strings = [];
    for (ApiModel apiModel in apiModels) {
      Map map = apiModel.toJson();
      String mapString = json.encode(map);
      strings.add(mapString);
    }

    prefs.setStringList(ApiMockListKey, strings);
  }

  Future<List<ApiModel>> getApiList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List? proxys = prefs.getStringList(ApiMockListKey);
    if (proxys == null) {
      return [];
    }

    List<ApiModel> apiModels = [];
    for (String proxyString in proxys) {
      Map<String, dynamic> map = json.decode(proxyString);
      ApiModel apiModel = ApiModel.fromJson(map);
      apiModels.add(apiModel);
    }
    return apiModels;
  }
}
