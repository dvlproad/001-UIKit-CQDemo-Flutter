/*
 * @Author: dvlproad
 * @Date: 2022-04-13 00:17:19
 * @LastEditTime: 2022-07-28 18:46:49
 * @LastEditors: dvlproad
 * @Description: 网络异常上报机器人
 */
import 'package:meta/meta.dart';
import 'package:flutter_log/flutter_log.dart'
    show CommonErrorRobot, RobotPostType;
import 'package:flutter_network/flutter_network.dart' show ApiLogLevel;
import 'package:flutter_network/src/interceptor_log/util/net_options_log_util.dart';
import 'package:flutter_network/src/interceptor_log/util/net_options_log_bean.dart';

import '../bean/api_describe_bean.dart';
import '../bean/api_user_bean.dart';
import './api_describe_util.dart';

import '../bean/apihost_robot_bean.dart';
import '../../networkStatus/network_status_manager.dart';

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
