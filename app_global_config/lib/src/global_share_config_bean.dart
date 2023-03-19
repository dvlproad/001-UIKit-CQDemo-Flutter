/*
 * @Author: dvlproad
 * @Date: 2022-07-25 19:38:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-11 17:05:53
 * @Description: 
 */
class ShareConfig {
  String h5Title; // 专给h5页面显示的标题文本
  String h5BgImageUrl; //	专给h5页面显示的背景图片
  String? h5ButtonText; // 专给h5页面显示的按钮文本(为null或空的时候,h5不显示按钮)
  String? shareTitle; //	分享的文本
  String? shareDescription; //分享的描述
  String? shareThumbnailUrl; //分享的缩略图
  String shareUrl; //	分享的h5地址

  ShareConfig({
    required this.h5Title,
    required this.h5BgImageUrl,
    this.h5ButtonText,
    this.shareTitle,
    this.shareDescription,
    this.shareThumbnailUrl,
    required this.shareUrl,
  });

  static ShareConfig fromJson(Map<String, dynamic> json) {
    String h5Title = json['h5Title'] ?? '';
    String h5BgImageUrl = json['h5BgImageUrl'] ?? '';
    String h5ButtonText = json['h5ButtonText'] ?? '';
    String shareTitle = json['shareTitle'] ?? '';
    String shareDescription = json['shareDescription'] ?? '';
    String shareThumbnailUrl = json['shareThumbnailUrl'] ?? '';
    String shareUrl = json['shareUrl'] ?? '';

    return ShareConfig(
      h5Title: h5Title,
      h5BgImageUrl: h5BgImageUrl,
      h5ButtonText: h5ButtonText,
      shareTitle: shareTitle,
      shareDescription: shareDescription,
      shareThumbnailUrl: shareThumbnailUrl,
      shareUrl: shareUrl,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['h5Title'] = h5Title;
    _data['h5BgImageUrl'] = h5BgImageUrl;
    _data['h5ButtonText'] = h5ButtonText;
    _data['shareTitle'] = shareTitle;
    _data['shareDescription'] = shareDescription;
    _data['shareThumbnailUrl'] = shareThumbnailUrl;
    _data['shareUrl'] = shareUrl;
    return _data;
  }
}
