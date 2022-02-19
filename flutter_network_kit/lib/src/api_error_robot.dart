import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import './robot_bean.dart';
export './robot_bean.dart';

class ApiErrorRobot {
  static List<RobotBean> apiErrorRobots;

  String url =
      'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=e3c3f7f1-5d03-42c5-8c4a-a3d25d7a8587'; // 单个人测试用的

  /// api 异常上报:企业微信
  static Future<bool> postApiError(
    String fullErrorApi,
    String errorMessage, {
    String serviceValidProxyIp, // 网络库当前服务的有效的代理ip地址(无代理或其地址无效时候，这里会传null)
  }) async {
    int count = apiErrorRobots.length;
    List<String> robotUrls = [];
    for (var i = 0; i < count; i++) {
      RobotBean robotBean = apiErrorRobots[i];
      String specialString = robotBean.errorApiHost;
      if (fullErrorApi.contains(specialString)) {
        robotUrls = robotBean.pushToWechatRobots;
      }
    }

    if (robotUrls.length > 0) {
      for (String robotUrl in robotUrls) {
        if (robotUrl.isEmpty) {
          continue;
        }
        _postApiError(
          robotUrl,
          fullErrorApi,
          errorMessage,
          serviceValidProxyIp: serviceValidProxyIp,
        );
      }
    }
  }

  /// api 异常上报:企业微信
  static Future<bool> _postApiError(
    String robotUrl,
    String fullErrorApi,
    String errorMessage, {
    String serviceValidProxyIp, // 网络库当前服务的有效的代理ip地址(无代理或其地址无效时候，这里会传null)
  }) async {
    String platformName = "";
    String appKey = "";
    if (Platform.isIOS) {
      platformName = 'ios';
    } else if (Platform.isAndroid) {
      platformName = 'android';
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appBundleID = packageInfo.packageName;
    String appVersion = packageInfo.version;
    String buildBuildVersion = packageInfo.buildNumber;

    String fullErrorMessage = '';
    fullErrorMessage +=
        '$fullErrorApi\n在版本$appVersion($buildBuildVersion)上发现如下错误,请相应负责人尽快处理:\n';
    if (serviceValidProxyIp != null && serviceValidProxyIp.isNotEmpty) {
      fullErrorMessage += '(附:该使用者当前有添加$serviceValidProxyIp代理)\n';
    }
    fullErrorMessage += '$errorMessage';

    Map<String, dynamic> customParams = {
      "msgtype": "text", // 消息类型，此时固定为text
      "text": {
        "content": fullErrorMessage, // 文本内容，最长不超过2048个字节，必须是utf8编码
        // "mentioned_list": appVersion,
        // "mentioned_mobile_list": buildBuildVersion,
      }
    };
    Options options = Options(
      contentType: "application/json",
    );

    CancelToken cancelToken = CancelToken();

    Dio dio = Dio();

    Response response = await dio.post(
      robotUrl,
      data: customParams,
      options: options,
      cancelToken: cancelToken,
    );

    Map responseObject = response.data;
    if (responseObject['errcode'] != 0) {
      String errorMessage = responseObject['errmsg'];
      print('企业微信请求失败:errorMessage=$errorMessage');
      return false;
    }

    return true;
  }
}
