import 'package:flutter/material.dart';
import './network_page_data_manager.dart';
import './proxy_page_data_manager.dart';
import './page/network_page_content.dart';
import './page/proxy_page_content.dart';
import './page/api_mock_page_content.dart';
import './apimock/manager/api_manager.dart';

import '../darg/draggable_manager.dart';

class EnvironmentUtil {
  // 进入切换环境页面
  static Future goChangeEnvironmentNetwork(
    BuildContext context, {
    Function() onPressTestApiCallback,
    @required
        Function(TSEnvNetworkModel bNetworkModel, {bool shouldExit})
            updateNetworkCallback,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return NetworkPageContent(
            currentProxyIp: ProxyPageDataManager().selectedProxyModel.proxyIp,
            onPressTestApiCallback: onPressTestApiCallback,
            updateNetworkCallback: updateNetworkCallback,
          );
        },
      ),
    );
  }

  // 进入添加代理页面
  static Future goChangeEnvironmentProxy(
    BuildContext context, {
    Function() onPressTestApiCallback,
    @required Function(TSEnvProxyModel bProxyModel) updateProxyCallback,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ProxyPageContent(
            currentApiHost:
                NetworkPageDataManager().selectedNetworkModel.apiHost,
            onPressTestApiCallback: onPressTestApiCallback,
            updateProxyCallback: updateProxyCallback,
          );
        },
      ),
    );
  }

  /// 从from网络环境切换到to网络环境，是否需要自动关闭app.(且如果已登录则重启后需要重新登录)
  static bool Function(TSEnvNetworkModel fromNetworkEnvModel,
      TSEnvNetworkModel toNetworkEnvModel) shouldExitWhenChangeNetworkEnv;

  // 进入切换 Api mock 的页面
  static Future goChangeApiMock(
    BuildContext context, {
    Function() onPressTestApiCallback,
    List<Widget> navbarActions,
  }) {
    String mockApiHost = ApiManager.instance.mockApiHost;
    if (mockApiHost == null) {
      throw Exception(
          '请先调用 ApiManager.configMockApiHost(simulateApiHost)设置api要mock到的地址');
    }
    String normalApiHost =
        NetworkPageDataManager.instance.selectedNetworkModel.apiHost;

    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ApiMockPageContent(
            mockApiHost: mockApiHost,
            normalApiHost: normalApiHost,
            onPressTestApiCallback: onPressTestApiCallback,
            navbarActions: navbarActions,
          );
        },
      ),
    );
  }
}

// api 模拟
extension ApiSimulateExtension on String {
  String addSimulateApiHost(
    String simulateApiHost, {
    List<String> allMockApiHosts, // 允许 mock api 的 host
  }) {
    String apiPath; //api path
    bool hasHttpPrefix = this.startsWith(RegExp(r'https?:'));
    if (hasHttpPrefix) {
      bool getShortPathSuccess = false;
      for (String checkApiHost in allMockApiHosts) {
        if (this.startsWith(checkApiHost)) {
          apiPath = this.substring(checkApiHost.length);
          getShortPathSuccess = true;
          break;
        }
      }

      if (getShortPathSuccess == false) {
        print('获取api path失败$this, 无法mock, 仍然是请求原地址');
        return this;
      }
    } else {
      apiPath = this;
    }

    String noslashApiHost; // 没带斜杠的 api host
    if (simulateApiHost.endsWith('/')) {
      noslashApiHost = simulateApiHost.substring(0, simulateApiHost.length - 1);
    } else {
      noslashApiHost = simulateApiHost;
    }

    String hasslashPath; // 带有斜杠的api path
    if (this.startsWith('/')) {
      hasslashPath = apiPath;
    } else {
      hasslashPath = '/' + apiPath;
    }

    String newApi = noslashApiHost + hasslashPath;

    //print('mock newApi = ${newApi}');
    return newApi;
  }
}
