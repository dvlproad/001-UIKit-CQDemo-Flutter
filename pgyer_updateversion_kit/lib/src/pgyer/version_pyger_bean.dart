/*
 * @Author: dvlproad
 * @Date: 2022-07-07 18:51:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-10 20:03:50
 * @Description: 
 */
import 'dart:convert' show json;
import 'dart:io';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

class VersionPgyerBean extends VersionBaseBean {
  String buildNumberInPyger;
  bool buildHaveNewVersion;

  VersionPgyerBean({
    bool forceUpdate = false, // 是否强制升级
    required String version,
    required String buildNumber,
    required this.buildNumberInPyger, // 蒲公英生成的用于区分历史版本的build号
    this.buildHaveNewVersion = false, // Boolean	是否有新版本
    required String updateLog, // 应用更新说明
    required String downloadUrl, // 应用安装地址
  }) : super(
          forceUpdate: forceUpdate,
          version: version,
          buildNumber: buildNumber,
          updateLog: updateLog,
          downloadUrl: downloadUrl,
        );

  static VersionPgyerBean fromJson(Map<String, dynamic> json) {
    // 新版本 version_buildId
    String buildVersion = json['buildVersion']; // 版本号, 默认为1.0
    String buildNumber = json['buildVersionNo']; // 上传包的版本编号，默认为1 (即编译的版本号)
    String buildBuildVersion =
        json['buildBuildVersion']; // 蒲公英生成的用于区分历史版本的build号
    bool buildHaveNewVersion =
        json['buildHaveNewVersion']; //是否有新版本，发现build设置四位数以上时候，此值不准确，所以不适用

    //应用更新说明
    String updteDescription = json['buildUpdateDescription'];

    //应用安装地址
    // iOS:itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/c9356ea75030eee48073b2cb99b16df4/update/s.plist
    // iOS:itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/com.bojue.wish"
    String downloadUrl = json['downloadURL']; // 应用安装地址
    if(Platform.isIOS){
      if (json['buildShortcutUrl'] != null) {
        // 应用短链接(有空值情况,如版本号1.07.08,编译号07081011时候)
        downloadUrl = json['buildShortcutUrl'];
      }
    }
    // 是否需要强制更新
    bool needForceUpdate = json['needForceUpdate'];

    // print('版本:$buildVersion\_$buildNumber已更新\n更新内容:updteContent\n下载地址:$downloadURL');

    VersionPgyerBean bean = VersionPgyerBean(
      forceUpdate: needForceUpdate,
      version: buildVersion,
      buildNumber: buildNumber,
      buildNumberInPyger: buildBuildVersion,
      buildHaveNewVersion: buildHaveNewVersion,
      updateLog: updteDescription,
      downloadUrl: downloadUrl,
    );

    return bean;
  }

  String get newVersion {
    String _newVersion = '${version}(${buildNumber})\_${buildNumberInPyger}';
    return _newVersion;
  }

  @override
  String toString() {
    return '{"version": ${version != null ? '${json.encode(version)}' : 'null'},"forceUpdate": ${forceUpdate != null ? '${json.encode(forceUpdate)}' : 'null'},"buildNumber": ${buildNumber != null ? '${json.encode(buildNumber)}' : 'null'},"buildNumberInPyger": ${buildNumberInPyger != null ? '${json.encode(buildNumberInPyger)}' : 'null'},"buildHaveNewVersion": ${buildHaveNewVersion != null ? '${json.encode(buildHaveNewVersion)}' : 'null'},"updateLog": ${updateLog != null ? '${json.encode(updateLog)}' : 'null'},"downloadUrl": ${downloadUrl != null ? '${json.encode(downloadUrl)}' : 'null'}}';
  }
}
