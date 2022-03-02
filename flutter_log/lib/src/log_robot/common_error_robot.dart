import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';

class CommonErrorRobot {
  static String packageDescribe = ''; // 包的描述(生产、测试、开发包)

  /// 通用异常上报:企业微信
  static Future<bool> postError(
    String robotUrl,
    String
        title, // 可为null，不是null时候，只是为了对 customMessage 起一个强调作用。(一般此title肯定在customMessage有包含到)
    String customMessage,
    List<String> mentionedList,
  ) async {
    if (robotUrl == null) {
      robotUrl =
          'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=e3c3f7f1-5d03-42c5-8c4a-a3d25d7a8587'; // 单个人测试用的
    }

    String platformName = "";
    String appKey = "";
    if (Platform.isIOS) {
      platformName = 'iOS';
    } else if (Platform.isAndroid) {
      platformName = 'Android';
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appBundleID = packageInfo.packageName;
    String appVersion = packageInfo.version;
    String buildBuildVersion = packageInfo.buildNumber;

    String fullMessage = '';
    // 标题 title（可为null，不是null时候，只是为了对错误内容 customMessage 起强调中庸）
    if (title != null && title.isNotEmpty) {
      fullMessage += '$title\n';
    }
    // 包、平台及版本等先关信息
    String packageDescribe =
        CommonErrorRobot.packageDescribe; // 包的描述(生产、测试、开发包)
    String fullPackageDescribe =
        '【${packageDescribe}_${platformName}_V$appVersion($buildBuildVersion)】';
    fullMessage += '$fullPackageDescribe\n';
    // 错误内容 customMessage
    fullMessage += '$customMessage';

    Map<String, dynamic> customParams = {
      "msgtype": "text", // 消息类型，此时固定为text
      "text": {
        "content": fullMessage, // 文本内容，最长不超过2048个字节，必须是utf8编码
        "mentioned_list": mentionedList,
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
