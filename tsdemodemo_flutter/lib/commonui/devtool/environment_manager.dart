// 创建一个单例的Manager类
import 'package:tsdemodemo_flutter/commonui/devtool/environment_data_bean.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  completeEnvInternal({
    @required TSEnvironmentModel environmentModel,
    @required String defaultNetworkId,
    @required String defaultProxykId,
  }) {
    assert(environmentModel != null);
    _environmentModel = environmentModel;

    Future.wait([
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
      })
    ]).then((List results) {
      //then 是所有都执行完之后走的回调   results是上面三个异步的结果拼到results里面来;
      String networkId = results[0];
      String proxyId = results[1];
      this._getSelectedModel(
        environmentModel: environmentModel,
        selectedNetworkId: networkId,
        selectedProxyId: proxyId,
      );
    }).catchError((onError) {
      print("onError = $onError");
    });
  }

  _getSelectedModel({
    TSEnvironmentModel environmentModel,
    String selectedNetworkId,
    String selectedProxyId,
  }) {
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

    List<TSEnvProxyModel> proxyModels = environmentModel.proxyModels;
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

  /// 更新选中的环境信息
  updateEnvSelectedModel({
    TSEnvNetworkModel selectedNetworkModel,
    TSEnvProxyModel selectedProxyModel,
  }) {
    if (selectedNetworkModel != null) {
      this._selectedNetworkModel = selectedNetworkModel;
      EnvironmentSharedPreferenceUtil()
          .setNetworkId(selectedNetworkModel.envId);
    }

    if (selectedProxyModel != null) {
      this._selectedProxyModel = selectedProxyModel;
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
