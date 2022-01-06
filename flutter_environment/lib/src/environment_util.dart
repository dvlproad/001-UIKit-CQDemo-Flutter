import 'package:flutter/material.dart';
import './environment_manager.dart';
import './environment_data_bean.dart';
import './page/environment_page_content.dart';
import './page/api_mock_page_content.dart';

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
  static void goChangeEnvironment(
    BuildContext context, {
    Function() onPressTestApiCallback,
    @required
        Function(String apiHost, String webHost, String gameHost)
            updateNetworkCallback,
    @required Function(String proxyIp) updateProxyCallback,
  }) {
    Navigator.of(context).push(
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
  static void goChangeApiMock(
    BuildContext context, {
    String mockApiHost,
    Function() onPressTestApiCallback,
    List<Widget> navbarActions,
  }) {
    String normalApiHost =
        EnvironmentManager.instance.selectedNetworkModel.apiHost;

    Navigator.of(context).push(
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
