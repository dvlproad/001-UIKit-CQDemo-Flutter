class ShareConfig {
  String h5Title; // 专给h5页面显示的标题文本
  String h5BgImageUrl; //	专给h5页面显示的背景图片
  String h5ButtonText; // 专给h5页面显示的按钮文本(为null或空的时候,h5不显示按钮)
  String shareTitle; //	分享的文本
  String shareDescription; //分享的描述
  String shareThumbnailUrl; //分享的缩略图
  String shareUrl; //	分享的h5地址

  ShareConfig({
    this.h5Title,
    this.h5BgImageUrl,
    this.h5ButtonText,
    this.shareTitle,
    this.shareDescription,
    this.shareThumbnailUrl,
    this.shareUrl,
  });

  ShareConfig.fromJson(Map<String, dynamic> json) {
    h5Title = json['h5Title'] ?? '';
    h5BgImageUrl = json['h5BgImageUrl'] ?? '';
    h5ButtonText = json['h5ButtonText'] ?? '';
    shareTitle = json['shareTitle'] ?? '';
    shareDescription = json['shareDescription'] ?? '';
    shareThumbnailUrl = json['shareThumbnailUrl'] ?? '';
    shareUrl = json['shareUrl'] ?? '';
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
