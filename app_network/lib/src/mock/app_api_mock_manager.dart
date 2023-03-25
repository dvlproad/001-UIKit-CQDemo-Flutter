/*
 * @Author: dvlproad
 * @Date: 2022-08-10 20:10:50
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 11:56:41
 * @Description: 
 */
import 'package:flutter_network_base/flutter_network_base.dart';
import 'package:flutter_environment_base/flutter_environment_base.dart';

class AppMockManager {
  static tryDealApi(String api, {required bool isGet}) {
    if (ApiManager().allowMock == true) {
      ApiManager.tryAddApi(api, isGet: isGet);
      bool shouldMock = ApiManager.shouldAfterMockApi(api);
      if (shouldMock) {
        api = api.toSimulateApi();
      }
    }
  }
}

extension SimulateExtension on String {
  String toSimulateApi() {
    String? simulateApiHost = ApiManager().mockApiHost;
    if (simulateApiHost == null) {
      return this;
    }

    List<String> allMockApiHosts = ["http://dev.api.xxx.com/hapi/"];
    String newApi = this.newApi(
      newApiHost: simulateApiHost,
      shouldChangeApiHosts: allMockApiHosts,
    );

    //print('mock newApi = ${newApi}');
    return newApi;
  }

  String toLocalApi() {
    String localApiHost = LocalMockUtil.localApiHost;
    List<String> allMockApiHosts = ["http://dev.api.xxx.com/hapi/"];
    String newApi = this.newApi(
      newApiHost: localApiHost,
      shouldChangeApiHosts: allMockApiHosts,
    );

    //print('mock newApi = ${newApi}');
    return newApi;
  }
}
