/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 00:31:45
 * @Description: 网络环境管理器
 */
// 创建一个单例的Manager类
import 'dart:async';

import 'package:flutter/foundation.dart';

import './network_page_data_cache.dart';
import './network_page_data_bean.dart';
export './network_page_data_bean.dart';

class NetworkPageDataManager {
  bool hasInitCompleter = false;
  Completer initCompleter = Completer<String>();

  List<TSEnvNetworkModel> _networkModels = [];
  TSEnvNetworkModel originNetworkModel = TSEnvNetworkModel.none();
  TSEnvNetworkModel _selectedNetworkModel = TSEnvNetworkModel.none();

  List<TSEnvNetworkModel> get networkModels => _networkModels;
  TSEnvNetworkModel get selectedNetworkModel {
    return _selectedNetworkModel;
  }

  // 工厂模式
  factory NetworkPageDataManager() => _getInstance();
  static NetworkPageDataManager get instance => _getInstance();
  static NetworkPageDataManager? _instance;
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
    return _instance!;
  }

  // network:获取当前的环境id或环境数据(已选中的要标记check出来)
  Future<Null> initWithDefaultNetworkIdAndModels({
    required List<TSEnvNetworkModel> networkModels_whenNull,
    required String defaultNetworkId,
    required bool canUseCacheNetwork, // false 则强制使用默认环境
  }) async {
    // 设置 "供切换的"和"默认的" 网络环境
    if (_networkModels.isEmpty) {
      _networkModels = networkModels_whenNull;
    }

    String? currentNetworkId;
    if (canUseCacheNetwork == true) {
      currentNetworkId = await NetworkPageDataCacheUtil.getNetworkId();
      if (currentNetworkId == null) {
        currentNetworkId = defaultNetworkId;
      } else {
        List<String> networkIds = [];
        for (TSEnvNetworkModel networkModel in _networkModels) {
          networkIds.add(networkModel.envId);
        }
        if (networkIds.contains(currentNetworkId) == false) {
          print('温馨提示:找不到$currentNetworkId指定的网络环境,可能为数据发生了改变,所以强制使用默认的网络环境');
          currentNetworkId = defaultNetworkId;
        }
        NetworkPageDataCacheUtil.setNetworkId(currentNetworkId);
      }
    } else {
      currentNetworkId = defaultNetworkId;
    }

    // 根据 selectedNetworkId 获取到 _selectedNetworkModel，同时对各 NetworkModel 进行是否 check 的标记
    for (int i = 0; i < _networkModels.length; i++) {
      TSEnvNetworkModel networkModel = _networkModels[i];
      if (networkModel.envId == currentNetworkId) {
        networkModel.check = true;
        _selectedNetworkModel = networkModel;
      } else {
        networkModel.check = false;
      }

      if (networkModel.envId == defaultNetworkId) {
        originNetworkModel = networkModel;
      }
    }

    if (originNetworkModel.envId == TSEnvNetworkModel.none().envId) {
      debugPrint("🚗🚗🚗未找到匹配 $defaultNetworkId 的网络模型");
    }
    // debugPrint("🚗🚗🚗找到的网络模型为 ${originNetworkModel.envId}");

    initCompleter.complete('NetworkPageDataManager:初始化完成，此时才可以进行实际环境获取');
    print('NetworkPageDataManager:初始化完成，此时才可以进行实际环境获取');
    hasInitCompleter = true;
  }

  /// 修改网络环境_页面数据
  updateNetworkPageSelectedData(TSEnvNetworkModel selectedNetworkModel) {
    _selectedNetworkModel = selectedNetworkModel;
    NetworkPageDataCacheUtil.setNetworkId(selectedNetworkModel.envId);
  }
}
