/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 18:30:47
 * @Description: 不同网络环境下包含各属性值的模型
 */

enum PackageType {
  develop1, // 开发环境1
  develop2, // 开发环境2
  preproduct, // 预生产环境
  product, // 正式环境
}

class TSEnvNetworkModel {
  String envId; // 网络环境id
  String name; // 网络环境名称
  String shortName; // 网络环境简称(用于一些地方视图长度不够的显示)
  String apiHost; // api
  String webHost; // h5
  String gameHost; // 小程序
  String monitorApiHost; // 埋点请求的 host
  String monitorDataHubId; // 埋点请求的公共参数秘钥
  bool check; // 是否选中
  String imageUrl;
  int badgeCount;

  TSEnvNetworkModel({
    required this.envId,
    required this.name,
    required this.shortName,
    required this.apiHost,
    required this.webHost,
    required this.gameHost,
    required this.monitorApiHost,
    required this.monitorDataHubId,
    this.check = false,
    this.imageUrl =
        'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg',
    this.badgeCount = 0,
  });

  PackageType get type {
    PackageType networkEnvType = TSEnvNetworkModel.getNetworkEnvType(envId);

    return networkEnvType;
  }

  static PackageType getNetworkEnvType(String envId) {
    Iterable<PackageType> values = [
      PackageType.develop1, // 开发环境1
      PackageType.develop2, // 开发环境2
      PackageType.preproduct, // 预生产环境
      PackageType.product, // 正式环境
    ];
    PackageType networkEnvType = values.firstWhere((type) {
      return type.toString().split('.').last == envId;
    }, orElse: () {
      return PackageType.product; // 正式环境
    });

    return networkEnvType;
  }
}
