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

  // 添加api (添加的时候为path统一添加上/，比较的时候也统一添加上/后再和村粗的数组比较相等，兼容path有时候添加上/又去掉)
  static void tryAddApi(String url, {String name, bool isGet}) {
    String addUrl;
    bool hasHttpPrefix = url.startsWith(RegExp(r'https?:')) ? true : false;
    if (hasHttpPrefix == false && url.startsWith('/') == false) {
      addUrl = '/$url';
    } else {
      addUrl = '$url';
    }

    List<ApiModel> apiModels = ApiManager.instance.apiModels;
    int index = apiModels.indexWhere((element) {
      return element.url == addUrl;
    }); // no found return -1

    if (index == -1) {
      if (name == null) {
        int count = apiModels.length;
        name = '接口$count';
      }
      if (isGet == true) {
        name = '$name:Get';
      } else {
        name = '$name:Post';
      }

      bool mock = false;

      ApiModel apiModel = ApiModel(name: name, url: addUrl, mock: mock);
      apiModels.add(apiModel);

      ApiSharedPreferenceUtil().setApiList(apiModels);
    }
    // String log1 = apiModels.toString();
    // String log2 = apiModels.listToStructureString();
    // String type = apiModel.runtimeType.toString();
    // print('log...type=${type}');
    // print('log...apiModels=${apiModels.length}======$log1\======$log2');

    // String log = apiModels.toString();
    // print('log...apiModels=${apiModels.length}======$log');
  }

  static void changeMockForApiModel(ApiModel apiModel) {
    apiModel.mock = !apiModel.mock;

    List<ApiModel> apiModels = ApiManager.instance.apiModels;
    //String log = apiModels.toString();
    //print('log...apiModels=${apiModels.length}======$log');

    ApiSharedPreferenceUtil().setApiList(apiModels);
  }

  // 是否要再打包后为指定的这个url加上mock（打包前的mock使用url.toSimulateApi();实现）
  // (添加的时候为path统一添加上/，比较的时候也统一添加上/后再和村粗的数组比较相等，兼容path有时候添加上/又去掉)
  static bool shouldAfterMockApi(String url) {
    String checkUrl;
    bool hasHttpPrefix = url.startsWith(RegExp(r'https?:')) ? true : false;
    if (hasHttpPrefix == false && url.startsWith('/') == false) {
      checkUrl = '/$url';
    } else {
      checkUrl = '$url';
    }

    List<ApiModel> apiModels = ApiManager.instance.apiModels;
    int index = apiModels.indexWhere((element) {
      bool found = element.url == checkUrl;
      return found;
    }); // no found return -1

    if (index == -1) {
      return false;
    }

    ApiModel apiModel = apiModels[index];
    return apiModel.mock;
  }

  // 获取mock的api数量
  static int mockCount() {
    int mockCount = 0;

    List<ApiModel> apiModels = ApiManager().apiModels ?? [];
    for (ApiModel apiModel in apiModels) {
      if (apiModel.mock) {
        mockCount++;
      }
    }
    return mockCount;
  }
}
