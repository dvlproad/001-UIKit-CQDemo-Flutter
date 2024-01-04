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
  String region;
  String bucket_image;
  String bucket_other;
  String cosFilePrefix;
  String cosFileUrlPrefix_image;
  String cosFileUrlPrefix_video;
  String cosFileUrlPrefix_audio;

  CosParamModel({
    required this.region,
    required this.bucket_image,
    required this.bucket_other,
    required this.cosFilePrefix,
    required this.cosFileUrlPrefix_image,
    required this.cosFileUrlPrefix_video,
    required this.cosFileUrlPrefix_audio,
  });

  static CosParamModel get product {
    return CosParamModel(
      region: 'ap-shanghai',
      bucket_image: 'prod-xhw-image-1302324914',
      bucket_other: 'prod-xhw-media-1302324914',
      cosFilePrefix: 'wish',
      cosFileUrlPrefix_image: 'https://images.xxx.com/',
      cosFileUrlPrefix_video: 'https://media.xxx.com/',
      cosFileUrlPrefix_audio: 'https://media.xxx.com/',
    );
  }

  static String _test_bucket_image = 'xxx-image-1302324914';
  static String _test_bucket_other = 'xxx-media-1302324914';
  static CosParamModel get preproduct {
    return product;
  }

  static CosParamModel get test1 {
    return CosParamModel(
      region: 'ap-guangzhou',
      bucket_image: _test_bucket_image,
      bucket_other: _test_bucket_other,
      cosFilePrefix: 'wish_test',
      cosFileUrlPrefix_image: 'http://image.xxx.com/',
      cosFileUrlPrefix_video: 'http://tape.xxx.com/',
      cosFileUrlPrefix_audio: 'http://tape.xxx.com/',
    );
  }

  static CosParamModel get dev {
    return CosParamModel(
      region: 'ap-guangzhou',
      bucket_image: _test_bucket_image,
      bucket_other: _test_bucket_other,
      cosFilePrefix: 'wish_dev',
      cosFileUrlPrefix_image: 'http://image.xxx.com/',
      cosFileUrlPrefix_video: 'http://tape.xxx.com/',
      cosFileUrlPrefix_audio: 'http://tape.xxx.com/',
    );
  }

  static CosParamModel get other {
    return dev;
  }
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
      cosParamModel: CosParamModel.other,
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
