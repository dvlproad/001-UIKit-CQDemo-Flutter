// 创建一个单例的Manager类
import 'package:flutter/material.dart';
import './api_data_bean.dart';

import './api_cache.dart';

class ApiManager {
  bool _allowMock;
  List<ApiModel> _apiModels;

  bool get allowMock => _allowMock;
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
    _getCache();
  }

  // 获取缓存数据
  void _getCache() async {
    if (_apiModels == null || _apiModels.isEmpty) {
      _apiModels = await ApiSharedPreferenceUtil().getApiList();
    }

    if (_apiModels == null) {
      _apiModels = [];
    }
  }

  static ApiManager _getInstance() {
    if (_instance == null) {
      _instance = new ApiManager._internal();
    }
    return _instance;
  }

  /// 初始化完成后继续完善信息,此方法只为了做测试，开发情况下使用 tryAddApi 来添加 apiModel
  Future completeApiMock_whenNull({
    @required List<ApiModel> apiModels_whenNull,
  }) async {
    List<ApiModel> apiModels = ApiManager().apiModels;
    if (apiModels == null || apiModels.isEmpty) {
      apiModels = await ApiSharedPreferenceUtil().getApiList();
      if (apiModels == null || apiModels?.length == 0) {
        apiModels = apiModels_whenNull;
        ApiSharedPreferenceUtil().setApiList(apiModels);
      }
    }
    _apiModels = apiModels;
  }

  // 设置是否允许 mock api
  static void updateCanMock(bool allow) {
    ApiManager.instance._allowMock = allow;
  }

  // 获取是否允许 mock api
  // static bool allowMock() {
  //   bool allowMock = ApiManager.instance.allowMock;
  //   return allowMock;
  // }

  static void tryAddApi(String url, {String name, bool isGet}) {
    List<ApiModel> apiModels = ApiManager.instance.apiModels;
    int index = apiModels.indexWhere((element) {
      return element.url == url;
    }); // no found return -1

    if (index == -1) {
      bool mock = url.startsWith(RegExp(r'https?:')) ? true : false;

      if (name == null) {
        int count = apiModels.length;
        name = '接口$count';
      }
      if (isGet == true) {
        name = '$name:Get';
      } else {
        name = '$name:Post';
      }
      ApiModel apiModel = ApiModel(name: name, url: url, mock: mock);
      apiModels.add(apiModel);

      ApiSharedPreferenceUtil().setApiList(apiModels);
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

    ApiSharedPreferenceUtil().setApiList(apiModels);
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
