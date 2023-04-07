import 'dart:convert';
import 'package:meta/meta.dart'; // 为了使用 required
import 'package:app_network/app_network.dart';
import './global_network_config_bean.dart';
import './global_appinfo_config_bean.dart';
import './global_share_config_bean.dart';
import './global_game_config_bean.dart';
import './global_web_config_bean.dart';
import './global_chat_config_bean.dart';

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
  static Map<String, dynamic>? globalConfigMap;

  static getGlobalConfig({void Function(bool isSuccess)? callback}) {
    AppNetworkCacheUtil.post(
      '/config/biz-config',
      params: {"type": "shareUrl"},
    ).then((ResponseModel responseModel) {
      // 仅接口实际请求成功/失败 才向外回调
      if (responseModel.isCache == true) {
        globalConfigMap = responseModel.result;
      } else if (responseModel.isSuccess == true) {
        globalConfigMap = responseModel.result;
        if (callback != null) {
          callback(responseModel.isSuccess);
        }
      } else {
        if (callback != null) {
          callback(responseModel.isSuccess);
        }
      }
    });
  }

  /// 获取网络的配置信息
  static GlobalNetworkConfigBean? networkConfig() {
    if (globalConfigMap == null) {
      return null;
    }
    Map<String, dynamic>? networkConfigMap = globalConfigMap!["networkConfig"];
    if (networkConfigMap == null) {
      return null;
    }

    GlobalNetworkConfigBean configBean =
        GlobalNetworkConfigBean.fromJson(networkConfigMap);
    return configBean;
  }

  /// 获取web的配置信息
  static GlobalWebConfigBean? webConfig() {
    if (globalConfigMap == null || globalConfigMap!['webConfig'] == null) {
      return GlobalWebConfigBean(
        reloadInterval: 60 * 10,
      );
    }
    return GlobalWebConfigBean.fromJson(globalConfigMap!['webConfig']);
  }

  /// 获取web的配置信息
  static GlobalChatConfigBean? chatConfig() {
    if (globalConfigMap == null || globalConfigMap!['chatConfig'] == null) {
      return GlobalChatConfigBean(
        fromRemindMessage: '对方还未关注或回复你之前，只能发1条文字消息',
      );
    }
    return GlobalChatConfigBean.fromJson(globalConfigMap!['chatConfig']);
  }

  /// 获取app下载链接的配置信息
  static GlobalAppInfoConfigBean appInfoConfig() {
    GlobalAppInfoConfigBean defaultConfig = GlobalAppInfoConfigBean(
      appDownloadImageUrl: '',
    );
    if (globalConfigMap == null) {
      return defaultConfig;
    }
    Map<String, dynamic>? appInfoConfigMap = globalConfigMap!["appInfo"];
    if (appInfoConfigMap == null) {
      return defaultConfig;
    }

    GlobalAppInfoConfigBean configBean =
        GlobalAppInfoConfigBean.fromJson(appInfoConfigMap);
    return configBean;
  }

  /// 获取游戏的配置信息
  static GlobalGameConfigBean? gameConfig() {
    if (globalConfigMap == null) {
      return null;
    }
    Map<String, dynamic>? gameConfigMap = globalConfigMap!["gameConfig"];
    if (gameConfigMap == null) {
      return null;
    }

    GlobalGameConfigBean configBean =
        GlobalGameConfigBean.fromJson(gameConfigMap);
    return configBean;
  }

  static String? turntableFullGameUrl({
    required String h5Title,
    required String usertoken,
  }) {
    if (GlobalConfig.gameConfig() == null) {
      return null;
    }

    GameConfig gameConfigBean = GlobalConfig.gameConfig()!.turntableConfig;
    String gameUrl = gameConfigBean.gameUrl;

    String fullGameUrl = gameUrl;
    Map<String, String> h5Params = {
      'title': Uri.encodeComponent(h5Title),
      'token': usertoken,
    };
    fullGameUrl = fullGameUrl.addH5CustomParams(h5Params);

    fullGameUrl.addH5AppUrl('goodsDetail', h5Params);
    // print('fullGameUrl = ${fullGameUrl}');
    return fullGameUrl;
  }

  //获取大转盘游戏h5的背景图
  static String? turntableBgImageUrl() {
    if (GlobalConfig.gameConfig() == null) {
      return null;
    }

    GameConfig gameConfigBean = GlobalConfig.gameConfig()!.turntableConfig;
    String? bgImageUrl = gameConfigBean.gameBackgroundImageUrl;
    return bgImageUrl;
  }

  //农场游戏h5背景图
  static String? farmBgImageUrl() {
    if (GlobalConfig.gameConfig() == null) {
      return null;
    }

    GameConfig gameConfigBean = GlobalConfig.gameConfig()!.mineGameConfig!;
    String? bgImageUrl = gameConfigBean.bgImageUrl;
    return bgImageUrl;
  }

  /// 豆了个豆 游戏入口 搜索关键字
  static String? beanFullGameName() {
    if (GlobalConfig.gameConfig() == null) {
      return null;
    }
    GameConfig gameConfigBean = GlobalConfig.gameConfig()!.beanConfig;
    return gameConfigBean.gameName;
  }

  //获取豆了个豆游戏url
  static String? beanFullGameUrl({
    required String h5Title,
  }) {
    if (GlobalConfig.gameConfig() == null) {
      return null;
    }

    GameConfig gameConfigBean = GlobalConfig.gameConfig()!.beanConfig;
    String? gameUrl = gameConfigBean.gameUrl;

    if (gameUrl == null) {
      return null;
    }

    String fullGameUrl = gameUrl;
    Map<String, String> h5Params = {};
    fullGameUrl = fullGameUrl.addH5CustomParams(h5Params);

    // fullGameUrl.addH5AppUrl('goodsDetail', h5Params);
    // print('fullGameUrl = ${fullGameUrl}');
    return fullGameUrl;
  }

// }

  /// 获取指定分享的配置信息
// extension Share on GlobalConfig {
  static ShareConfig? _shareConfig(String key) {
    if (globalConfigMap == null) {
      return null;
    }
    Map<String, dynamic>? allShareConfigMap = globalConfigMap!["shareConfig"];
    if (allShareConfigMap == null) {
      return null;
    }
    Map<String, dynamic>? shareConfigMap = allShareConfigMap[key];
    if (shareConfigMap == null) {
      return null;
    }
    ShareConfig configBean = ShareConfig.fromJson(shareConfigMap);
    return configBean;
  }

  /// 获取商品详情分享的配置信息
  static ShareConfig? get goodsDetailShareConfig =>
      _shareConfig("goodsDetailV2");
  static String? goodsDetailFullShareUrl({
    required String h5BgImageUrl,
    required String h5Title,
    required String goodsID,
  }) {
    if (goodsDetailShareConfig == null) {
      return null;
    }
    ShareConfig config = goodsDetailShareConfig!;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "bgurl=${Uri.encodeComponent(h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(h5Title)}";
    fullShareUrl += "&goodsid=${Uri.encodeComponent(goodsID)}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    // fullShareUrl +=
    //     "&appurl=${Uri.encodeComponent("yuanwangwu://openpage?pageName=goodsDetail&goodsID=$goodsID")}";
    // print('fullShareUrl = ${fullShareUrl}');
    fullShareUrl = fullShareUrl.addH5AppUrl('goodsDetail', {
      'goodsID': goodsID,
    });
    return fullShareUrl;
  }

  /// 获取个人中心分享的配置信息
  static ShareConfig? get userInfoShareConfig => _shareConfig("userInfoDetail");
  static String? userInfoFullShareUrl({
    required String h5BgImageUrl,
    required String h5Title,
    required String accountId,
  }) {
    if (userInfoShareConfig == null) {
      return null;
    }
    ShareConfig config = userInfoShareConfig!;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "bgurl=${Uri.encodeComponent(h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(h5Title)}";
    fullShareUrl += "&id=${Uri.encodeComponent(accountId)}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    fullShareUrl = fullShareUrl.addH5AppUrl('spaceUserPage', {
      'id': accountId,
    });
    return fullShareUrl;
  }

  /// 获取店铺分享的配置信息
  static ShareConfig? get shopShareConfig => _shareConfig("shopDetail");
  static String? shopShareUrl({
    required String h5BgImageUrl,
    required String h5Title,
    required String shopId,
  }) {
    if (userInfoShareConfig == null) {
      return null;
    }
    ShareConfig config = shopShareConfig!;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "bgurl=${Uri.encodeComponent(h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(h5Title)}";
    fullShareUrl += "&shopId=${Uri.encodeComponent(shopId)}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    fullShareUrl = fullShareUrl.addH5AppUrl('shopMainPage', {
      'shopId': shopId,
    });
    return fullShareUrl;
  }

  /// 愿望单详情
  static ShareConfig? get wishDetailShareConfig => _shareConfig("wishDetailV2");
  static String? wishDetailFullShareUrl({
    required String wishID,
    required String buyerId,
    required String sharerId,
  }) {
    if (wishDetailShareConfig == null) {
      return null;
    }
    ShareConfig config = wishDetailShareConfig!;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "bgurl=${Uri.encodeComponent(config.h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(config.h5Title)}";
    fullShareUrl += "&wishid=${Uri.encodeComponent(wishID)}";
    fullShareUrl += "&sharerId=${Uri.encodeComponent(sharerId)}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    fullShareUrl +=
        "&appurl=${Uri.encodeComponent("yuanwangwu://openpage?pageName=wishListDetailPage&wishID=$wishID&buyerId=$buyerId")}";

    return fullShareUrl;
  }

  /// 订单地址分享
  static ShareConfig? get orderAddrDetailShareConfig =>
      _shareConfig("orderAddrDetail");
  static String? orderAddrDetailFullShareUrl({
    required String payInfoId,
    required String bizId,
    required String buyerId,
    required String consigneeAccountId,
  }) {
    if (orderAddrDetailShareConfig == null) {
      return null;
    }

    ShareConfig config = orderAddrDetailShareConfig!;

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
  static ShareConfig? get helpToPayOrderShareConfig =>
      _shareConfig("helpToPayOrderV2");
  static String? helpToPayOrderFullShareUrl({required String wishId}) {
    if (helpToPayOrderShareConfig == null) {
      return null;
    }
    ShareConfig config = helpToPayOrderShareConfig!;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "bgurl=${Uri.encodeComponent(config.h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(config.h5Title)}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    fullShareUrl +=
        "&appurl=${Uri.encodeComponent("yuanwangwu://openpage?pageName=helpToPayOrder&wishId=$wishId")}";

    return fullShareUrl;
  }

  /// 待支付订单的分享链接(使用于:众筹购买的业务)
  static ShareConfig? get crowdPayOrderShareConfig =>
      _shareConfig("crowdPayOrderV2");
  static String? crowdToPayOrderFullShareUrl({required String bizId}) {
    if (crowdPayOrderShareConfig == null) {
      return null;
    }
    ShareConfig config = crowdPayOrderShareConfig!;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += 'bizId=$bizId';
    fullShareUrl += "&bgurl=${Uri.encodeComponent(config.h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(config.h5Title)}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    fullShareUrl +=
        "&appurl=${Uri.encodeComponent("yuanwangwu://openpage?pageName=orderConfirmPage&bizId=$bizId")}";

    return fullShareUrl;
  }

  /// 晒单分享h5链接
  static ShareConfig? get dryingSheetsConfig => _shareConfig("dryingSheets");
  static String? dryingSheetsFullUrl(
      {required String bizId, required String skuIds}) {
    if (dryingSheetsConfig == null) {
      return null;
    }
    ShareConfig config = dryingSheetsConfig!;
    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += 'id=$bizId';
    fullShareUrl += '&skuIds=$skuIds';
    fullShareUrl += "&bgurl=${Uri.encodeComponent(config.h5BgImageUrl)}";
    fullShareUrl += "&title=${Uri.encodeComponent(config.h5Title)}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    fullShareUrl += "&appurl=${Uri.encodeComponent("yuanwangwu://openpage")}";
    return fullShareUrl;
  }

  /// app下载二维码
  static String appDownLoadImageUrl() {
    GlobalAppInfoConfigBean downConfigBean = GlobalConfig.appInfoConfig();
    String fullGameUrl = downConfigBean.appDownloadImageUrl;
    return fullGameUrl;
  }

  String getAppUrl(String pageName, {Map<String, dynamic>? pageParams}) {
    String appUrl = "yuanwangwu://openpage?pageName=$pageName";
    if (pageParams != null && pageParams.isNotEmpty) {
      String jsonString = json.encode(pageParams);
      appUrl += "&pageParmas=$jsonString";
    }
    return appUrl;
  }

  /// 邀请地址分享
  static ShareConfig? get inviteDetailShareConfig =>
      _shareConfig("inviteDetail");
  static String? inviteDetailFullShareUrl({
    required String name,
    required String accountId,
    required String avatar,
    required String title,
  }) {
    if (inviteDetailShareConfig == null) {
      return null;
    }
    ShareConfig config = inviteDetailShareConfig!;

    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "name=${name}";
    fullShareUrl += "&accountId=${accountId}";
    fullShareUrl += "&avatar=${avatar}";
    fullShareUrl += "&appurl=${Uri.encodeComponent("yuanwangwu://openpage")}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);
    return fullShareUrl;
  }

  static ShareConfig? get beanFullGameInviteShareConfig =>
      _shareConfig("beanFullGameInvite");
  static String? beanFullGameInviteShareUrl({
    required String accountId,
  }) {
    if (beanFullGameInviteShareConfig == null) {
      return null;
    }
    ShareConfig config = beanFullGameInviteShareConfig!;
    String fullShareUrl = config.shareUrl;
    fullShareUrl += '?';
    fullShareUrl += "&accountId=${accountId}";
    fullShareUrl +=
        "&appurl=${Uri.encodeComponent("yuanwangwu://openpage?pageName=farmGamePage&accountId=$accountId")}";
    fullShareUrl = fullShareUrl.addH5CustomParamsByShareConfig(config);

    return fullShareUrl;
  }

  ///平台客服shopId
  static String? appShopId() {
    if (globalConfigMap == null ||
        globalConfigMap!['appCustomerServiceConfig'] == null) {
      return '';
    }
    return globalConfigMap!['appCustomerServiceConfig']['appShopId'].toString();
  }

  ///平台客服头像
  static String? appHeadImage() {
    if (globalConfigMap == null ||
        globalConfigMap!['appCustomerServiceConfig'] == null) {
      return 'https://images.xihuanwu.com/applet/wishhouse/images/head_image/app_kefu.png';
    }
    return globalConfigMap!['appCustomerServiceConfig']['headImage'];
  }
}

extension H5ParamsAdd on String {
  String addH5CustomParamsByShareConfig(ShareConfig config) {
    Map<String, String> h5Params = {};
    if (config.h5ButtonText != null && config.h5ButtonText!.isNotEmpty) {
      h5Params.addAll({"btntext": config.h5ButtonText!});
    }
    if (config.type != null && config.type!.isNotEmpty) {
      h5Params.addAll({"type": config.type!});
    }

    String newString = this.addH5CustomParams(h5Params);
    return newString;
  }

  String addH5AppUrl(String pageName, Map<String, String> pageParams) {
    String newString = this;

    String appUrl = "yuanwangwu://openpage?pageName=$pageName";
    appUrl = appUrl.addH5CustomParams(pageParams);
    appUrl = Uri.encodeComponent("$appUrl");

    newString += "&appurl=$appUrl";
    return newString;
  }

  String addH5CustomParamsDynamic(Map<String, dynamic> h5Params) {
    return this.addH5CustomParams(h5Params.cast<String, String>());
  }

  String addH5CustomParams(Map<String, String> h5Params) {
    String newString = this;

    for (String h5ParamKey in h5Params.keys) {
      String? h5ParamValue = h5Params[h5ParamKey];
      if (h5ParamValue == null) {
        continue;
      }
      String h5ParamEncodeValue = Uri.encodeComponent(h5ParamValue);
      String extraString = "$h5ParamKey=$h5ParamEncodeValue";
      if (newString.contains('?')) {
        newString += "&$extraString";
      } else {
        newString += "?$extraString";
      }
    }
    return newString;
  }
}
