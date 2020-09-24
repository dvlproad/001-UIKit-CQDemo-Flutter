import 'package:flutter/material.dart';
import 'package:flutter_environment/flutter_environment.dart';

class TSEnvironmentDataUtil {
  // // 设置默认的环境
  // static String defaultNetworkId = developNetworkId;
  // static String defaultProxykId = noneProxykId;

  // network
  static String ipNetworkId = "networkId_ip";
  static String mockNetworkId = "networkId_mock";
  static String developNetworkId = "networkId_develop";
  static String preproductNetworkId = "networkId_preproduct";
  static String productNetworkId = "networkId_product";

  // proxy
  static String noneProxykId = "proxyId_none";
  static String chaoqianProxykId = "proxyId_chaoqian";
  static String yongshengProxykId = "proxyId_yongsheng";
  static String weixiangProxykId = "proxyId_weixiang";

  completeInternal({
    @required String defaultNetworkId,
    @required String defaultProxykId,
  }) {
    TSEnvironmentModel envModel = TSEnvironmentDataUtil.getEnvironmentModel();
    EnvironmentManager().completeEnvInternal(
      environmentModel: envModel,
      defaultNetworkId: defaultNetworkId,
      defaultProxykId: defaultProxykId,
    );
  }

  static TSEnvironmentModel getEnvironmentModel() {
    TSEnvironmentModel envModel = TSEnvironmentModel();
    envModel.networkTitle = "网络环境";
    envModel.networkModels = TSEnvironmentDataUtil._getEnvNetworkModels();

    envModel.proxyTitle = "网络代理";
    envModel.proxyModels = TSEnvironmentDataUtil._getEnvProxyModels();

    return envModel;
  }

  static List<TSEnvProxyModel> _getEnvProxyModels() {
    List<TSEnvProxyModel> envModels = List();
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = noneProxykId;
      dataModel.name = "无代理";
      dataModel.proxyIp = "none";
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = chaoqianProxykId;
      dataModel.name = "超前代理";
      dataModel.proxyIp = "PROXY 192.168.28.231:8888";
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = yongshengProxykId;
      dataModel.name = "永生代理";
      dataModel.proxyIp = "PROXY 192.168.1.3:8888";
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = weixiangProxykId;
      dataModel.name = "伟详代理";
      dataModel.proxyIp = "PROXY 192.168.28.107:8888";
      envModels.add(dataModel);
    }
    return envModels;
  }

  static List<TSEnvNetworkModel> _getEnvNetworkModels() {
    List<TSEnvNetworkModel> envModels = List();
    // develop
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = ipNetworkId;
      dataModel.name = "指定IP测试环境(ip)";
      dataModel.hostName = "http://192.168.28.58:80";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = mockNetworkId;
      dataModel.name = "模拟的测试环境(mock)";
      dataModel.hostName = "http://www.1nian.xyz:3000/mock/11";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = developNetworkId;
      dataModel.name = "真正的测试环境(develop)";
      dataModel.hostName = "https://wm1440.com";
      dataModel.check = true;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }

    // // preProduct
    // {
    //   TSEnvNetworkModel dataModel = TSEnvNetworkModel();
    //   dataModel.envId = preproductNetworkId;
    //   dataModel.name = "预生产环境(preproduct)";
    //   dataModel.hostName = "http://192.168.28.58:80";
    //   dataModel.check = false;
    //   dataModel.imageUrl =
    //       "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
    //   envModels.add(dataModel);
    // }

    // product
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = productNetworkId;
      dataModel.name = "生产环境(product)";
      dataModel.hostName = "https://civilization1440.com";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }

    return envModels;
  }
}
