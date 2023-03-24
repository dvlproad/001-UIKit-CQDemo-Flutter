// 创建一个单例的Manager类
import 'dart:async';

import './proxy_page_data_cache.dart';
export './proxy_page_data_bean.dart';

class ProxyPageDataManager {
  bool hasInitCompleter = false;
  Completer initCompleter = Completer<String>();

  List<TSEnvProxyModel>? _proxyModels;
  TSEnvProxyModel _selectedProxyModel = TSEnvProxyModel.noneProxyModel();

  Future<List<TSEnvProxyModel>> get proxyModels async {
    await _getCache();
    return _proxyModels!;
  }

  TSEnvProxyModel get selectedProxyModel => _selectedProxyModel;

  // 工厂模式
  factory ProxyPageDataManager() => _getInstance();
  static ProxyPageDataManager get instance => _getInstance();
  static ProxyPageDataManager? _instance;
  ProxyPageDataManager._internal() {
    // 初始化
    init();
  }

  init() {
    _getCache();
  }

  // 获取缓存数据
  Future _getCache() async {
    if (_proxyModels == null || _proxyModels!.isEmpty) {
      _proxyModels = await ProxyPageDataCacheUtil.getProxyList();
    }

    if (_proxyModels == null) {
      _proxyModels = [];
    }
  }

  static ProxyPageDataManager _getInstance() {
    if (_instance == null) {
      _instance = new ProxyPageDataManager._internal();
    }
    return _instance!;
  }

  // proxy:获取当前的环境id或环境数据(已选中的要标记check出来)
  Future<Null> getCurrentProxyIdAndModels(
    List<TSEnvProxyModel> proxyModels_whenNull,
    String defaultProxykId,
    bool canUseCacheProxy, // false 则强制使用默认环境
  ) async {
    // 设置 "供切换的"和"默认的" 代理环境
    List<TSEnvProxyModel> proxyModels =
        await ProxyPageDataManager().proxyModels;
    if (proxyModels.length == 0) {
      proxyModels = await ProxyPageDataCacheUtil.getProxyList();
      if (proxyModels.length == 0) {
        proxyModels = proxyModels_whenNull;
      }
    }

    String? currentProxyId;
    if (canUseCacheProxy == true) {
      currentProxyId = await ProxyPageDataCacheUtil.getProxykId();

      if (currentProxyId == null) {
        currentProxyId = defaultProxykId;
      } else {
        List<String> proxyIds = [];
        for (TSEnvProxyModel proxyModel in proxyModels) {
          proxyIds.add(proxyModel.proxyId);
        }
        if (proxyIds.contains(currentProxyId) == false) {
          print('温馨提示:找不到$currentProxyId指定的代理环境,可能为数据发生了改变,所以强制使用默认的代理环境');
          currentProxyId = defaultProxykId;
        }
      }
    } else {
      currentProxyId = defaultProxykId;
    }

    // 根据 selectedProxyId 获取到 _selectedProxyModel，同时对 ProxyModel 进行是否 check 的标记
    late TSEnvProxyModel selectedProxyModel;
    for (int i = 0; i < proxyModels.length; i++) {
      TSEnvProxyModel proxyModel = proxyModels[i];
      if (proxyModel.proxyId == currentProxyId) {
        proxyModel.check = true;
        selectedProxyModel = proxyModel;
      } else {
        proxyModel.check = false;
      }
    }

    _selectedProxyModel = selectedProxyModel;
    _proxyModels = proxyModels;

    ProxyPageDataCacheUtil.setProxykId(currentProxyId);
    ProxyPageDataCacheUtil.setProxyList(proxyModels);

    initCompleter.complete('ProxyPageDataManager:初始化完成，此时才可以进行实际代理环境获取');
    print('ProxyPageDataManager:初始化完成，此时才可以进行实际代理环境获取');
    hasInitCompleter = true;
  }

  // 环境:添加自定义的网络代理，并是否直接选中新添加的
  void addOrUpdateCustomEnvProxyIp({
    required String proxyName,
    String? proxyIp,
    bool selectedNew = true,
  }) {
    TSEnvProxyModel newProxyModel = TSEnvProxyModel(
      proxyId: "proxykId_custom",
      name: proxyName,
      proxyIp: proxyIp,
    );

    addOrUpdateEnvProxyModel(
      newProxyModel: newProxyModel,
      selectedNew: selectedNew,
    );
  }

  // 环境:修改或新增网络代理，并是否直接选中新添加的
  TSEnvProxyModel addOrUpdateEnvProxyModel({
    required TSEnvProxyModel newProxyModel,
    bool selectedNew = true,
  }) {
    List<TSEnvProxyModel> proxyModels = _proxyModels ?? [];

    int proxyIpIndex = -1;
    proxyIpIndex = proxyModels
        .indexWhere((element) => element.proxyId == newProxyModel.proxyId);
    if (proxyIpIndex != -1) {
      //print('修改前$proxyModels');
      proxyModels[proxyIpIndex] = newProxyModel;
      //print('修改后$proxyModels');
    } else {
      proxyModels.add(newProxyModel);
    }
    ProxyPageDataCacheUtil.setProxyList(proxyModels);

    if (selectedNew) {
      newProxyModel.check = true;
      _updateProxyPageSelectedData(newProxyModel);
    }

    return newProxyModel;
  }

  /// 修改代理环境_页面数据
  _updateProxyPageSelectedData(
    TSEnvProxyModel selectedProxyModel, {
    bool selectedNew = true,
  }) {
    if (selectedNew) {
      for (TSEnvProxyModel item in _proxyModels ?? []) {
        if (item.proxyId == selectedProxyModel.proxyId) {
          item.check = true;
        } else {
          item.check = false;
        }
      }

      ProxyPageDataCacheUtil.setProxykId(selectedProxyModel.proxyId);
    } else {
      selectedProxyModel.check = false;
    }

    _selectedProxyModel = selectedProxyModel;
  }
}
