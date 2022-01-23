import 'package:flutter_environment/flutter_environment.dart';

class TSEnvironmentDataUtil {
  // // 设置默认的环境
  // static String defaultNetworkId = developNetworkId1;
  // static String defaultProxykId = noneProxykId;

  // network
  static String ipNetworkId = "networkId_ip";
  static String mockNetworkId = "networkId_mock";
  static String developNetworkId1 = "networkId_develop1";
  static String developNetworkId2 = "networkId_develop2";
  static String preproductNetworkId = "networkId_preproduct";
  static String productNetworkId = "networkId_product";

  // proxy
  static String noneProxykId = TSEnvProxyModel.noneProxykId;
  static String dvlproadProxykId = "proxyId_chaoqian";
  static String proxykId2 = "proxyId_2";
  static String proxykId3 = "proxyId_3";
  static String customProxykId = "proxyId_custom";

  // 环境:网络代理
  static List<TSEnvProxyModel> getEnvProxyModels() {
    List<TSEnvProxyModel> envModels = [];
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel.noneProxyModel();
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = dvlproadProxykId;
      dataModel.name = "用户1的代理";
      dataModel.proxyIp = "192.168.72.56:8888";
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = proxykId2;
      dataModel.name = "用户2的代理";
      dataModel.proxyIp = "192.168.72.68:8888";
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = proxykId3;
      dataModel.name = "用户3的代理";
      dataModel.proxyIp = "192.168.72.9:8888";
      envModels.add(dataModel);
    }
    return envModels;
  }

  // 环境:网络环境
  static String dev_mockApiHost = "http://121.41.91.92:3000/mock/28/";
  static String productApiHost = "http://api.xxx.com/hapi/";

  static List<TSEnvNetworkModel> getEnvNetworkModels() {
    List<TSEnvNetworkModel> envModels = [];
    // develop
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = ipNetworkId;
      dataModel.name = "指定IP测试环境(ip)";
      dataModel.apiHost = "http://192.168.28.58:80/";
      dataModel.webHost = "http://dev.h5.xxx.com/";
      dataModel.gameHost = "http://dev.game.h5.xxx.com/";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = mockNetworkId;
      dataModel.name = "模拟的测试环境(mock)";
      dataModel.apiHost = dev_mockApiHost;
      dataModel.webHost = "http://dev.h5.xxx.com/";
      dataModel.gameHost = "http://dev.game.h5.xxx.com/";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }
    // 开发环境
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = developNetworkId1;
      dataModel.name = "开发环境1(develop1)";
      dataModel.apiHost = "http://dev.api.xxx.com/hapi/";
      dataModel.webHost = "http://dev.h5.xxx.com/";
      dataModel.gameHost = "http://dev.game.h5.xxx.com/";
      dataModel.check = true;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }
    // 开发环境2
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = developNetworkId2;
      dataModel.name = "开发环境2(develop2)";
      dataModel.apiHost = "http://dev2.api.xxx.com/hapi/";
      dataModel.webHost = "http://dev2.h5.xxx.com/";
      dataModel.gameHost = "http://dev2.game.h5.xxx.com/";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }

    // preProduct
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = preproductNetworkId;
      dataModel.name = "预生产环境(preproduct)";
      dataModel.apiHost = "http://test.api.xxx.com/hapi/";
      dataModel.webHost = "http://test.h5.xxx.com/";
      dataModel.gameHost = "http://test.game.h5.xxx.com/";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }

    // product 生产环境
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = productNetworkId;
      dataModel.name = "生产环境(product)";
      dataModel.apiHost = productApiHost;
      dataModel.webHost = "http://h5.xxx.com/";
      dataModel.gameHost = "http://game.h5.xxx.com/";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }

    return envModels;
  }
}

extension SimulateExtension on String {
  String toSimulateApi() {
    String simulateApiHost = TSEnvironmentDataUtil.dev_mockApiHost;
    List<String> allMockApiHosts = ["http://dev.api.xxx.com/hapi/"];
    String newApi = this.addSimulateApiHost(
      simulateApiHost,
      allMockApiHosts: allMockApiHosts,
    );

    //print('mock newApi = ${newApi}');
    return newApi;
  }
}
