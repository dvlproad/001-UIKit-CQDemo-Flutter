import 'package:flutter_network/flutter_network.dart';

import 'package:flutter_environment/flutter_environment.dart';
import './environment_datas_util.dart';

import 'package:flutter_demo_kit/flutter_demo_kit.dart';

class Main_Init {
  static init() {
    _initNetwork();

    _initEnvironmentManager();
    _initApiMockManager();
  }

  // 配置网络
  static _initNetwork() {
    NetworkManager.start(
      baseUrl: "http://dev.api.xihuanwu.com/hapi/",
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
    String defaultNetworkId_whenNull = TSEnvironmentDataUtil.developNetworkId;
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

    List<ApiModel> apiModels = [];
    for (int i = 0; i < 10; i++) {
      String Url = cqtsRandomString(0, 10, CQRipeStringType.english);
      ApiModel apiModel = ApiModel(url: Url, mock: false);
      apiModels.add(apiModel);
      // ApiManager.tryAddApi(Url);
    }
    ApiManager().completeApiMock_whenNull(apiModels_whenNull: apiModels);
  }
}
