import 'package:flutter/material.dart';

import './api_data_bean.dart';

class ApiLogChangeNotifier extends ChangeNotifier {
  String _searchText;
  List<ApiModel> _proxyModels;

  String get searchText => _searchText;
  List<ApiModel> get proxyModels => _proxyModels;

  searchTextChange(String searchText) {
    _searchText = searchText;
    notifyListeners();
  }

  updateNetworkModels(ApiModel networkModel) {
    _searchText = searchText;
    notifyListeners();
  }
}
