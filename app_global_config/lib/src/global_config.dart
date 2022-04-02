import 'dart:convert';
import 'package:meta/meta.dart'; // 为了使用 @required
import 'package:flutter_network_kit/flutter_network_kit.dart';
import './global_config_bean.dart';

/*
命名如下
h5Title：		专给h5页面显示的标题文本
h5BgImageUrl：	专给h5页面显示的背景图片
shareTitle：		分享的文本
shareDescription：分享的描述
shareThumbnailUrl：分享的缩略图
shareUrl:		分享的h5地址

{
	"code": 0,
	"msg": "获取全局配置成功",
	"data": {
		"shareConfig": {
			"wishDetail": {
				"h5Title": "快来看看我的愿望单",
				"h5BgImageUrl": "https://xxx-1302324914.cos.ap-guangzhou.myqcloud.com/image/wish/share.png",
				"shareDescription": "我种草了好多愿望，快来帮我实现吧！",
				"shareUrl": "http://dev.h5.xxx.com/#/pages-h5/share/share"
			},
			"goodsDetail": {
				"shareUrl": "http://dev.h5.xxx.com/#/pages-h5/share/share"
			},
			"orderAddrDetail": {
				"h5Title": "你有一份好礼待领取",
				"h5BgImageUrl": "https://xxx-1302324914.cos.ap-guangzhou.myqcloud.com/image/share/orderShare%403x.png",
				"shareTitle": "你有一份好礼待领取",
				"shareDescription": "完善地址，好礼即将送达至您的手中",
				"shareThumbnailUrl": "https://xxx-1302324914.cos.ap-guangzhou.myqcloud.com/image/share/orderShare%403x.png",
				"shareUrl": "http://dev.h5.xxx.com/#/pages-h5/share/share"
			}
		}
	}
}
*/

class GlobalConfig {
  static Map globalConfigMap;

  static getGlobalConfig() {
    NetworkKit.post(
      '/config/biz-config',
      params: {"type": "shareUrl"},
      cacheLevel: NetworkCacheLevel.none,
    ).then((ResponseModel responseModel) {
      if (responseModel.isSuccess) {
        globalConfigMap = responseModel.result;
      }
    });
  }

  /// 获取商品详情分享的配置信息
  static ShareConfig get goodsDetailShareConfig => _shareConfig("goodsDetail");
  static String goodsDetailFullShareUrl({
    @required String h5BgImageUrl,
    @required String h5Title,
    @required String goodsID,
  }) {
    ShareConfig config = wishDetailShareConfig;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "bgurl=${Uri.encodeComponent(h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(h5Title)}";
    fullShareUrl = fullShareUrl.addH5CustomParams(config);
    fullShareUrl +=
        "&appurl=${Uri.encodeComponent("yuanwangwu://openpage?pageName=goodsDetail&goodsID=$goodsID")}";

    return fullShareUrl;
  }

  /// 愿望单详情
  static ShareConfig get wishDetailShareConfig => _shareConfig("wishDetail");
  static String wishDetailFullShareUrl({
    @required String wishID,
    @required String buyerId,
  }) {
    ShareConfig config = wishDetailShareConfig;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "bgurl=${Uri.encodeComponent(config.h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(config.h5Title)}";
    fullShareUrl = fullShareUrl.addH5CustomParams(config);
    fullShareUrl +=
        "&appurl=${Uri.encodeComponent("yuanwangwu://openpage?pageName=wishListDetailPage&wishID=$wishID&buyerId=$buyerId")}";

    return fullShareUrl;
  }

  /// 订单地址分享
  static ShareConfig get orderAddrDetailShareConfig =>
      _shareConfig("orderAddrDetail");
  static String orderAddrDetailFullShareUrl({
    @required String payInfoId,
    @required String bizId,
    @required String buyerId,
    @required String consigneeAccountId,
  }) {
    ShareConfig config = orderAddrDetailShareConfig;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "bgurl=${Uri.encodeComponent(config.h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(config.h5Title)}";
    fullShareUrl = fullShareUrl.addH5CustomParams(config);
    fullShareUrl +=
        "&appurl=${Uri.encodeComponent("yuanwangwu://openpage?pageName=orderDetailPage&payInfoId=$payInfoId&bizId=$bizId&buyerId=$buyerId&consigneeAccountId=$consigneeAccountId")}";

    return fullShareUrl;
  }

  String appUrl(String pageName, {Map<String, dynamic> pageParams}) {
    String appUrl = "yuanwangwu://openpage?pageName=$pageName";
    if (pageParams.isNotEmpty) {
      String jsonString = json.encode(pageParams);
      appUrl += "&pageParmas=$jsonString";
    }
    return appUrl;
  }

  /// 获取指定分享的配置信息
  static ShareConfig _shareConfig(String key) {
    Map allShareConfigMap = globalConfigMap["shareConfig"];
    if (allShareConfigMap == null) {
      return null;
    }
    Map goodsDetailShareConfigMap = allShareConfigMap[key];
    if (goodsDetailShareConfigMap == null) {
      return null;
    }
    ShareConfig configBean = ShareConfig.fromJson(goodsDetailShareConfigMap);
    return configBean;
  }
}

extension AddH5CustomParams on String {
  String addH5CustomParams(ShareConfig config) {
    String newString = this;
    if (config.h5ButtonText != null && config.h5ButtonText.isNotEmpty) {
      newString += "&btntext=${Uri.encodeComponent(config.h5ButtonText)}";
    }
    return newString;
  }
}
