import 'package:flutter/material.dart';
import 'package:flutter_network/flutter_network.dart';

import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';
import '../dev_util.dart';
import './environment_datas_util.dart';

import 'package:flutter_demo_kit/flutter_demo_kit.dart';

class Main_Init {
  static init() {
    _initNetwork();

    _initEnvironmentManager();
    _initApiMockManager();

    LogUtil.init(isDebug: true);
  }

  static initView(GlobalKey globalKey) {
    ApplicationDraggableManager.globalKey = globalKey;
    ApplicationLogViewManager.globalKey = globalKey;

    DevUtil.navigatorKey = globalKey;
    Future.delayed(const Duration(milliseconds: 3000), () {
      DevUtil.showDevFloatingWidget(
        showTestApiWidget: true,
      );
    });

    CheckVersionUtil.navigatorKey = globalKey;
  }

  // 配置网络
  static _initNetwork() {
    NetworkManager.start(
      baseUrl: TSEnvironmentDataUtil.productApiHost,
      connectTimeout: 15000,
    );

    // String token = await UserInfoManager.instance.getToken();
    // final requestHeaders = {'Authorization': token};
    // NetworkChangeUtil.changeHeaders(headers: requestHeaders);
    // Options options = Options(headers: requestHeaders);
  }

  static _initEnvironmentManager() {
    List<TSEnvNetworkModel> networkModels_whenNull =
        TSEnvironmentDataUtil.getEnvNetworkModels();
    List<TSEnvProxyModel> proxyModels_whenNull =
        TSEnvironmentDataUtil.getEnvProxyModels();
    String defaultNetworkId_whenNull = TSEnvironmentDataUtil.developNetworkId2;
    String defaultProxykId_whenNull = TSEnvironmentDataUtil.noneProxykId;
    EnvironmentUtil.completeEnvInternal_whenNull(
      networkModels_whenNull: networkModels_whenNull,
      proxyModels_whenNull: proxyModels_whenNull,
      defaultNetworkId_whenNull: defaultNetworkId_whenNull,
      defaultProxykId_whenNull: defaultProxykId_whenNull,
    ).then((value) {
      String apiHost = value['apiHost'];
      String webHost = value['webHost'];
      String gameHost = value['gameHost'];
      String proxyIp = value['proxyIp'];

      NetworkChangeUtil.changeProxy(proxyIp);

      NetworkChangeUtil.changeOptions(baseUrl: apiHost);
    });
  }

  static _initApiMockManager() {
    ApiManager.updateCanMock(false);

    List<ApiModel> apiMockModels = [];
    for (int i = 0; i < 10; i++) {
      String name = '接口$i';
      String Url = cqtsRandomString(0, 10, CQRipeStringType.english);
      ApiModel apiMockModel = ApiModel(name: name, url: Url, mock: false);
      apiMockModels.add(apiMockModel);
      // ApiManager.tryAddApi(Url);
    }
    ApiManager().completeApiMock_whenNull(apiModels_whenNull: apiMockModels);
  }
}
