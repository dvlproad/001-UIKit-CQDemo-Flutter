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
    List<String> robotUrls = _getRobotUrlsByApiHost(apiHost);
    if (robotUrls.isNotEmpty) {
      return robotUrls.first;
    } else {
      return 'unknow robotUrl';
    }
  }

  static List<String> _getRobotUrlsByApiHost(String apiHost) {
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

  /// api 异常上报:企业微信
  static Future<bool> postApiError({
    required ApiMessageModel apiMessageModel, // api信息
    // required String apiHost, // 需要通过其host确认应该上报到哪个企业微信(不一定是http开头,有可能本地模拟)
    required List<String> robotUrls,
    required String apiPath, // 需要通过其path判断接口负责人
    String? serviceValidProxyIp, // 网络库当前服务的有效的代理ip地址(无代理或其地址无效时候，这里会传null)
    required NetworkType connectionStatus,
  }) async {
    int count = apiErrorRobots.length;
    if (count == 0) {
      throw Exception("Error:请先设置上报机器人的地址");
      return false;
    }

    // List<String> robotUrls = _getRobotUrlsByApiHost(apiHost);

    if (robotUrls.length == 0) {
      String myRobotKey = CommonErrorRobot.myRobotKey; // 单个人测试用的
      robotUrls = [myRobotKey];
    }

    bool isPostSuccess = true;
    for (String robotKey in robotUrls) {
      if (robotKey.isEmpty) {
        continue;
      }
      isPostSuccess = await _postApiError(
        robotKey,
        apiPath: apiPath,
        apiMessageModel: apiMessageModel,
        serviceValidProxyIp: serviceValidProxyIp,
        connectionStatus: connectionStatus,
      );
    }

    return isPostSuccess;
  }

  /// api异常上报:企业微信
  static Future<bool> _postApiError(
    String robotKey, {
    required String apiPath, // 需要通过其path判断接口负责人
    required ApiMessageModel apiMessageModel, // api信息
    String? serviceValidProxyIp, // 网络库当前服务的有效的代理ip地址(无代理或其地址无效时候，这里会传null)
    required NetworkType connectionStatus,
  }) async {
    // 日志等级(决定上报方式:超时的请求错误上报使用文件折叠,其他用纯文本铺开)
    ApiLogLevel apiLogLevel = apiMessageModel.apiLogLevel;
    //要上报的必须是完整信息，不能是日志列表里的简略信息
    String apiDetailMessage = apiMessageModel.detailMessage;

    String customMessage = '';
    if (serviceValidProxyIp != null && serviceValidProxyIp.isNotEmpty) {
      customMessage += '(附:该使用者当前有添加$serviceValidProxyIp代理)\n';
    }
    customMessage += 'connectionStatus:${connectionStatus.toString()}\n';
    customMessage += 'api发现如下错误,请相应负责人尽快处理:';
    customMessage += '\n$apiDetailMessage';

    ApiErrorDesBean apiErrorDesBean =
        ApiDescirbeUtil.apiDescriptionBeanByApiPath(apiPath);
    customMessage += '\n${apiErrorDesBean.des}';
    List<String> mentionedList = apiErrorDesBean.allPids();

    String title = '';
    RobotPostType postType;
    if (apiLogLevel == ApiLogLevel.error_other) {
      postType = RobotPostType.text;
    } else if (apiLogLevel == ApiLogLevel.error_timeout) {
      postType = RobotPostType.file;

      if (apiMessageModel.errorType != null) {
        String errorTypeString =
            apiMessageModel.errorType.toString().split('.').last;
        title += "[$errorTypeString]";
      }
    } else if (apiLogLevel == ApiLogLevel.response_success ||
        apiLogLevel == ApiLogLevel.response_warning) {
      postType = RobotPostType.file;
      // title += "statusCode:${apiMessageModel.statusCode}_businessCode:${apiMessageModel.businessCode}";
      title += "[code:${apiMessageModel.businessCode}]";
    } else {
      postType = RobotPostType.file;
    }
    title += "$apiPath";
    return CommonErrorRobot.post(
      robotKey: robotKey,
      postType: postType,
      title: title,
      customMessage: customMessage,
      mentionedList: mentionedList,
    );
  }
}
