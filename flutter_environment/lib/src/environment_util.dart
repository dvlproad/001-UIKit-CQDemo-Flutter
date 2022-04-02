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
  // 获取新的api地址
  String newApi({
    String newApiHost,
    List<String> shouldChangeApiHosts, // 允许 mock api 的 host
  }) {
    String apiPath; //api path
    bool hasHttpPrefix = this.startsWith(RegExp(r'https?:'));
    if (hasHttpPrefix) {
      apiPath = this.removeStartSpecialString(shouldChangeApiHosts);
      if (apiPath == this) {
        print('获取api path失败$this, 无法mock, 仍然是请求原地址');
        return this;
      }
    } else {
      apiPath = this;
    }

    String newApi = newApiHost.env_appendPathString(this);
    //print('mock newApi = ${newApi}');
    return newApi;
  }

  // 如果头部满足是startSpecialStrings中的一种，则去除（用于去除host头部后，来获得path)
  String removeStartSpecialString(
    List<String> startSpecialStrings,
  ) {
    if (startSpecialStrings == null || startSpecialStrings.isEmpty) {
      throw Exception('startSpecialStrings为空，还调用此方法的话，那真是多此一举');
    }

    String remainString;
    for (String startSpecialString in startSpecialStrings) {
      if (this.startsWith(startSpecialString)) {
        remainString = this.substring(startSpecialString.length);
        break;
      }
    }

    return remainString;
  }

  // 拼接两个字符串为一个新的path(会自动增加连接的斜杠/)
  String env_appendPathString(String appendPath) {
    String noslashThis; // 没带斜杠的 api host
    if (this.endsWith('/')) {
      noslashThis = this.substring(0, this.length - 1);
    } else {
      noslashThis = this;
    }

    String hasslashAppendPath; // 带有斜杠的 appendPath
    if (appendPath.startsWith('/')) {
      hasslashAppendPath = appendPath;
    } else {
      hasslashAppendPath = '/' + appendPath;
    }

    String newPath = noslashThis + hasslashAppendPath;
    return newPath;
  }
}
