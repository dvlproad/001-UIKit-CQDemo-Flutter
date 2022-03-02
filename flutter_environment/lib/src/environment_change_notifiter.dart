import 'package:flutter/material.dart';

import './network_page_data_bean.dart';
import './proxy_page_data_bean.dart';

class EnvironmentChangeNotifier extends ChangeNotifier {
  List<TSEnvNetworkModel> _networkModels;
  List<TSEnvProxyModel> _proxyModels;

  List<TSEnvNetworkModel> get networkModels => _networkModels;
  List<TSEnvProxyModel> get proxyModels => _proxyModels;

  TSEnvNetworkModel _networkModel;
  TSEnvProxyModel _proxyModel;

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
