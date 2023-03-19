/*
 * @Author: dvlproad
 * @Date: 2022-09-20 19:38:18
 * @Description: 全局的网络配置信息(含app下载code码)
 */
class GlobalAppInfoConfigBean {
  late String appDownloadImageUrl;

  GlobalAppInfoConfigBean({
    required this.appDownloadImageUrl,
  });

  GlobalAppInfoConfigBean.fromJson(Map<String, dynamic> json) {
    appDownloadImageUrl = json['appCode'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if (appDownloadImageUrl != null) {
      _data['appCode'] = appDownloadImageUrl;
    }

    return _data;
  }
}
