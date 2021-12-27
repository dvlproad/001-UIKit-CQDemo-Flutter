// 创建一个单例的Manager类
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './api_data_bean.dart';

class ApiManager {
  List<ApiModel> _apiModels;

  List<ApiModel> get apiModels => _apiModels;

  // 工厂模式
  factory ApiManager() => _getInstance();
  static ApiManager get instance => _getInstance();
  static ApiManager _instance;
  ApiManager._internal() {
    // 初始化
    init();
  }

  init() {
    _apiModels = [];
  }

  static ApiManager _getInstance() {
    if (_instance == null) {
      _instance = new ApiManager._internal();
    }
    return _instance;
  }

  static void tryAddApi(String url) {
    List<ApiModel> apiModels = ApiManager.instance.apiModels;
    int index = apiModels.indexWhere((element) {
      return element.url == url;
    }); // no found return -1

    if (index == -1) {
      bool mock = url.startsWith(RegExp(r'https?:')) ? true : false;
      ApiModel apiModel = ApiModel(url: url, mock: mock);
      apiModels.add(apiModel);
    }
    // String log1 = apiModels.toString();
    // String log2 = apiModels.listToStructureString();
    // String type = apiModel.runtimeType.toString();
    // print('log...type=${type}');
    // print('log...apiModels=${apiModels.length}======$log1\======$log2');

    String log = apiModels.toString();
    print('log...apiModels=${apiModels.length}======$log');
  }

  static void changeMockForApiModel(ApiModel apiModel) {
    apiModel.mock = !apiModel.mock;

    List<ApiModel> apiModels = ApiManager.instance.apiModels;
    String log = apiModels.toString();
    print('log...apiModels=${apiModels.length}======$log');
  }

  // 是否要再打包后为指定的这个url加上mock（打包前的mock使用url.toSimulateApi();实现）
  static bool shouldAfterMockApi(String url) {
    bool hasMock = url.startsWith(RegExp(r'https?:')) ? true : false;
    if (hasMock) {
      return false; // 已经在url里mock的不用再一层mock
    }

    List<ApiModel> apiModels = ApiManager.instance.apiModels;
    int index = apiModels.indexWhere((element) {
      return element.url == url;
    }); // no found return -1

    if (index == -1) {
      return false;
    }

    ApiModel apiModel = apiModels[index];
    return apiModel.mock;
  }
}

/// desc：本地储存
class ApiSharedPreferenceUtil {
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
