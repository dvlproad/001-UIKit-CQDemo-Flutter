/*
 * @Author: dvlproad
 * @Date: 2022-04-13 00:17:19
 * @LastEditTime: 2022-04-16 04:09:11
 * @LastEditors: dvlproad
 * @Description: 网络异常上报机器人
 */
import './robot_bean.dart';
import './api_error_bean.dart';
import './api_error_people_util.dart';
import '../log_robot/common_error_robot.dart';

class ApiErrorRobot {
  static List<RobotBean> apiErrorRobots;

  String url =
      'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=e3c3f7f1-5d03-42c5-8c4a-a3d25d7a8587'; // 单个人测试用的

  /// api 异常上报:企业微信
  static Future<bool> postApiError(
    String fullErrorApi,
    String errorMessage, {
    String serviceValidProxyIp, // 网络库当前服务的有效的代理ip地址(无代理或其地址无效时候，这里会传null)
    bool isCacheApiLog, // 是否是缓存请求的日志
  }) async {
    int count = apiErrorRobots?.length ?? 0;
    if (count == 0) {
      return Future.value(false);
    }

    List<String> robotUrls = [];
    for (var i = 0; i < count; i++) {
      RobotBean robotBean = apiErrorRobots[i];
      String specialString = robotBean.errorApiHost;
      if (fullErrorApi.contains(specialString)) {
        robotUrls = robotBean.pushToWechatRobots;
      }
    }

    if (robotUrls.length == 0) {
      String myRobotUrl =
          'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=e3c3f7f1-5d03-42c5-8c4a-a3d25d7a8587'; // 单个人测试用的
      robotUrls = [myRobotUrl];
    }

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

  /// api异常上报:企业微信
  static Future<bool> _postApiError(
    String robotUrl,
    String fullErrorApi,
    String errorMessage, {
    String serviceValidProxyIp, // 网络库当前服务的有效的代理ip地址(无代理或其地址无效时候，这里会传null)
  }) async {
    String customMessage = '';
    if (serviceValidProxyIp != null && serviceValidProxyIp.isNotEmpty) {
      customMessage += '(附:该使用者当前有添加$serviceValidProxyIp代理)\n';
    }
    customMessage += 'api发现如下错误,请相应负责人尽快处理:';
    customMessage += '\n$errorMessage';

    ApiErrorDesBean apiErrorDesBean =
        ApiErrorPeopleUtil.apiErrorMentionedBeans(fullErrorApi);
    customMessage += '\n${apiErrorDesBean.des}';
    List<String> mentionedList = apiErrorDesBean.allPids();

    String title = fullErrorApi;
    CommonErrorRobot.postError(robotUrl, title, customMessage, mentionedList);
  }
}
