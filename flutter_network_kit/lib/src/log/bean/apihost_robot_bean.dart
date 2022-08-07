/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-07 14:48:18
 * @Description: 区分不同 api host 上报到不同机器人的类
 */
class ApiHostRobotBean {
  String errorApiHost;
  List<String> pushToWechatRobots;

  ApiHostRobotBean({
    required this.errorApiHost,
    required this.pushToWechatRobots,
  });
}
