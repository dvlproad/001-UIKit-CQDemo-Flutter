/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-10 22:25:10
 * @Description: 
 */
import 'package:flutter/material.dart';

import './log_data_bean.dart';

class ApiLogChangeNotifier extends ChangeNotifier {
  String? _searchText;
  List<LogModel>? _proxyModels;

  String? get searchText => _searchText;
  List<LogModel>? get proxyModels => _proxyModels;

  searchTextChange(String searchText) {
    _searchText = searchText;
    notifyListeners();
  }

  updateNetworkModels(LogModel networkModel) {
    _searchText = searchText;
    notifyListeners();
  }
}
