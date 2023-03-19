/*
 * @Author: dvlproad
 * @Date: 2022-07-25 19:38:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-30 13:37:45
 * @Description: 全局的网络配置信息(强制哪些code不弹出toast，当后台频繁发生开小差情况，可能需要对500问题不toast)
 */
class GlobalNetworkConfigBean {
  List<int>? noToastForCodes; // 这些code强制不toast

  GlobalNetworkConfigBean({
    this.noToastForCodes,
  });

  GlobalNetworkConfigBean.fromJson(Map<String, dynamic> json) {
    noToastForCodes = json['noToastForCodes'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if (noToastForCodes != null) {
      _data['noToastForCodes'] = noToastForCodes;
    }

    return _data;
  }
}
