/*
 * @Author: dvlproad
 * @Date: 2022-09-07 10:53:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 13:16:30
 * @Description: 
 */
class DevBranchBean {
  final String name;
  final String createTime;
  final String des;

  DevBranchBean({
    required this.name,
    required this.createTime,
    required this.des,
  });

  factory DevBranchBean.fromJson(Map<String, dynamic> json) {
    return DevBranchBean(
      name: json['name'] ?? '',
      createTime: json['create_time'] ?? '',
      des: json['des'] ?? '',
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
