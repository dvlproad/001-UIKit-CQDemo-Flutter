import 'package:flutter/material.dart';

import './log_data_bean.dart';

class ApiLogChangeNotifier extends ChangeNotifier {
  String _searchText;
  List<LogModel> _proxyModels;

  String get searchText => _searchText;
  List<LogModel> get proxyModels => _proxyModels;

  searchTextChange(String searchText) {
    _searchText = searchText;
    notifyListeners();
  }

  updateNetworkModels(LogModel networkModel) {
    _searchText = searchText;
    notifyListeners();
  }
}
