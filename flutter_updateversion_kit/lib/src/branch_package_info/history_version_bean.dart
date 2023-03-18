/*
 * @Author: dvlproad
 * @Date: 2022-09-07 10:53:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-12-16 18:35:15
 * @Description: 
 */
import './dev_branch_bean.dart';

class HistoryVersionBean {
  final String version;
  final String onlineTime;
  final String des;
  final List<DevBranchBean>? onlineBrances;

  HistoryVersionBean({
    required this.version,
    required this.onlineTime,
    required this.des,
    this.onlineBrances,
  });

  String getDescription({
    required bool showBranchName,
  }) {
    if (onlineBrances == null) {
      return des;
    }

    return DevBranchBeanUtil.getDescription(
      branchBeans: onlineBrances!,
      showBranchName: showBranchName,
    );
  }

  factory HistoryVersionBean.fromJson(Map<String, dynamic> json) {
    List<DevBranchBean> onlineBrances = [];
    if (json['online_brances'] != null) {
      List onlineBranceMaps = json['online_brances'];

      for (var onlineBranceMap in onlineBranceMaps) {
        DevBranchBean onlineBrance = DevBranchBean.fromJson(onlineBranceMap);
        onlineBrances.add(onlineBrance);
      }
    }

    return HistoryVersionBean(
      version: json['version'] ?? '',
      onlineTime: json['online_time'] ?? '',
      des: json['des'] ?? '',
      onlineBrances: onlineBrances,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['version'] = version;
    _data['online_time'] = onlineTime;
    _data['des'] = des;

    if (onlineBrances != null) {
      List<Map<String, dynamic>> onlineBranceMaps = [];
      for (DevBranchBean onlineBranceModel in onlineBrances!) {
        Map<String, dynamic> onlineBranceMap = onlineBranceModel.toJson();
        onlineBranceMaps.add(onlineBranceMap);
      }

      _data['online_brances'] = onlineBrances;
    }

    return _data;
  }
}
