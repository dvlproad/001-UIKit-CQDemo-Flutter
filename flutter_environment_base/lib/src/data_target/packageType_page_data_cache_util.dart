/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 15:59:38
 * @Description: 平台的本地缓存
 */
import 'package:shared_preferences/shared_preferences.dart';
import './packageType_page_data_bean.dart';

class PackageTargetPageDataCacheUtil {
  // target
  static const String EnvPackageTargetIdKey = "EnvPackageTargetIdKey";
  // 删除选中的平台环境id
  Future removePackageTargetId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(EnvPackageTargetIdKey);
  }

  // 缓存选中的平台环境id
  static Future<bool> setPackageTargetId(String networkId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(EnvPackageTargetIdKey, networkId);
  }

  // 获取选中的平台环境id
  static Future<String?> getPackageTargetId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? networkId = prefs.getString(EnvPackageTargetIdKey);
    return networkId;
  }

  static Future<PackageTargetType> get packageTargetType async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? targetId = prefs.getString('cache_packageTargetString');

    PackageTargetType packageTargetType = PackageTargetType.formal;
    if (targetId != null) {
      packageTargetType = PackageTargetModel.getTargetTypeByString(targetId);
    }

    return packageTargetType;
  }

  static Future<bool> update(PackageTargetType packageTargetType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String packageTargetString = packageTargetType.toString().split('.').last;
    return prefs.setString(
      'cache_packageTargetString',
      packageTargetString,
    );
  }
}
