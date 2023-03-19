/*
 * @Author: linzehua
 * @Date: 2023-02-20 14:06:00
 * @Description: 全局的网页配置（挂起后x分钟后，唤起app时reload）
 */
class GlobalWebConfigBean {
  late int reloadInterval;

  GlobalWebConfigBean({
    required this.reloadInterval,
  });

  GlobalWebConfigBean.fromJson(Map<String, dynamic> json) {
    reloadInterval = json['reloadInterval'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if (reloadInterval != null) {
      _data['appCode'] = reloadInterval;
    }

    return _data;
  }
}
