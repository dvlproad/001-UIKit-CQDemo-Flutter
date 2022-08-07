import 'dart:convert';
import 'package:meta/meta.dart'; // 为了使用 @required
import 'package:app_network/app_network.dart';
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
				"h5BgImageUrl": "https://bojuehui-1302324914.cos.ap-guangzhou.myqcloud.com/image/wish/share.png",
				"shareDescription": "我种草了好多愿望，快来帮我实现吧！",
				"shareUrl": "http://dev.h5.xihuanwu.com/#/pages-h5/share/share"
			},
			"goodsDetail": {
				"shareUrl": "http://dev.h5.xihuanwu.com/#/pages-h5/share/share"
			},
			"orderAddrDetail": {
				"h5Title": "你有一份好礼待领取",
				"h5BgImageUrl": "https://bojuehui-1302324914.cos.ap-guangzhou.myqcloud.com/image/share/orderShare%403x.png",
				"shareTitle": "你有一份好礼待领取",
				"shareDescription": "完善地址，好礼即将送达至您的手中",
				"shareThumbnailUrl": "https://bojuehui-1302324914.cos.ap-guangzhou.myqcloud.com/image/share/orderShare%403x.png",
				"shareUrl": "http://dev.h5.xihuanwu.com/#/pages-h5/share/share"
			}
		}
	}
}
*/

class GlobalConfig {
  static Map globalConfigMap;

  static getGlobalConfig() {
    AppNetworkKit.post(
      '/config/biz-config',
      params: {"type": "shareUrl"},
    ).then((ResponseModel responseModel) {
      if (responseModel?.isSuccess == true) {
        globalConfigMap = responseModel.result;
      }
    });
  }

  /// 获取商品详情分享的配置信息
  static ShareConfig get goodsDetailShareConfig =>
      _shareConfig("goodsDetailV2");
  static String goodsDetailFullShareUrl({
    @required String h5BgImageUrl,
    @required String h5Title,
    @required String goodsID,
  }) {
    ShareConfig config = goodsDetailShareConfig;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "bgurl=${Uri.encodeComponent(h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(h5Title)}";
    fullShareUrl += "&goodsid=${Uri.encodeComponent(goodsID)}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    fullShareUrl +=
        "&appurl=${Uri.encodeComponent("yuanwangwu://openpage?pageName=goodsDetail&goodsID=$goodsID")}";
    // print('fullShareUrl = ${fullShareUrl}');
    return fullShareUrl;
  }

  /// 愿望单详情
  static ShareConfig get wishDetailShareConfig => _shareConfig("wishDetailV2");
  static String wishDetailFullShareUrl({
    @required String wishID,
    @required String buyerId,
  }) {
    ShareConfig config = wishDetailShareConfig;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "bgurl=${Uri.encodeComponent(config.h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(config.h5Title)}";
    fullShareUrl += "&wishid=${Uri.encodeComponent(wishID)}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
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
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    fullShareUrl +=
        "&appurl=${Uri.encodeComponent("yuanwangwu://openpage?pageName=orderDetailPage&payInfoId=$payInfoId&bizId=$bizId&buyerId=$buyerId&consigneeAccountId=$consigneeAccountId")}";

    return fullShareUrl;
  }

  /// 待支付订单的分享链接(使用于:请TA购买的业务)
  static ShareConfig get helpToPayOrderShareConfig =>
      _shareConfig("helpToPayOrderV2");
  static String helpToPayOrderFullShareUrl({@required String wishId}) {
    ShareConfig config = helpToPayOrderShareConfig;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "bgurl=${Uri.encodeComponent(config.h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(config.h5Title)}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    fullShareUrl +=
        "&appurl=${Uri.encodeComponent("yuanwangwu://openpage?pageName=helpToPayOrder&wishId=$wishId")}";

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

  /// 邀请地址分享
  static ShareConfig get inviteDetailShareConfig =>
      _shareConfig("inviteDetail");
  static String inviteDetailFullShareUrl({
    @required String name,
    @required String accountId,
    @required String avatar,
    @required String title,
  }) {
    ShareConfig config = inviteDetailShareConfig;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "name=${name}";
    fullShareUrl += "&accountId=${accountId}";
    fullShareUrl += "&avatar=${avatar}";
    fullShareUrl += "&appurl=${Uri.encodeComponent("yuanwangwu://openpage")}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    return fullShareUrl;
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

extension H5ParamsAdd on String {
  String addH5CustomParamsByShareConfig(ShareConfig config) {
    Map<String, String> h5Params = {};
    if (config.h5ButtonText != null && config.h5ButtonText.isNotEmpty) {
      h5Params.addAll({"btntext": config.h5ButtonText});
    }

    String newString = this.addH5CustomParams(h5Params);
    return newString;
  }

  String addH5CustomParams(Map<String, String> h5Params) {
    String newString = this;

    for (String h5ParamKey in h5Params.keys) {
      String h5ParamValue = h5Params[h5ParamKey];
      String h5ParamEncodeValue = Uri.encodeComponent(h5ParamValue);
      String extraString = "$h5ParamKey=$h5ParamEncodeValue";
      newString += "&$extraString";
    }
    return newString;
  }
}
