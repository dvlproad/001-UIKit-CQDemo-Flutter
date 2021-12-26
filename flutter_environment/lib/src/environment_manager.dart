// 创建一个单例的Manager类
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './environment_data_bean.dart';

class EnvironmentManager {
  TSEnvironmentModel _environmentModel;
  TSEnvNetworkModel _selectedNetworkModel;
  TSEnvProxyModel _selectedProxyModel;

  TSEnvironmentModel get environmentModel => _environmentModel;
  TSEnvNetworkModel get selectedNetworkModel => _selectedNetworkModel;
  TSEnvProxyModel get selectedProxyModel => _selectedProxyModel;

  // 工厂模式
  factory EnvironmentManager() => _getInstance();
  static EnvironmentManager get instance => _getInstance();
  static EnvironmentManager _instance;
  EnvironmentManager._internal() {
    // 初始化
  }

  static EnvironmentManager _getInstance() {
    if (_instance == null) {
      _instance = new EnvironmentManager._internal();
    }
    return _instance;
  }

  /// 初始化完成后继续完善信息
  Future completeEnvInternal({
    @required TSEnvironmentModel environmentModel,
    @required String defaultNetworkId,
    @required String defaultProxykId,
  }) async {
    assert(environmentModel != null);
    _environmentModel = environmentModel;

    return _getDefaultModel(
      defaultNetworkId: defaultNetworkId,
      defaultProxykId: defaultProxykId,
    ).then((value) {
      print('。。。。。。。。。。');
    });
  }

  Future _getDefaultModel({
    @required String defaultNetworkId,
    @required String defaultProxykId,
  }) async {
    return Future.wait([
      // network
      EnvironmentSharedPreferenceUtil().getNetworkId().then((value) {
        String networkId = value;
        if (networkId == null) {
          networkId = defaultNetworkId;
        }
        // envManager._currentNetworkId = networkId;

        return networkId;
      }),

      // proxy
      EnvironmentSharedPreferenceUtil().getProxykId().then((value) {
        String proxyId = value;
        if (proxyId == null) {
          proxyId = defaultProxykId;
        }
        // envManager._currentProxykId = proxyId;

        return proxyId;
      }),
    ]).then((List results) {
      //then 是所有都执行完之后走的回调   results是上面三个异步的结果拼到results里面来;
      String selectedNetworkId = results[0];
      String selectedProxyId = results[1];
      this._getSelectedNetworkModel(selectedNetworkId);
      this._getSelectedProxyModel(selectedProxyId);
    }).catchError((onError) {
      print("onError = $onError");
    });
  }

  // 根据 selectedNetworkId 和 selectedProxyId 从 environmentModel 获取到 _selectedNetworkModel 和 _selectedProxyModel，
  // 同时会对各 NetworkModel 和 ProxyModel 进行是否 check 的标记
  _getSelectedNetworkModel(String selectedNetworkId) {
    List<TSEnvNetworkModel> networkModels = environmentModel.networkModels;
    for (int i = 0; i < networkModels.length; i++) {
      TSEnvNetworkModel networkModel = networkModels[i];
      if (networkModel.envId == selectedNetworkId) {
        networkModel.check = true;
        this._selectedNetworkModel = networkModel;
      } else {
        networkModel.check = false;
      }
    }
    assert(this._selectedNetworkModel != null);
  }

  _getSelectedProxyModel(String selectedProxyId) {
    List<TSEnvProxyModel> proxyModels = _environmentModel.proxyModels;
    for (int i = 0; i < proxyModels.length; i++) {
      TSEnvProxyModel proxyModel = proxyModels[i];
      if (proxyModel.proxyId == selectedProxyId) {
        proxyModel.check = true;
        this._selectedProxyModel = proxyModel;
      } else {
        proxyModel.check = false;
      }
    }
    assert(this._selectedProxyModel != null);
  }

  // 环境:添加自定义的网络代理，并是否直接选中新添加的
  TSEnvProxyModel addEnvProxyModel({
    String proxyIp,
    bool selectedNew = true,
  }) {
    List<TSEnvProxyModel> proxyModels = _environmentModel.proxyModels;

    TSEnvProxyModel newProxyModel = TSEnvProxyModel();
    newProxyModel.proxyId = "proxykId_custom";
    newProxyModel.name = "自定义代理";
    newProxyModel.proxyIp = proxyIp;

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

    if (selectedNew) {
      newProxyModel.check = true;
      updateEnvSelectedModel(selectedProxyModel: newProxyModel);
    }

    return newProxyModel;
  }

  /// 更新选中的环境信息
  updateEnvSelectedModel({
    TSEnvNetworkModel selectedNetworkModel,
    TSEnvProxyModel selectedProxyModel,
  }) {
    if (selectedNetworkModel != null) {
      this._getSelectedNetworkModel(selectedNetworkModel.envId);

      EnvironmentSharedPreferenceUtil()
          .setNetworkId(selectedNetworkModel.envId);
    }

    if (selectedProxyModel != null) {
      this._getSelectedProxyModel(selectedProxyModel.proxyId);

      EnvironmentSharedPreferenceUtil().setProxykId(selectedProxyModel.proxyId);
    }
  }
}

/// desc：本地储存
class EnvironmentSharedPreferenceUtil {
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
