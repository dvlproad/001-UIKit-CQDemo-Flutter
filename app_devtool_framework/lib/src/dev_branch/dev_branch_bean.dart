class DevBranchBean {
  final String name;
  final String createTime;
  final String des;

  DevBranchBean({
    this.name,
    this.createTime,
    this.des,
  });

  factory DevBranchBean.fromJson(Map<String, dynamic> json) {
    return DevBranchBean(
      name: json['name'],
      createTime: json['create_time'] ?? '',
      des: json['des'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['create_time'] = createTime;
    _data['des'] = des;
    return _data;
  }
}
