// 创建一个单例的Manager类
import 'package:flutter/material.dart';
import './network_page_data_cache.dart';
import './network_page_data_bean.dart';
export './network_page_data_bean.dart';

class NetworkPageDataManager {
  List<TSEnvNetworkModel> _networkModels;
  TSEnvNetworkModel _selectedNetworkModel;

  List<TSEnvNetworkModel> get networkModels => _networkModels;
  TSEnvNetworkModel get selectedNetworkModel => _selectedNetworkModel;

  // 工厂模式
  factory NetworkPageDataManager() => _getInstance();
  static NetworkPageDataManager get instance => _getInstance();
  static NetworkPageDataManager _instance;
  NetworkPageDataManager._internal() {
    // 初始化
    init();
  }

  init() {
    _getCache();
  }

  // 获取缓存数据
  void _getCache() async {}

  static NetworkPageDataManager _getInstance() {
    if (_instance == null) {
      _instance = new NetworkPageDataManager._internal();
    }
    return _instance;
  }

  // network:获取当前的环境id或环境数据(已选中的要标记check出来)
  Future getCurrentNetworkIdAndModels({
    @required List<TSEnvNetworkModel> networkModels_whenNull,
    @required String defaultNetworkId,
    @required bool canUseCacheNetwork, // false 则强制使用默认环境
  }) async {
    // 设置 "供切换的"和"默认的" 网络环境
    List<TSEnvNetworkModel> networkModels =
        NetworkPageDataManager().networkModels;
    if (networkModels == null) {
      networkModels = networkModels_whenNull;
    }

    String currentNetworkId;
    if (canUseCacheNetwork == true) {
      currentNetworkId = await EnvironmentSharedPreferenceUtil().getNetworkId();
      if (currentNetworkId == null) {
        currentNetworkId = defaultNetworkId;
      } else {
        List<String> networkIds = [];
        for (TSEnvNetworkModel networkModel in networkModels) {
          networkIds.add(networkModel.envId);
        }
        if (networkIds.contains(currentNetworkId) == false) {
          print('温馨提示:找不到$currentNetworkId指定的网络环境,可能为数据发生了改变,所以强制使用默认的网络环境');
          currentNetworkId = defaultNetworkId;
        }
        EnvironmentSharedPreferenceUtil().setNetworkId(currentNetworkId);
      }
    } else {
      currentNetworkId = defaultNetworkId;
    }

    // 根据 selectedNetworkId 获取到 _selectedNetworkModel，同时对各 NetworkModel 进行是否 check 的标记
    TSEnvNetworkModel selectedNetworkModel;
    for (int i = 0; i < networkModels.length; i++) {
      TSEnvNetworkModel networkModel = networkModels[i];
      if (networkModel.envId == currentNetworkId) {
        networkModel.check = true;
        selectedNetworkModel = networkModel;
      } else {
        networkModel.check = false;
      }
    }

    _networkModels = networkModels;
    _selectedNetworkModel = selectedNetworkModel;
  }

  /// 修改网络环境_页面数据
  updateNetworkPageSelectedData(TSEnvNetworkModel selectedNetworkModel) {
    _selectedNetworkModel = selectedNetworkModel;
    EnvironmentSharedPreferenceUtil().setNetworkId(selectedNetworkModel.envId);
  }
}
