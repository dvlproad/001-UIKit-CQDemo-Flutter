/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-19 14:07:44
 * @Description: 
 */
import 'package:flutter/material.dart';

import './api_data_bean.dart';

class ApiMockChangeNotifier extends ChangeNotifier {
  late List<ApiModel> _apimockModels;

  List<ApiModel> get apimockModels => _apimockModels;

  updateApiMockModels(List<ApiModel> apimockModels) {
    _apimockModels = apimockModels;
    notifyListeners();
  }
}
