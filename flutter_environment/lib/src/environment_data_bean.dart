class TSEnvironmentModel {
  String networkTitle;
  List<TSEnvNetworkModel> networkModels;

  String proxyTitle;
  List<TSEnvProxyModel> proxyModels;
}

class TSEnvNetworkModel {
  String envId; // 网络环境id
  String name; // 网络环境名称
  String apiHost; // api
  String webHost; // h5
  String gameHost; // 小程序
  bool check; // 是否选中
  String imageUrl;
  int badgeCount;

  TSEnvNetworkModel({
    this.envId,
    this.name,
    this.apiHost,
    this.webHost,
    this.gameHost,
    this.check = false,
    this.imageUrl =
        'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg',
    this.badgeCount,
  });
}

class TSEnvProxyModel {
  String proxyId;
  String name; // 网络代理的名称
  String proxyIp; // 网络代理的 ip
  String useDirection; // 使用说明
  bool check; // 是否选中

  TSEnvProxyModel({
    this.proxyId,
    this.name,
    this.proxyIp,
    this.useDirection,
    this.check,
  });

  /// 没有使用代理
  static String noneProxykId = "proxyId_none";
  static String noneProxykIp = "none";
  static TSEnvProxyModel noneProxyModel() {
    TSEnvProxyModel dataModel = TSEnvProxyModel();
    dataModel.proxyId = TSEnvProxyModel.noneProxykId;
    dataModel.name = "无代理";
    dataModel.proxyIp = TSEnvProxyModel.noneProxykIp; // 使用固定值，不能修改

    return dataModel;
  }

  // json 与 model 转换
  factory TSEnvProxyModel.fromJson(Map<String, dynamic> json) {
    return TSEnvProxyModel(
      proxyId: json['proxyId'],
      name: json['name'],
      proxyIp: json['proxyIp'],
      useDirection: json['useDirection'],
      check: json['check'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "proxyId": this.proxyId,
      "name": this.name,
      "proxyIp": this.proxyIp,
      "useDirection": this.useDirection,
      "check": this.check,
    };
  }
}
