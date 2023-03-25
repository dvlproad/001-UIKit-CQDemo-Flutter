/*
 * @Author: dvlproad
 * @Date: 2023-02-08 13:23:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-26 01:56:12
 * @Description: 
 */
/*
 * @Author: dvlproad
 * @Date: 2022-07-07 18:51:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-16 18:13:18
 * @Description: 
 */
import 'dart:convert' show json;
import '../branch_package_info/branch_package_info.dart';

enum UpdateAppType {
  develop1, // 开发环境1
  develop2, // 开发环境2
  test1, // 测试环境1
  preproduct, // 预生产环境
  product, // 正式环境
}

class VersionBaseBean {
  bool forceUpdate;
  String version;
  String buildNumber;
  bool? buildHaveNewVersion;
  String updateLog;
  String downloadUrl;

  VersionBaseBean({
    this.forceUpdate = false, // 是否强制升级
    required this.version, // 版本号, 默认为1.0
    this.buildNumber = '1', // 上传包的版本编号，默认为1 (即编译的版本号)
    this.buildHaveNewVersion, // Boolean	是否有新版本(默认null，true/false直接显示/不显示弹窗不管版本是不是低了，null时候才根据版本判断)
    required this.updateLog,
    required this.downloadUrl,
  });

  // VersionBaseBean.fromJson(Map<String, dynamic> json) {
  //   this.forceUpdate = (json['forceUpdate'] ?? false);
  //   this.version = json['version'] ?? '1.0.0';
  //   this.buildNumber = json['buildNumber'] ?? '';
  //   this.updateLog = json['updateLog'] ?? '';
  //   this.downloadUrl = json['downloadUrl'] ?? '';
  // }

  static VersionBaseBean? fromJson(Map<String, dynamic> json) {
    bool buildHaveNewVersion =
        json['hasUpdateVersion']; //是否有新版本，发现build设置四位数以上时候，此值不准确，所以不适用
    if (buildHaveNewVersion != true) {
      return null;
    }

    // 新版本 version_buildId
    String buildVersion = json['lastVersionNo']; // 版本号, 默认为1.0
    String buildNumber = json['buildNumber']; // 上传包的版本编号，默认为1 (即编译的版本号)

    //应用更新说明
    String updteDescription = json['versionMsg'];

    //应用安装地址
    String downloadUrl = json['downloadUrl']; // 应用安装地址

    // 是否需要强制更新
    bool needForceUpdate = json['forceUpdateFlag'] ?? false;

    VersionBaseBean bean = VersionBaseBean(
      forceUpdate: needForceUpdate,
      version: buildVersion,
      buildNumber: buildNumber,
      updateLog: updteDescription,
      downloadUrl: downloadUrl,
    );

    return bean;
  }

  String get newVersion {
    String _newVersion = '$version($buildNumber)';
    return _newVersion;
  }

  Future<String> get updateContent async {
    // 新版本 version_buildId
    String buildVersion = version;

    //应用更新说明
    BranchPackageInfo packageInfo = await BranchPackageInfo.fromPlatform();
    String currentVersion =
        "您当前的版本为${packageInfo.version}(${packageInfo.buildNumber})";
    String newVersion = '检查到有新版本$buildVersion($buildNumber)';
    String updteDescription = updateLog;
    if (updteDescription.isEmpty) {
      updteDescription = '更新说明略';
    }
    // String updateContent = '$currentVersion\n$newVersion\n$updteDescription';
    List<String> lineStrings = [currentVersion, newVersion, updteDescription];
    String _updateContent = _getNewLineString(lineStrings);

    return _updateContent;
  }

  String _getNewLineString(List<String> lineStrings) {
    StringBuffer sb = StringBuffer();
    for (String line in lineStrings) {
      sb.write(line + "\n");
    }
    return sb.toString();
  }

  @override
  String toString() {
    // ignore: unnecessary_null_comparison
    return '{"version": ${version != null ? json.encode(version) : 'null'},"forceUpdate": ${forceUpdate != null ? json.encode(forceUpdate) : 'null'},"buildNumber": ${buildNumber != null ? json.encode(buildNumber) : 'null'},"updateLog": ${updateLog != null ? json.encode(updateLog) : 'null'},"downloadUrl": ${downloadUrl != null ? json.encode(downloadUrl) : 'null'}}';
  }
}
