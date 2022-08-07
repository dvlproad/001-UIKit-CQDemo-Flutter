/*
 * @Author: dvlproad
 * @Date: 2022-07-07 18:51:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-10 19:45:20
 * @Description: 
 */
import 'dart:convert' show json;
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

class VersionBean extends VersionBaseBean {
  VersionBean({
    bool forceUpdate = false, // 是否强制升级
    required String version,
    required String buildNumber,
    required String updateLog, // 应用更新说明
    required String downloadUrl, // 应用安装地址
  }) : super(
          forceUpdate: forceUpdate,
          version: version,
          buildNumber: buildNumber,
          updateLog: updateLog,
          downloadUrl: downloadUrl,
        );

  // VersionBean.fromJson(Map<String, dynamic> json) {
  //   forceUpdate = json['forceUpdate'] ?? false;
  //   version = json['version'];
  //   buildNumber = json['buildNumber'];
  //   updateLog = json['updateLog'];
  //   downloadUrl = json['downloadUrl'];
  // }

  @override
  String toString() {
    return '{"version": ${version != null ? '${json.encode(version)}' : 'null'},"forceUpdate": ${forceUpdate != null ? '${json.encode(forceUpdate)}' : 'null'},"buildNumber": ${buildNumber != null ? '${json.encode(buildNumber)}' : 'null'},"updateLog": ${updateLog != null ? '${json.encode(updateLog)}' : 'null'},"downloadUrl": ${downloadUrl != null ? '${json.encode(downloadUrl)}' : 'null'}}';
  }
}
