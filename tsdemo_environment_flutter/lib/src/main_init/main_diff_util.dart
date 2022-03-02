import '../main_init/environment_datas_util.dart';

enum PackageType {
  develop1, // 开发环境1
  develop2, // 开发环境2
  preproduct, // 预生产环境
  product, // 正式环境
}

class DiffPackageBean {
  PackageType packageType;
  String des;
  String bestNetworkDes;
  String downloadUrl;
  String pygerAppKeyAndroid;
  String pygerAppKeyIOS;

  DiffPackageBean({
    this.packageType,
    this.des,
    this.bestNetworkDes,
    this.downloadUrl,
    this.pygerAppKeyAndroid,
    this.pygerAppKeyIOS,
  });
}

class MainDiffUtil {
  static PackageType packageType;
  static DiffPackageBean diffPackageBean() {
    return diffPackageBeanByType(packageType);
  }

  static DiffPackageBean _diffPackageBean_dev = DiffPackageBean(
    packageType: PackageType.develop1,
    des: '开发包',
    bestNetworkDes: TSEnvironmentDataUtil.networkModel_dev1.name,
    downloadUrl: 'https://www.pgyer.com/kKTt',
    pygerAppKeyAndroid: '0ff51c2519a23078fac1f8e8ea1bbdef',
    pygerAppKeyIOS: '3aa46e5f75c648922bb2450ac2da7909',
  );

  static DiffPackageBean _diffPackageBean_preproduct = DiffPackageBean(
    packageType: PackageType.preproduct,
    des: '测试包',
    bestNetworkDes: TSEnvironmentDataUtil.networkModel_preProduct.name,
    downloadUrl: 'https://www.pgyer.com/Jzqc',
    pygerAppKeyAndroid: '251b74df1a3bd5fe7395fba154938aa1',
    pygerAppKeyIOS: '0b534e9b77ec8708318a99b6061749de',
  );

  static DiffPackageBean _diffPackageBean_product = DiffPackageBean(
    packageType: PackageType.product,
    des: '生产包',
    bestNetworkDes: TSEnvironmentDataUtil.networkModel_product.name,
    downloadUrl: 'https://www.pgyer.com/app_bj',
    pygerAppKeyAndroid: '70fda79d944eeb6797961db785f8d2b8',
    pygerAppKeyIOS: '5f84348a16bef907dc0ea977deb249ab',
  );

  static DiffPackageBean diffPackageBeanByType(PackageType _platformState) {
    if (_platformState == PackageType.develop1) {
      return _diffPackageBean_dev;
    } else if (_platformState == PackageType.develop2) {
      return _diffPackageBean_dev;
    } else if (_platformState == PackageType.preproduct) {
      return _diffPackageBean_preproduct;
    } else {
      return _diffPackageBean_product;
    }
  }
}
