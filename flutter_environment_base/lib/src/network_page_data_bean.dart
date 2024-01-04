/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-11-16 12:03:01
 * @Description: 不同网络环境下包含各属性值的模型
 */

enum PackageNetworkType {
  develop1, // 开发环境1
  develop2, // 开发环境2
  test1, // 测试环境1
  test2, // 测试环境2
  preproduct, // 预生产环境
  product, // 正式环境
}

/// cos 上传的参数
class CosParamModel {
  static const String kRegion = String.fromEnvironment('region');
  static const String kRegion_selfie = String.fromEnvironment('region_selfie');
  static const String kBucket_image = String.fromEnvironment('bucket_image');
  static const String kBucket_selfie_image = String.fromEnvironment('bucket_selfie_image');
  static const String kBucket_other = String.fromEnvironment('bucket_other');
  static const String kBucket_static = String.fromEnvironment('bucket_static');
  static const String kCosFilePrefix = String.fromEnvironment('cosFilePrefix');
  static const String kCosFileUrlPrefix_image = String.fromEnvironment('cosFileUrlPrefix_image');
  static const String kCosFileUrlPrefix_video = String.fromEnvironment('cosFileUrlPrefix_video');
  static const String kCosFileUrlPrefix_audio = String.fromEnvironment('cosFileUrlPrefix_audio');
  static const String kCosFileUrlPrefix_static = String.fromEnvironment('cosFileUrlPrefix_static');
  static const String kCosFileUrlPrefix_selfie_image = String.fromEnvironment('cosFileUrlPrefix_selfie_image');

  

  String region = kRegion;
  String region_selfie = kRegion_selfie;
  String bucket_image = kBucket_image;
  String bucket_selfie_image = kBucket_selfie_image;
  String bucket_other = kBucket_other;
  String bucket_static = kBucket_static;
  String cosFilePrefix = kCosFilePrefix;
  String cosFileUrlPrefix_image = kCosFileUrlPrefix_image;
  String cosFileUrlPrefix_video = kCosFileUrlPrefix_video;
  String cosFileUrlPrefix_audio = kCosFileUrlPrefix_audio;
  String cosFileUrlPrefix_static = kCosFileUrlPrefix_static;
  String cosFileUrlPrefix_selfie_image = kCosFileUrlPrefix_selfie_image;

  
}

class TSEnvNetworkModel {
  PackageNetworkType type; // 网络环境类型
  String des; // 是什么包
  String envId; // 网络环境id
  String name; // 网络环境名称
  String shortName; // 网络环境简称(用于一些地方视图长度不够的显示)
  String apiHost; // api
  String socketHost;
  String webHost; // h5
  String gameHost; // 小程序
  String monitorApiHost; // 埋点请求的 host
  String monitorDataHubId; // 埋点请求的公共参数秘钥
  CosParamModel cosParamModel;
  bool check; // 是否选中
  String imageUrl;
  int badgeCount;

  TSEnvNetworkModel({
    required this.type,
    required this.des,
    required this.envId,
    required this.name,
    required this.shortName,
    required this.apiHost,
    required this.socketHost,
    required this.webHost,
    required this.gameHost,
    required this.monitorApiHost,
    required this.monitorDataHubId,
    required this.cosParamModel,
    this.check = false,
    this.imageUrl =
        'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg',
    this.badgeCount = 0,
  });

  static TSEnvNetworkModel none() {
    return TSEnvNetworkModel(
      type: PackageNetworkType.product,
      des: '未知包',
      envId: '',
      name: '',
      shortName: '',
      apiHost: '',
      socketHost: '',
      webHost: '',
      gameHost: '',
      monitorApiHost: '',
      monitorDataHubId: '',
      cosParamModel: CosParamModel(),
    );
  }

  static PackageNetworkType getNetworkTypeByString(String networkTypeString) {
    Iterable<PackageNetworkType> values = [
      PackageNetworkType.develop1, // 开发环境1
      PackageNetworkType.develop2, // 开发环境2
      PackageNetworkType.test1, // 测试环境1
      PackageNetworkType.test2, // 测试环境1
      PackageNetworkType.preproduct, // 预生产环境
      PackageNetworkType.product, // 正式环境
    ];
    PackageNetworkType networkEnvType = values.firstWhere((type) {
      return type.toString().split('.').last == networkTypeString;
    }, orElse: () {
      return PackageNetworkType.product; // 正式环境
    });

    return networkEnvType;
  }
}
