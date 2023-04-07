/*
 * @Author: linzehua
 * @Date: 2023-03-20 16:35:00
 * @Description: 全局的im相关提示配置（用户发消息失败提示）
 */
class GlobalChatConfigBean {
  late String fromRemindMessage;

  GlobalChatConfigBean({
    required this.fromRemindMessage,
  });

  GlobalChatConfigBean.fromJson(Map<String, dynamic> json) {
    fromRemindMessage = json['fromRemindMessage'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if (fromRemindMessage != null) {
      _data['fromRemindMessage'] = fromRemindMessage;
    }

    return _data;
  }
}
