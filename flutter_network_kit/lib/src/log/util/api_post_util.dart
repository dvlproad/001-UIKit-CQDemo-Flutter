/*
 * @Author: dvlproad
 * @Date: 2022-04-13 00:17:19
 * @LastEditTime: 2023-03-23 18:08:54
 * @LastEditors: dvlproad
 * @Description: 网络异常上报机器人
 */

import '../bean/apihost_robot_bean.dart';

class ApiPostUtil {
  static late List<ApiHostRobotBean> apiErrorRobots;

  static String getRobotUrlByApiHost(String apiHost) {
    List<String> robotUrls = getRobotUrlsByApiHost(apiHost);
    if (robotUrls.isNotEmpty) {
      return robotUrls.first;
    } else {
      return 'unknow robotUrl';
    }
  }

  static List<String> getRobotUrlsByApiHost(String apiHost) {
    if (apiHost.endsWith('/') == false) {
      apiHost += '/'; // 避免 ApiHostRobotBean 中的 host 尾部有，这里没有，导致等下匹配不上
    }

    List<String> robotUrls = [];
    int count = apiErrorRobots.length;
    for (var i = 0; i < count; i++) {
      ApiHostRobotBean robotBean = apiErrorRobots[i];
      String specialString = robotBean.errorApiHost;
      if (apiHost.contains(specialString)) {
        robotUrls = robotBean.pushToWechatRobots;
      }
    }

    return robotUrls;
  }
}
