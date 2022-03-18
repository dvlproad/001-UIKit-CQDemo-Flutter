class HistoryVersionBean {
  final String version;
  final String onlineTime;
  final String des;

  HistoryVersionBean({
    this.version,
    this.onlineTime,
    this.des,
  });

  factory HistoryVersionBean.fromJson(Map<String, dynamic> json) {
    return HistoryVersionBean(
      version: json['version'],
      onlineTime: json['online_time'],
      des: json['des'],
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
