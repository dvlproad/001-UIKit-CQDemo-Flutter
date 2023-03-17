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
  static String testNetworkId1 = "networkId_test1";
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
      TSEnvProxyModel dataModel = TSEnvProxyModel(
        proxyId: dvlproadProxykId,
        name: "超前的代理",
        proxyIp: "192.168.72.56:8888",
      );
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel(
        proxyId: proxykId2,
        name: "泽华的代理",
        proxyIp: "192.168.72.200:8888",
      );
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel(
        proxyId: proxykId3,
        name: "智荣的代理",
        proxyIp: "192.168.72.222:8888",
      );
      envModels.add(dataModel);
    }
    return envModels;
  }

  // 环境:网络环境
  // mock环境
  static String apiHost_mock = "http://121.41.91.92:3000/mock/28/hapi/";
  static TSEnvNetworkModel get networkModel_mock {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: PackageNetworkType.develop1,
      des: '开发模拟包',
      envId: mockNetworkId,
      shortName: "mock",
      name: "模拟的测试环境(mock)",
      apiHost: apiHost_mock,
      socketHost: 'wss://dev.api.xxx.com/im',
      webHost: "http://dev.h5.xxx.com/",
      gameHost: "http://dev.game.h5.xxx.com/",
      monitorApiHost: 'http://dev.api.xxx.com/',
      monitorDataHubId: "datahub-y32g29n6",
      cosParamModel: CosParamModel.other,
      check: false,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );
    return dataModel;
  }

  // 开发环境1
  static String apiHost_dev1 = "http://dev.api.xxx.com/hapi/";
  static TSEnvNetworkModel get networkModel_dev1 {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: PackageNetworkType.develop1,
      des: '开发包',
      envId: developNetworkId1,
      shortName: "开1",
      name: "开发环境1(develop1)",
      apiHost: apiHost_dev1,
      socketHost: 'wss://dev.api.xxx.com/im',
      webHost: "http://dev.h5.xxx.com/",
      gameHost: "http://dev.game.h5.xxx.com/",
      monitorApiHost: 'http://dev.api.xxx.com/',
      monitorDataHubId: "datahub-y32g29n6",
      cosParamModel: CosParamModel.dev,
      check: true,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );

    return dataModel;
  }

  // 开发环境2
  static String apiHost_dev2 = "http://dev2.api.xxx.com/hapi/";
  static TSEnvNetworkModel get networkModel_dev2 {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: PackageNetworkType.develop2,
      des: '开发包',
      envId: developNetworkId2,
      shortName: "开2",
      name: "开发环境2(develop2)",
      apiHost: apiHost_dev2,
      socketHost: 'wss://dev2.api.xxx.com/im',
      webHost: "http://dev2.h5.xxx.com/",
      gameHost: "http://dev2.game.h5.xxx.com/",
      monitorApiHost: 'http://dev2.api.xxx.com/',
      monitorDataHubId: "datahub-y32g29n6",
      cosParamModel: CosParamModel.dev,
      check: false,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );

    return dataModel;
  }

  // test1
  static String apiHost_test1 = "http://test.api.xxx.com/hapi/";
  static TSEnvNetworkModel get networkModel_test1 {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: PackageNetworkType.test1,
      des: '测试包',
      envId: testNetworkId1,
      shortName: "tke",
      name: "tke环境(tke)",
      apiHost: apiHost_test1,
      socketHost: 'ws://test.api.xxx.com/im',
      webHost: "http://test.h5.xxx.com/",
      gameHost: "http://test.game.h5.xxx.com/",
      monitorApiHost: 'http://test.api.xxx.com/',
      monitorDataHubId: "datahub-y32g29n6",
      cosParamModel: CosParamModel.test1,
      check: false,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );
    return dataModel;
  }

  // preProduct
  static TSEnvNetworkModel get networkModel_preProduct {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: PackageNetworkType.preproduct,
      des: '预生产包',
      envId: preproductNetworkId,
      shortName: "pre",
      name: "预生产环境(pre)",
      apiHost: "http://appletapi.xxx.com/hapi/",
      socketHost: 'wss://appletapi.xxx.com/im',
      webHost: "http://h5.xxx.com/",
      gameHost: "http://game.h5.xxx.com/",
      monitorApiHost: 'http://appletapi.xxx.com/',
      monitorDataHubId: "datahub-y32pp556",
      cosParamModel: CosParamModel.preproduct,
      check: false,
      imageUrl:
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg",
    );
    return dataModel;
  }

  // product 生产环境
  static String apiHost_product = "http://appletapi.xxx.com/hapi/";
  static TSEnvNetworkModel get networkModel_product {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel(
      type: PackageNetworkType.product,
      des: '生产包',
      envId: productNetworkId,
      shortName: "pro",
      name: "生产环境(product)",
      apiHost: apiHost_product,
      socketHost: 'wss://appletapi.xxx.com/im',
      webHost: "http://h5.xxx.com/",
      gameHost: "http://game.h5.xxx.com/",
      monitorApiHost: 'http://appletapi.xxx.com/',
      monitorDataHubId: "datahub-y32pp556",
      cosParamModel: CosParamModel.product,
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
        type: PackageNetworkType.develop1,
        des: '开发包',
        envId: ipNetworkId,
        shortName: "ip",
        name: "指定IP测试环境(ip)",
        apiHost: "http://192.168.72.69:8888/hapi/",
        socketHost: 'wss://dev.api.xxx.com/im',
        webHost: "http://dev2.h5.xxx.com/",
        gameHost: "http://dev2.game.h5.xxx.com/",
        monitorApiHost: 'http://192.168.72.69:8888/',
        monitorDataHubId: "datahub-y32g29n6",
        cosParamModel: CosParamModel.other,
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
    envModels.add(networkModel_preProduct); // preProduct
    envModels.add(networkModel_product); // product 生产环境

    return envModels;
  }
}
