// ignore_for_file: non_constant_identifier_names

import 'package:app_environment/app_environment.dart';

class TSEnvironmentDataUtil {
  // // 设置默认的环境
  // static String defaultNetworkId = developNetworkId1;
  // static String defaultProxykId = noneProxykId;

  // network
  static String ipNetworkId = "networkId_ip";
  static String mockNetworkId = "networkId_mock";
  static String developNetworkId1 = "networkId_develop1";
  static String developNetworkId2 = "networkId_develop2";
  static String testNetworkId1 = "networkId_test1";
  static String testNetworkId2 = "networkId_test2";
  static String preproductNetworkId = "networkId_preproduct";
  static String productNetworkId = "networkId_product";

  // proxy
  static String noneProxykId = TSEnvProxyModel.noneProxykId;
  static String dvlproadProxykId = "proxyId_chaoqian";
  static String proxykId_developer2 = "proxykId_developer2";
  static String proxykId_tester1 = "proxykId_tester1";
  static String proxykId_tester2 = "proxykId_tester2";
  static String customProxykId = "proxyId_custom";

  // 环境:网络代理
  static List<TSEnvProxyModel> getEnvProxyModels() {
    List<TSEnvProxyModel> envModels = [];
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel.noneProxyModel();
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel(
        proxyId: dvlproadProxykId,
        name: "超前的代理",
        proxyIp: "192.168.72.56:8888",
      );
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel(
        proxyId: proxykId_developer2,
        name: "泽华的代理",
        proxyIp: "192.168.72.254:8888",
      );
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel(
        proxyId: proxykId_tester1,
        name: "婉艺的代理",
        proxyIp: "192.168.23.119:8888",
      );
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel(
        proxyId: proxykId_tester2,
        name: "智荣的代理",
        proxyIp: "192.168.72.222:8888",
      );
      envModels.add(dataModel);
    }
    return envModels;
  }

  // 环境:网络环境
  // mock环境
  static TSEnvNetworkModel get networkModel_mock {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: AppEnvConfig.envType,
      des: AppEnvConfig.des,
      envId: AppEnvConfig.envId,
      shortName: AppEnvConfig.shortName,
      name: AppEnvConfig.name,
      apiHost: AppEnvConfig.apiHost,
      socketHost: AppEnvConfig.socketHost,
      webHost: AppEnvConfig.webHost,
      gameHost: AppEnvConfig.gameHost,
      monitorApiHost: AppEnvConfig.monitorApiHost,
      monitorDataHubId: AppEnvConfig.monitorDataHubId,
      cosParamModel: AppEnvConfig.cosParamModel,
      check: false,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );
    return dataModel;
  }

  // 开发环境1
  static TSEnvNetworkModel get networkModel_dev1 {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: AppEnvConfig.envType,
      des: AppEnvConfig.des,
      envId: AppEnvConfig.envId,
      shortName: AppEnvConfig.shortName,
      name: AppEnvConfig.name,
      apiHost: AppEnvConfig.apiHost,
      socketHost: AppEnvConfig.socketHost,
      webHost: AppEnvConfig.webHost,
      gameHost: AppEnvConfig.gameHost,
      monitorApiHost: AppEnvConfig.monitorApiHost,
      monitorDataHubId: AppEnvConfig.monitorDataHubId,
      cosParamModel: AppEnvConfig.cosParamModel,
      check: true,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );

    return dataModel;
  }

  // 开发环境2
  static TSEnvNetworkModel get networkModel_dev2 {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: AppEnvConfig.envType,
      des: AppEnvConfig.des,
      envId: AppEnvConfig.envId,
      shortName: AppEnvConfig.shortName,
      name: AppEnvConfig.name,
      apiHost: AppEnvConfig.apiHost,
      socketHost: AppEnvConfig.socketHost,
      webHost: AppEnvConfig.webHost,
      gameHost: AppEnvConfig.gameHost,
      monitorApiHost: AppEnvConfig.monitorApiHost,
      monitorDataHubId: AppEnvConfig.monitorDataHubId,
      cosParamModel: AppEnvConfig.cosParamModel,
      check: false,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );

    return dataModel;
  }

  // test1
  static TSEnvNetworkModel get networkModel_test1 {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: AppEnvConfig.envType,
      des: AppEnvConfig.des,
      envId: AppEnvConfig.envId,
      shortName: AppEnvConfig.shortName,
      name: AppEnvConfig.name,
      apiHost: AppEnvConfig.apiHost,
      socketHost: AppEnvConfig.socketHost,
      webHost: AppEnvConfig.webHost,
      gameHost: AppEnvConfig.gameHost,
      monitorApiHost: AppEnvConfig.monitorApiHost,
      monitorDataHubId: AppEnvConfig.monitorDataHubId,
      cosParamModel: AppEnvConfig.cosParamModel,
      check: false,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );
    return dataModel;
  }

  // test2
  static TSEnvNetworkModel get networkModel_test2 {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: AppEnvConfig.envType,
      des: AppEnvConfig.des,
      envId: AppEnvConfig.envId,
      shortName: AppEnvConfig.shortName,
      name: AppEnvConfig.name,
      apiHost: AppEnvConfig.apiHost,
      socketHost: AppEnvConfig.socketHost,
      webHost: AppEnvConfig.webHost,
      gameHost: AppEnvConfig.gameHost,
      monitorApiHost: AppEnvConfig.monitorApiHost,
      monitorDataHubId: AppEnvConfig.monitorDataHubId,
      cosParamModel: AppEnvConfig.cosParamModel,
      check: false,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );
    return dataModel;
  }

  // preProduct
  static TSEnvNetworkModel get networkModel_preProduct {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: AppEnvConfig.envType,
      des: AppEnvConfig.des,
      envId: AppEnvConfig.envId,
      shortName: AppEnvConfig.shortName,
      name: AppEnvConfig.name,
      apiHost: AppEnvConfig.apiHost,
      socketHost: AppEnvConfig.socketHost,
      webHost: AppEnvConfig.webHost,
      gameHost: AppEnvConfig.gameHost,
      monitorApiHost: AppEnvConfig.monitorApiHost,
      monitorDataHubId: AppEnvConfig.monitorDataHubId,
      cosParamModel: AppEnvConfig.cosParamModel,
      check: false,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );
    return dataModel;
  }

  // product 生产环境
  static TSEnvNetworkModel get networkModel_product {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: AppEnvConfig.envType,
      des: AppEnvConfig.des,
      envId: AppEnvConfig.envId,
      shortName: AppEnvConfig.shortName,
      name: AppEnvConfig.name,
      apiHost: AppEnvConfig.apiHost,
      socketHost: AppEnvConfig.socketHost,
      webHost: AppEnvConfig.webHost,
      gameHost: AppEnvConfig.gameHost,
      monitorApiHost: AppEnvConfig.monitorApiHost,
      monitorDataHubId: AppEnvConfig.monitorDataHubId,
      cosParamModel: AppEnvConfig.cosParamModel,
      check: false,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );
    return dataModel;
  }

  static List<TSEnvNetworkModel> getEnvNetworkModels() {
    List<TSEnvNetworkModel> envModels = [];
    // 指定IP环境
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel(
        type: AppEnvConfig.envType,
        des: AppEnvConfig.des,
        envId: AppEnvConfig.envId,
        shortName: AppEnvConfig.shortName,
        name: AppEnvConfig.name,
        apiHost: AppEnvConfig.apiHost,
        socketHost: AppEnvConfig.socketHost,
        webHost: AppEnvConfig.webHost,
        gameHost: AppEnvConfig.gameHost,
        monitorApiHost: AppEnvConfig.monitorApiHost,
        monitorDataHubId: AppEnvConfig.monitorDataHubId,
        cosParamModel: AppEnvConfig.cosParamModel,
        check: false,
        imageUrl:
            "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
      );
      envModels.add(dataModel);
    }
    envModels.add(networkModel_mock); // mock环境
    envModels.add(networkModel_dev1); // 开发环境1
    envModels.add(networkModel_dev2); // 开发环境2
    envModels.add(networkModel_test1); // 测试环境1
    envModels.add(networkModel_test2); // 测试环境2
    envModels.add(networkModel_preProduct); // preProduct
    envModels.add(networkModel_product); // product 生产环境

    return envModels;
  }
}
