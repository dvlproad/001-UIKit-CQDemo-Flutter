import 'package:flutter/material.dart';
import './environment_manager.dart';
import './environment_data_bean.dart';
import './page/environment_page_content.dart';
import './page/api_mock_page_content.dart';

import '../darg/draggable_manager.dart';

class EnvironmentUtil {
  static Future completeEnvInternal_whenNull({
    @required List<TSEnvNetworkModel> networkModels_whenNull,
    @required List<TSEnvProxyModel> proxyModels_whenNull,
    @required String defaultNetworkId_whenNull,
    @required String defaultProxykId_whenNull,
  }) async {
    assert(networkModels_whenNull != null);
    assert(proxyModels_whenNull != null);
    assert(defaultNetworkId_whenNull != null);
    assert(defaultProxykId_whenNull != null);
    return EnvironmentManager()
        .completeEnvInternal_whenNull(
      networkModels_whenNull: networkModels_whenNull,
      proxyModels_whenNull: proxyModels_whenNull,
      defaultNetworkId_whenNull: defaultNetworkId_whenNull,
      defaultProxykId_whenNull: defaultProxykId_whenNull,
    )
        .then((value) {
      TSEnvNetworkModel selectedNetworkModel =
          EnvironmentManager().selectedNetworkModel;
      String apiHost = selectedNetworkModel.apiHost;
      String webHost = selectedNetworkModel.webHost;
      String gameHost = selectedNetworkModel.gameHost;

      TSEnvProxyModel selectedProxyModel =
          EnvironmentManager().selectedProxyModel;
      String proxyIp = selectedProxyModel.proxyIp;

      Map map = {
        'apiHost': apiHost,
        'webHost': webHost,
        'gameHost': gameHost,
      };

      if (isNoneProxyIp(proxyIp) == false) {
        map['proxyIp'] = proxyIp;
      }
      return map;
    });
  }

  // 进入切换环境页面
  static Future goChangeEnvironment(
    BuildContext context, {
    Function() onPressTestApiCallback,
    @required
        Function(String apiHost, String webHost, String gameHost)
            updateNetworkCallback,
    @required Function(String proxyIp) updateProxyCallback,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return EnvironmentPageContent(
            onPressTestApiCallback: onPressTestApiCallback,
            updateNetworkCallback: updateNetworkCallback,
            updateProxyCallback: updateProxyCallback,
          );
        },
      ),
    );
  }

  static bool isNoneProxy() {
    String proxyIp = EnvironmentManager.instance.selectedProxyModel.proxyIp;
    bool noneProxy = isNoneProxyIp(proxyIp);
    return noneProxy;
  }

  static bool isNoneProxyIp(String proxyIp) {
    bool noneProxy = proxyIp == TSEnvProxyModel.noneProxykIp ? true : false;

    return noneProxy;
  }

  // 进入切换 Api mock 的页面
  static Future goChangeApiMock(
    BuildContext context, {
    String mockApiHost,
    Function() onPressTestApiCallback,
    List<Widget> navbarActions,
  }) {
    String normalApiHost =
        EnvironmentManager.instance.selectedNetworkModel.apiHost;

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
