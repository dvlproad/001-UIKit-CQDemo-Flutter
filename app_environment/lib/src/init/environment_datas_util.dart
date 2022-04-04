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
      dataModel.name = "超前的代理";
      dataModel.proxyIp = "192.168.72.56:8888";
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = proxykId2;
      dataModel.name = "泽华的代理";
      dataModel.proxyIp = "192.168.72.200:8888";
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = proxykId3;
      dataModel.name = "跃程的代理";
      dataModel.proxyIp = "192.168.72.12:8888";
      envModels.add(dataModel);
    }
    return envModels;
  }

  // 环境:网络环境
  // mock环境
  static String apiHost_mock = "http://121.41.91.92:3000/mock/28/hapi/";
  static TSEnvNetworkModel get networkModel_mock {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel();
    dataModel.envId = mockNetworkId;
    dataModel.shortName = "mock";
    dataModel.name = "模拟的测试环境(mock)";
    dataModel.apiHost = apiHost_mock;
    dataModel.webHost = "http://dev.h5.xihuanwu.com/";
    dataModel.gameHost = "http://dev.game.h5.xihuanwu.com/";
    dataModel.check = false;
    dataModel.imageUrl =
        "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
    return dataModel;
  }

  // 开发环境1
  static String apiHost_dev1 = "http://dev.api.xihuanwu.com/hapi/";
  static TSEnvNetworkModel get networkModel_dev1 {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel();
    dataModel.envId = developNetworkId1;
    dataModel.shortName = "dev1";
    dataModel.name = "开发环境1(develop1)";
    dataModel.apiHost = apiHost_dev1;
    dataModel.webHost = "http://dev.h5.xihuanwu.com/";
    dataModel.gameHost = "http://dev.game.h5.xihuanwu.com/";
    dataModel.check = true;
    dataModel.imageUrl =
        "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";

    return dataModel;
  }

  // 开发环境2
  static String apiHost_dev2 = "http://dev2.api.xihuanwu.com/hapi/";
  static TSEnvNetworkModel get networkModel_dev2 {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel();
    dataModel.envId = developNetworkId2;
    dataModel.shortName = "dev2";
    dataModel.name = "开发环境2(develop2)";
    dataModel.apiHost = apiHost_dev2;
    dataModel.webHost = "http://dev2.h5.xihuanwu.com/";
    dataModel.gameHost = "http://dev2.game.h5.xihuanwu.com/";
    dataModel.check = false;
    dataModel.imageUrl =
        "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";

    return dataModel;
  }

  // preProduct
  static String apiHost_preProduct = "http://test.api.xihuanwu.com/hapi/";
  static TSEnvNetworkModel get networkModel_preProduct {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel();
    dataModel.envId = preproductNetworkId;
    dataModel.shortName = "tke";
    dataModel.name = "tke环境(tke)";
    dataModel.apiHost = apiHost_preProduct;
    dataModel.webHost = "http://test.h5.xihuanwu.com/";
    dataModel.gameHost = "http://test.game.h5.xihuanwu.com/";
    dataModel.check = false;
    dataModel.imageUrl =
        "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
    return dataModel;
  }

  // product 生产环境
  static String apiHost_product = "http://appletapi.xihuanwu.com/hapi/";
  static TSEnvNetworkModel get networkModel_product {
    TSEnvNetworkModel dataModel = TSEnvNetworkModel();
    dataModel.envId = productNetworkId;
    dataModel.shortName = "生产";
    dataModel.name = "生产环境(product)";
    dataModel.apiHost = apiHost_product;
    dataModel.webHost = "http://h5.xihuanwu.com/";
    dataModel.gameHost = "http://game.h5.xihuanwu.com/";
    dataModel.check = false;
    dataModel.imageUrl =
        "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
    return dataModel;
  }

  static List<TSEnvNetworkModel> getEnvNetworkModels() {
    List<TSEnvNetworkModel> envModels = [];
    // 指定IP环境
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = ipNetworkId;
      dataModel.shortName = "ip";
      dataModel.name = "指定IP测试环境(ip)";
      dataModel.apiHost = "http://192.168.72.69:8888/hapi/";
      dataModel.webHost = "http://dev2.h5.xihuanwu.com/";
      dataModel.gameHost = "http://dev2.game.h5.xihuanwu.com/";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }
    envModels.add(networkModel_mock); // mock环境
    envModels.add(networkModel_dev1); // 开发环境1
    envModels.add(networkModel_dev2); // 开发环境2
    envModels.add(networkModel_preProduct); // preProduct
    envModels.add(networkModel_product); // product 生产环境

    return envModels;
  }
}
