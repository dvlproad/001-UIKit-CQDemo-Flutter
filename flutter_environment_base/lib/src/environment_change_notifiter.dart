/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-20 16:50:19
 * @Description: 
 */
import 'package:flutter/material.dart';

import './network_page_data_bean.dart';
import './data_target/packageType_page_data_bean.dart';
import './proxy_page_data_bean.dart';

class NetworkEnvironmentChangeNotifier extends ChangeNotifier {
  List<TSEnvNetworkModel> _networkModels = [];

  List<TSEnvNetworkModel> get networkModels => _networkModels;

  TSEnvNetworkModel _networkModel = TSEnvNetworkModel.none();

  TSEnvNetworkModel get networkModel => _networkModel;

  updateNetworkModel(TSEnvNetworkModel networkModel) {
    _networkModel = networkModel;
    notifyListeners();
  }
}

class TargetEnvironmentChangeNotifier extends ChangeNotifier {
  List<PackageTargetModel> _targetModels = [];

  List<PackageTargetModel> get targetModels => _targetModels;

  PackageTargetModel _targetModel =
      PackageTargetModel.targetModelByType(PackageTargetType.formal);

  PackageTargetModel get targetModel => _targetModel;

  updateNetworkModel(PackageTargetModel targetModel) {
    _targetModel = targetModel;
    notifyListeners();
  }
}

class ProxyEnvironmentChangeNotifier extends ChangeNotifier {
  List<TSEnvProxyModel> _proxyModels = [];

  List<TSEnvProxyModel> get proxyModels => _proxyModels;

  TSEnvProxyModel _proxyModel = TSEnvProxyModel.noneProxyModel();

  TSEnvProxyModel get proxyModel => _proxyModel;

  updateProxyModel(TSEnvProxyModel proxyModel) {
    _proxyModel = proxyModel;
    notifyListeners();
  }
}
