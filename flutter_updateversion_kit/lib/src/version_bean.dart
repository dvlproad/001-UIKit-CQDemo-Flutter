import 'dart:convert' show json;

class VersionBean {
  String downloadUrl;
  String isson;
  String version;

  VersionBean.fromParams({this.downloadUrl, this.isson, this.version});

  factory VersionBean(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? VersionBean._fromJson(json.decode(jsonStr))
          : VersionBean._fromJson(jsonStr);

  VersionBean._fromJson(jsonRes) {
    downloadUrl = jsonRes['downloadUrl'];
    isson = jsonRes['isson'];
    version = jsonRes['version'];
  }

  @override
  String toString() {
    return '{"downloadUrl": ${downloadUrl != null ? '${json.encode(downloadUrl)}' : 'null'},"isson": ${isson != null ? '${json.encode(isson)}' : 'null'},"version": ${version != null ? '${json.encode(version)}' : 'null'}}';
  }
}
