/*
 * @Author: dvlproad
 * @Date: 2022-04-16 04:32:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-18 00:00:30
 * @Description: url转模拟地址的方法
 */
import 'package:meta/meta.dart'; // 为了使用 @required
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_network_base/src/mock/local_mock_util.dart';
import 'package:flutter_environment/flutter_environment.dart';

extension SimulateExtension on String {
  String toSimulateApi() {
    String simulateApiHost = ApiManager.instance.mockApiHost;
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
