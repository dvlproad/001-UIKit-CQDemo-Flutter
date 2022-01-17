import 'package:flutter/material.dart';

import './api_data_bean.dart';

class ApiMockChangeNotifier extends ChangeNotifier {
  List<ApiModel> _apimockModels;

  List<ApiModel> get apimockModels => _apimockModels;

  updateApiMockModels(List<ApiModel> apimockModels) {
    _apimockModels = apimockModels;
    notifyListeners();
  }
}
