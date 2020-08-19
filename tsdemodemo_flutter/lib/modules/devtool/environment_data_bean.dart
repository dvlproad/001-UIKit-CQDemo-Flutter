class TSEnvironmentModel {
  String networkTitle;
  List<TSEnvNetworkModel> networkModels;

  String proxyTitle;
  List<TSEnvProxyModel> proxyModels;
}

class TSEnvNetworkModel {
  String envId;
  String name;
  String hostName;
  String interceptHost;
  bool check; // 是否选中
  String imageUrl;
  int badgeCount;

  TSEnvNetworkModel({
    this.envId,
    this.name,
    this.hostName,
    this.interceptHost,
    this.check = false,
    this.imageUrl =
        'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg',
    this.badgeCount,
  });
}

class TSEnvProxyModel {
  String proxyId;
  String name;
  bool check; // 是否选中

  TSEnvProxyModel({
    this.proxyId,
    this.name,
    this.check,
  });
}
