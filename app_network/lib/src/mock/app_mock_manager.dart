/*
 * @Author: dvlproad
 * @Date: 2022-08-10 20:10:50
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-11 00:22:16
 * @Description: 
 */
import 'package:meta/meta.dart'; // 为了使用 required
import 'package:flutter_environment/flutter_environment.dart';
import '../app_api_simulate_util.dart';

class AppMockManager {
  static tryDealApi(String api, {required bool isGet}) {
    if (ApiManager.instance.allowMock == true) {
      ApiManager.tryAddApi(api, isGet: isGet);
      bool shouldMock = ApiManager.shouldAfterMockApi(api);
      if (shouldMock) {
        api = (api as String).toSimulateApi();
      }
    }
  }
}
