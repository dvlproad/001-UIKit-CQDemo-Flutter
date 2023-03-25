/*
 * @Author: dvlproad
 * @Date: 2022-11-16 10:51:15
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-12-16 18:29:38
 * @Description: 
 */

class DevBranchBeanUtil {
  /// 获取指定分支数组的描述信息
  static String getDescription({
    required List<DevBranchBean> branchBeans,
    required bool showBranchName,
  }) {
    String branchString = '';
    for (var i = 0; i < branchBeans.length; i++) {
      DevBranchBean onlineBranceModel = branchBeans[i];
      if (i > 0) {
        branchString += '\n';
      }
      branchString += '${i + 1}.';
      if (showBranchName == true) {
        branchString += '${onlineBranceModel.name}:';
      }
      branchString += onlineBranceModel.description;
    }
    return branchString;
  }
}

class DevBranchBean {
  final String name;
  final String createTime;
  final String? submitTestTime;
  final String? passTestTime;
  final String? mergerPreTime;
  final String? des;
  final List<DevBranchOutlinesBean> outlinesBeans;

  DevBranchBean({
    required this.name,
    required this.createTime,
    this.submitTestTime,
    this.passTestTime,
    this.mergerPreTime,
    this.des,
    required this.outlinesBeans,
  });

  String get description {
    String _description = '';
    if (des == "详见outlines") {
      int count = outlinesBeans.length;
      List<String> outlineIndexStringArray = [
        "①",
        "②",
        "③",
        "④",
        "⑤",
        "⑥",
        "⑦",
        "⑧",
        "⑨",
        "⑩"
      ];
      for (var i = 0; i < count; i++) {
        DevBranchOutlinesBean outlineBean = outlinesBeans[i];
        late String outlineIndexString;
        if (i < outlineIndexStringArray.length) {
          outlineIndexString = outlineIndexStringArray[i];
        } else {
          outlineIndexString = "⑩";
        }

        if (i > 0) {
          _description += "\n";
        }
        String iOutlineLog = "$outlineIndexString${outlineBean.title}";

        _description += iOutlineLog;
      }
    } else {
      _description = des ?? '未标明';
    }

    return _description;
  }

  factory DevBranchBean.fromJson(Map<String, dynamic> json) {
    List<DevBranchOutlinesBean> outlinesBeans = [];
    if (json["outlines"] != null) {
      for (var outlineMap in json["outlines"]) {
        outlinesBeans.add(DevBranchOutlinesBean.fromJson(outlineMap));
      }
    }
    return DevBranchBean(
      name: json['name'] ?? '',
      createTime: json['create_time'] ?? '',
      submitTestTime: _timeString(json, 'submit_test_time'),
      passTestTime: _timeString(json, 'pass_test_time'),
      mergerPreTime: _timeString(json, 'merger_pre_time'),
      des: json['des'],
      outlinesBeans: outlinesBeans,
    );
  }

  static String? _timeString(Map<String, dynamic> json, String timeKey) {
    if (json[timeKey] == null || json[timeKey] == "null") {
      return null;
    } else {
      return json[timeKey];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['create_time'] = createTime;
    if (submitTestTime != null) {
      _data['submit_test_time'] = submitTestTime;
    }
    if (passTestTime != null) {
      _data['pass_test_time'] = passTestTime;
    }
    if (mergerPreTime != null) {
      _data['merger_pre_time'] = mergerPreTime;
    }
    _data['des'] = des;

    List<Map<String, dynamic>> outlinesBeanMaps = [];
    for (DevBranchOutlinesBean outlinesBean in outlinesBeans) {
      outlinesBeanMaps.add(outlinesBean.toJson());
    }
    _data['outlines'] = outlinesBeanMaps;

    return _data;
  }
}

class DevBranchOutlinesBean {
  final String title;
  final String? url;

  DevBranchOutlinesBean({
    required this.title,
    this.url,
  });

  factory DevBranchOutlinesBean.fromJson(Map<String, dynamic> json) {
    return DevBranchOutlinesBean(
      title: json['title'] ?? '',
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    if (url != null) {
      _data['url'] = url;
    }

    return _data;
  }
}
