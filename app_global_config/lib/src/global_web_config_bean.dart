/*
 * @Author: linzehua
 * @Date: 2023-02-20 14:06:00
 * @Description: 全局的网页配置（挂起后x分钟后，唤起app时reload）
 */
class GlobalWebConfigBean {
  int? reloadInterval;

  GlobalWebConfigBean({
    this.reloadInterval,
  });

  static GlobalWebConfigBean fromJson(Map<String, dynamic> json) {
    int reloadInterval = json['reloadInterval'];

    return GlobalWebConfigBean(
      reloadInterval: reloadInterval,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if (reloadInterval != null) {
      _data['reloadInterval'] = reloadInterval;
    }

    return _data;
  }
}
