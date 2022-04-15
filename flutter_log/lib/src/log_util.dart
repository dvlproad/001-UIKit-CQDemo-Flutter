/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-16 04:41:45
 * @Description: 日志类
 */
import './log/dev_log_util.dart';
import './print_console_log_util.dart';
import './apilog/api_error_robot.dart';

import './log_robot/common_error_robot.dart';
import './log_robot/compile_mode_util.dart';

class LogUtil {
  // 局部变量
  static bool Function(LogLevel logLevel, {Map extraLogInfo})
      _printToConsoleBlock;
  static bool Function(LogLevel logLevel, {Map extraLogInfo}) _showToPageBlock;
  static bool Function(LogLevel logLevel, {Map extraLogInfo})
      _postToWechatBlock;

  static void init({
    String packageDescribe, // 包的描述(生产、测试、开发包)
    String Function() userDescribeBlock, // 当前使用该包的用户信息
    bool Function(LogLevel logLevel, {Map extraLogInfo}) printToConsoleBlock,
    bool Function(LogLevel logLevel, {Map extraLogInfo}) showToPageBlock,
    bool Function(LogLevel logLevel, {Map extraLogInfo}) postToWechatBlock,
    String tag,
  }) {
    CommonErrorRobot.init(
      packageDescribe: packageDescribe,
      userDescribeBlock: userDescribeBlock,
    );

    _printToConsoleBlock = printToConsoleBlock;
    _showToPageBlock = showToPageBlock;
    _postToWechatBlock = postToWechatBlock;
    tag = tag;
  }

  // String serviceValidProxyIp; // 网络库当前服务的有效的代理ip地址(无代理或其地址无效时候，这里会传null)
  // 是否打印到调试控制台
  static bool shouldShowToConsole(LogLevel logLevel, Map extraLogInfo) {
    bool _shouldShowToConsole = true;
    if (_printToConsoleBlock != null) {
      _shouldShowToConsole =
          _printToConsoleBlock(logLevel, extraLogInfo: extraLogInfo);
    }
    return _shouldShowToConsole;
  }

  // 是否显示到页面上
  static bool shouldShowToPage(LogLevel logLevel, Map extraLogInfo) {
    bool _shouldShowToPage = true;
    if (_showToPageBlock != null) {
      _shouldShowToPage =
          _showToPageBlock(logLevel, extraLogInfo: extraLogInfo);
    }
    return _shouldShowToPage;
  }

  // 是否上报发送到企业微信上
  static bool shouldPostToWechat(LogLevel logLevel, Map extraLogInfo) {
    bool _shouldPostToWechat = true;
    if (_shouldPostToWechat != null) {
      _shouldPostToWechat =
          _postToWechatBlock(logLevel, extraLogInfo: extraLogInfo);
    }
    return _shouldPostToWechat;
  }

  static String desForLogLevel(LogLevel logLevel) {
    String levelString = logLevel.toString().split('.').last;
    return '  $levelString  ';
  }

  /// 通用异常上报:企业微信
  static Future<bool> postError(
    String robotUrl,
    String
        title, // 可为null，不是null时候，只是为了对 customMessage 起一个强调作用。(一般此title肯定在customMessage有包含到)
    String customMessage,
    List<String> mentionedList,
  ) async {
    CommonErrorRobot.postError(robotUrl, title, customMessage, mentionedList);
  }
}
