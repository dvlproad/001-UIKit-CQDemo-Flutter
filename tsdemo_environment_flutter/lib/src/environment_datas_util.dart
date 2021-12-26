import 'package:flutter/material.dart';
import 'package:flutter_environment/flutter_environment.dart';

extension SimulateExtension on EnvironmentManager {
  // 初始方法
  check() async {
    if (EnvironmentManager().environmentModel == null) {
      // 获取列表model
      TSEnvironmentModel envModel = TSEnvironmentDataUtil.getEnvironmentModel();
      // 使用获取的model，完善 network 和 proxy

      // 设置默认的网络、代理环境
      String defaultNetworkId = TSEnvironmentDataUtil.mockNetworkId;
      String defaultProxykId = TSEnvironmentDataUtil.noneProxykId;

      await EnvironmentManager().completeEnvInternal(
        environmentModel: envModel,
        defaultNetworkId: defaultNetworkId,
        defaultProxykId: defaultProxykId,
      );
    }
  }
}

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
  static String customProxykId = "proxyId_custom";

  static TSEnvironmentModel getEnvironmentModel() {
    TSEnvironmentModel envModel = TSEnvironmentModel();
    envModel.networkTitle = "网络环境";
    envModel.networkModels = TSEnvironmentDataUtil._getEnvNetworkModels();

    envModel.proxyTitle = "网络代理";
    envModel.proxyModels = TSEnvironmentDataUtil._getEnvProxyModels();

    return envModel;
  }

  // 环境:网络代理
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
      dataModel.name = "用户1代理";
      dataModel.proxyIp = "PROXY 192.168.28.231:8888";
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = yongshengProxykId;
      dataModel.name = "用户2代理";
      dataModel.proxyIp = "PROXY 192.168.1.3:8888";
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = weixiangProxykId;
      dataModel.name = "用户3代理";
      dataModel.proxyIp = "PROXY 192.168.28.107:8888";
      envModels.add(dataModel);
    }
    return envModels;
  }

  // 环境:网络环境
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
