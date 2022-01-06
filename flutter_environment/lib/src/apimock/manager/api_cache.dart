// environment 的本地储存
import 'package:flutter/material.dart';
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
    List proxys = prefs.getStringList(ApiMockListKey);
    if (proxys == null) {
      return null;
    }

    List<ApiModel> apiModels = [];
    for (String proxyString in proxys) {
      Map map = json.decode(proxyString);
      ApiModel apiModel = ApiModel.fromJson(map);
      apiModels.add(apiModel);
    }
    return apiModels;
  }
}
