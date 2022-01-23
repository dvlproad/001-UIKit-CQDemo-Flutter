import 'dart:convert' show json;

class VersionBean {
  String version;
  String buildNumber;
  String updateLog;
  String downloadUrl;

  VersionBean.fromParams({
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
    version = jsonRes['version'];
    buildNumber = jsonRes['buildNumber'];
    updateLog = jsonRes['updateLog'];
    downloadUrl = jsonRes['downloadUrl'];
  }

  @override
  String toString() {
    return '{"version": ${version != null ? '${json.encode(version)}' : 'null'},"buildNumber": ${buildNumber != null ? '${json.encode(buildNumber)}' : 'null'},"updateLog": ${updateLog != null ? '${json.encode(updateLog)}' : 'null'},"downloadUrl": ${downloadUrl != null ? '${json.encode(downloadUrl)}' : 'null'}}';
  }
}
