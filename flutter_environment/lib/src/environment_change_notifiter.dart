import 'package:flutter/material.dart';

import './environment_data_bean.dart';

class EnvironmentChangeNotifier extends ChangeNotifier {
  String _searchText;
  List<TSEnvNetworkModel> _networkModels;
  List<TSEnvProxyModel> _proxyModels;

  String get searchText => _searchText;
  List<TSEnvNetworkModel> get networkModels => _networkModels;
  List<TSEnvProxyModel> get proxyModels => _proxyModels;

  searchTextChange(String searchText) {
    _searchText = searchText;
    notifyListeners();
  }

  updateNetworkModels(TSEnvNetworkModel networkModel) {
    _searchText = searchText;
    notifyListeners();
  }
}
