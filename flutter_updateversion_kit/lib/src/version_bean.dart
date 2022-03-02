import 'dart:convert' show json;

class VersionBean {
  bool forceUpdate;
  String version;
  String buildNumber;
  String updateLog;
  String downloadUrl;

  VersionBean.fromParams({
    this.forceUpdate, // 是否强制升级
    this.version,
    this.buildNumber,
    this.updateLog,
    this.downloadUrl,
  });

  factory VersionBean(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? VersionBean._fromJson(json.decode(jsonStr))
          : VersionBean._fromJson(jsonStr);

  VersionBean._fromJson(jsonRes) {
    forceUpdate = jsonRes['forceUpdate'];
    version = jsonRes['version'];
    buildNumber = jsonRes['buildNumber'];
    updateLog = jsonRes['updateLog'];
    downloadUrl = jsonRes['downloadUrl'];
  }

  @override
  String toString() {
    return '{"version": ${version != null ? '${json.encode(version)}' : 'null'},"forceUpdate": ${forceUpdate != null ? '${json.encode(forceUpdate)}' : 'null'},"buildNumber": ${buildNumber != null ? '${json.encode(buildNumber)}' : 'null'},"updateLog": ${updateLog != null ? '${json.encode(updateLog)}' : 'null'},"downloadUrl": ${downloadUrl != null ? '${json.encode(downloadUrl)}' : 'null'}}';
  }
}
