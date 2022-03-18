class TSEnvNetworkModel {
  String envId; // 网络环境id
  String name; // 网络环境名称
  String shortName; // 网络环境简称(用于一些地方视图长度不够的显示)
  String apiHost; // api
  String webHost; // h5
  String gameHost; // 小程序
  bool check; // 是否选中
  String imageUrl;
  int badgeCount;

  TSEnvNetworkModel({
    this.envId,
    this.name,
    this.shortName,
    this.apiHost,
    this.webHost,
    this.gameHost,
    this.check = false,
    this.imageUrl =
        'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg',
    this.badgeCount,
  });
}
