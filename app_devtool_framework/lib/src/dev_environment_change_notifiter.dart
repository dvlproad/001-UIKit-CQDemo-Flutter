/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-19 21:55:19
 * @Description: 
 */
import 'package:flutter/material.dart';

import 'package:flutter_environment/flutter_environment.dart';

class DevEnvironmentChangeNotifier extends ChangeNotifier {
  List<TSEnvNetworkModel> _networkModels = [];
  List<TSEnvProxyModel> _proxyModels = [];

  List<TSEnvNetworkModel> get networkModels => _networkModels;
  List<TSEnvProxyModel> get proxyModels => _proxyModels;

  TSEnvNetworkModel _networkModel = TSEnvNetworkModel(
    envId: '',
    name: '',
    shortName: '',
    apiHost: '',
    webHost: '',
    gameHost: '',
    monitorApiHost: '',
    monitorDataHubId: '',
  );
  TSEnvProxyModel _proxyModel = TSEnvProxyModel.noneProxyModel();

  TSEnvNetworkModel get networkModel => _networkModel;
  TSEnvProxyModel get proxyModel => _proxyModel;

  updateNetworkModel(TSEnvNetworkModel networkModel) {
    _networkModel = networkModel;
    notifyListeners();
  }

  updateProxyModel(TSEnvProxyModel proxyModel) {
    _proxyModel = proxyModel;
    notifyListeners();
  }
}
