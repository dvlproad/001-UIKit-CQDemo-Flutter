import 'package:meta/meta.dart'; // 为了使用 @required
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';

extension SimulateExtension on String {
  String toSimulateApi() {
    String simulateApiHost = ApiManager.instance.mockApiHost;
    List<String> allMockApiHosts = ["http://dev.api.xihuanwu.com/hapi/"];
    String newApi = this.newApi(
      newApiHost: simulateApiHost,
      shouldChangeApiHosts: allMockApiHosts,
    );

    //print('mock newApi = ${newApi}');
    return newApi;
  }

  String toLocalApi() {
    String localApiHost = NetworkUtil.localApiHost;
    List<String> allMockApiHosts = ["http://dev.api.xihuanwu.com/hapi/"];
    String newApi = this.newApi(
      newApiHost: localApiHost,
      shouldChangeApiHosts: allMockApiHosts,
    );

    //print('mock newApi = ${newApi}');
    return newApi;
  }
}
