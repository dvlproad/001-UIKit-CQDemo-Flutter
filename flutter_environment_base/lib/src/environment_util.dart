import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

// 网络 network
import './network_page_data_manager.dart';
import './page/network_page_content.dart';

// 发布平台大类型 target
import './data_target/packageType_page_data_manager.dart';
import './page/target_page_content.dart';

// 代理 proxy
import './proxy_page_data_manager.dart';
import './page/proxy_page_content.dart';

// 接口模拟 api mock
import './page/api_mock_page_content.dart';
import './apimock/manager/api_manager.dart';

// 悬浮按钮
// import '../darg/draggable_manager.dart';

import './device/device_info_util.dart';

class EnvironmentUtil {
  // 进入切换环境页面
  static Future goChangeEnvironmentNetwork(
    BuildContext context, {
    Function()? onPressTestApiCallback,
    required Function(TSEnvNetworkModel bNetworkModel,
            {required bool shouldExit})
        updateNetworkCallback,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return NetworkPageContent(
            currentProxyIp:
                ProxyPageDataManager().selectedProxyModel.proxyIp ?? 'null',
            onPressTestApiCallback: onPressTestApiCallback,
            updateNetworkCallback: updateNetworkCallback,
          );
        },
      ),
    );
  }

  // 进入切换发布平台大类型页面
  static Future goChangeEnvironmentTarget(
    BuildContext context, {
    required Function(PackageTargetModel bTargetModel) updateTargetCallback,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return TargetPageContent(
            updateTargetCallback: updateTargetCallback,
          );
        },
      ),
    );
  }

  /// 切换到无代理，如果已是无代理，则尝试切到手机代理(返回值:表示是否选中的代理有发生改变，决定是否要刷新界面)
  // ignore: non_constant_identifier_names
  static Future<bool> changeToNoneProxy_ifNoneTryToPhone() async {
    String? currentAppProxyIp =
        ProxyPageDataManager().selectedProxyModel.proxyIp;

    // 如果app当前有代理，则默认要先切换到无代理
    if (currentAppProxyIp != null) {
      ProxyPageDataManager().addOrUpdateEnvProxyModel(
        newProxyModel: TSEnvProxyModel.noneProxyModel(),
      );
      ToastUtil.showMessage("恭喜成功切换到【无代理】上");
      return true;
    }

    // 如果app当前无代理，则查看是否有手机代理，有则切，没则不变
    TSEnvProxyModel? phoneProxyModel = await DeviceInfoUtil.getPhoneProxy();
    if (phoneProxyModel == null) {
      ToastUtil.showMessage("未检测到您手机有设置代理，无法切换，请检查");
      return false;
    }

    ProxyPageDataManager().addOrUpdateEnvProxyModel(
      newProxyModel: phoneProxyModel,
    );
    ToastUtil.showMessage("恭喜成功切换到【手机代理】上");
    return true;
  }

  // 进入添加代理页面
  static Future goChangeEnvironmentProxy(
    BuildContext context, {
    Function()? onPressTestApiCallback,
    required Function(TSEnvProxyModel bProxyModel) updateProxyCallback,
  }) {
    String currentApiHost =
        NetworkPageDataManager().selectedNetworkModel.apiHost;
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ProxyPageContent(
            currentApiHost: currentApiHost,
            onPressTestApiCallback: onPressTestApiCallback,
            updateProxyCallback: updateProxyCallback,
          );
        },
      ),
    );
  }

  /// 从from网络环境切换到to网络环境，是否需要自动关闭app.(且如果已登录则重启后需要重新登录)
  static bool Function(TSEnvNetworkModel fromNetworkEnvModel,
      TSEnvNetworkModel toNetworkEnvModel)? shouldExitWhenChangeNetworkEnv;
  static bool Function(
          PackageTargetModel fromTargetModel, PackageTargetModel toTargetModel)?
      shouldExitWhenChangeTargetEnv;

  // 进入切换 Api mock 的页面
  static Future goChangeApiMock(
    BuildContext context, {
    Function()? onPressTestApiCallback,
    List<Widget>? navbarActions,
  }) {
    String? mockApiHost = ApiManager().mockApiHost;
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
    required String newApiHost,
    required List<String>
        shouldChangeApiHosts, // 允许 mock api 的 host，即使同一环境也可能有多个网络库，多种host
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
    if (startSpecialStrings.isEmpty) {
      throw Exception('startSpecialStrings为空，还调用此方法的话，那真是多此一举');
    }

    String remainString = this;
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
