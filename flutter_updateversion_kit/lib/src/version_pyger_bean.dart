import 'dart:convert' show json;

class VersionPygerBean {
  String version;
  String buildNumber;
  String buildNumberInPyger;
  bool buildHaveNewVersion;
  String updateLog;
  String downloadUrl;

  VersionPygerBean.fromParams({
    this.version,
    this.buildNumber,
    this.buildNumberInPyger, // 蒲公英生成的用于区分历史版本的build号
    this.buildHaveNewVersion, // Boolean	是否有新版本
    this.updateLog, // 应用更新说明
    this.downloadUrl, // 应用安装地址
  });

  factory VersionPygerBean(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? VersionPygerBean._fromJson(json.decode(jsonStr))
          : VersionPygerBean._fromJson(jsonStr);

  VersionPygerBean._fromJson(jsonRes) {
    version = jsonRes['version'];
    buildNumber = jsonRes['buildNumber'];
    buildNumberInPyger = jsonRes['buildNumberInPyger'];
    buildHaveNewVersion = jsonRes['buildHaveNewVersion'];
    updateLog = jsonRes['updateLog'];
    downloadUrl = jsonRes['downloadUrl'];
  }

  @override
  String toString() {
    return '{"version": ${version != null ? '${json.encode(version)}' : 'null'},"buildNumber": ${buildNumber != null ? '${json.encode(buildNumber)}' : 'null'},"buildNumberInPyger": ${buildNumberInPyger != null ? '${json.encode(buildNumberInPyger)}' : 'null'},"buildHaveNewVersion": ${buildHaveNewVersion != null ? '${json.encode(buildHaveNewVersion)}' : 'null'},"updateLog": ${updateLog != null ? '${json.encode(updateLog)}' : 'null'},"downloadUrl": ${downloadUrl != null ? '${json.encode(downloadUrl)}' : 'null'}}';
  }
}
