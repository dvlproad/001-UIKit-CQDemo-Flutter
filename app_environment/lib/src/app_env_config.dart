/*
 * @Author: dvlproad
 * @Date: 2023-12-07 10:39:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-04 17:27:56
 * @Description: 
 */
import '../app_environment.dart';

class AppEnvConfig {
  static const String apiHost = String.fromEnvironment('API_HOST');
  static const String networkType = String.fromEnvironment('NETWORK_TYPE');
  static const String targetType = String.fromEnvironment('TARGET_TYPE');
  static const String des = String.fromEnvironment('DES');
  static const String envId = String.fromEnvironment('ENV_ID');
  static const String shortName = String.fromEnvironment('SHORT_NAME');
  static const String name = String.fromEnvironment('NAME');
  static const String socketHost = String.fromEnvironment('SOCKET_HOST');
  static const String webHost = String.fromEnvironment('WEB_HOST');
  static const String gameHost = String.fromEnvironment('GAME_HOST');
  static const String monitorApiHost =
      String.fromEnvironment('MONITOR_API_HOST');
  static const String monitorDataHubId =
      String.fromEnvironment('MONITOR_DATA_HUB_ID');
  static const String check = String.fromEnvironment('CHECK');
  static const String imageUrl = String.fromEnvironment('IMAGE_URL');
  static const String appKey = String.fromEnvironment('APP_KEY');
  static const String appVersion = String.fromEnvironment('APP_VERSION');
  static const String buildNumber = String.fromEnvironment('BUILD_NUMBER');

  static PackageNetworkType get envType {
    for (PackageNetworkType t in PackageNetworkType.values) {
      if (t.name == networkType) {
        return t;
      }
    }
    return PackageNetworkType.test1;
  }

  static PackageTargetType get packageTargetType {
    for (PackageTargetType t in PackageTargetType.values) {
      if (t.name == targetType) {
        return t;
      }
    }
    return PackageTargetType.dev;
  }

  static CosParamModel get cosParamModel {
    return CosParamModel();
  }
}
