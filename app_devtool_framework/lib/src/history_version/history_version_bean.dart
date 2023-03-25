/*
 * @Author: dvlproad
 * @Date: 2022-09-07 10:53:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 13:15:05
 * @Description: 
 */
class HistoryVersionBean {
  final String version;
  final String onlineTime;
  final String des;

  HistoryVersionBean({
    required this.version,
    required this.onlineTime,
    required this.des,
  });

  factory HistoryVersionBean.fromJson(Map<String, dynamic> json) {
    return HistoryVersionBean(
      version: json['version'] ?? '',
      onlineTime: json['online_time'] ?? '',
      des: json['des'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['version'] = version;
    _data['online_time'] = onlineTime;
    _data['des'] = des;
    return _data;
  }
}
