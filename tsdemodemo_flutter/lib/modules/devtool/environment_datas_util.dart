import 'package:tsdemodemo_flutter/modules/devtool/environment_data_bean.dart';

class TSEnvironmentDataUtil {
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
      dataModel.proxyId = 'develop ip';
      dataModel.name = "无代理";
      envModels.add(dataModel);
    }
    {
      TSEnvProxyModel dataModel = TSEnvProxyModel();
      dataModel.proxyId = 'develop ip';
      dataModel.name = "PROXY 192.168.28.232:8888";
      envModels.add(dataModel);
    }
    return envModels;
  }

  static List<TSEnvNetworkModel> _getEnvNetworkModels() {
    List<TSEnvNetworkModel> envModels = List();
    // develop
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = 'develop ip';
      dataModel.name = "指定IP测试环境(develop)";
      dataModel.hostName = "http://192.168.28.58:80";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = 'develop mock';
      dataModel.name = "模拟的测试环境(develop)";
      dataModel.hostName = "http://www.1nian.xyz:3000/mock/11";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = 'develop';
      dataModel.name = "真正的测试环境(develop)";
      dataModel.hostName = "https://wm1440.com";
      dataModel.check = true;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }

    // preProduct
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = 'preproduct';
      dataModel.name = "预生产环境(preproduct)";
      dataModel.hostName = "http://192.168.28.58:80";
      dataModel.check = false;
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      envModels.add(dataModel);
    }

    // product
    {
      TSEnvNetworkModel dataModel = TSEnvNetworkModel();
      dataModel.envId = 'product';
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
