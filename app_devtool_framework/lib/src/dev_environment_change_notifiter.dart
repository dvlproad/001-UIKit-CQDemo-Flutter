/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-10-18 18:49:36
 * @Description: 
 */
import 'package:flutter/material.dart';

import 'package:flutter_environment_base/flutter_environment_base.dart';

class DevEnvironmentChangeNotifier extends ChangeNotifier {
  final List<TSEnvNetworkModel> _networkModels = [];
  final List<TSEnvProxyModel> _proxyModels = [];

  List<TSEnvNetworkModel> get networkModels => _networkModels;
  List<TSEnvProxyModel> get proxyModels => _proxyModels;

  TSEnvNetworkModel _networkModel = TSEnvNetworkModel.none();
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
