import 'package:app_network/app_network.dart';
import 'package:fluwx/fluwx.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:app_global_config/app_global_config.dart';

class ShareUtil {
  /// 分享愿望单详情
  static shareWishDetail({
    required String wishID,
    String? wishTitle,
    String? wishDescription,
    String? wishImageUrl,
    required String buyerId,
    WeChatScene? scene,
    required String sharerId,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }

    ShareConfig? config = GlobalConfig.wishDetailShareConfig;
    if (config == null) {
      return;
    }
    String? webPage = GlobalConfig.wishDetailFullShareUrl(
      wishID: wishID,
      buyerId: buyerId,
      sharerId: sharerId,
    );
    if (webPage == null) {
      return;
    }

    var shortUrl = await _getShortUrl(webPage);

    var model = WeChatShareWebPageModel(
      shortUrl,
      title: _lastText(hopeText: wishTitle, defaultText: config.shareTitle),
      description: _lastText(
          hopeText: wishDescription, defaultText: config.shareDescription),
      thumbnail: WeChatImage.network(_lastText(
          hopeText: wishImageUrl, defaultText: config.shareThumbnailUrl)),
      scene: scene ?? WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }

  /// hopeText空值时候，使用 defaultText
  static String _lastText({
    String? hopeText,
    String? defaultText,
  }) {
    if (hopeText == null || hopeText.isEmpty) {
      return defaultText ?? '';
    }
    return hopeText;
  }

  /// 分享商品详情
  static shareGoodsDetail({
    required String h5Title,
    required String goodsID,
    required String goodsName,
    required String goodsThumbnailUrl,
    WeChatScene? scene,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }

    ShareConfig? config = GlobalConfig.goodsDetailShareConfig;
    if (config == null) {
      return;
    }

    String? webPage = GlobalConfig.goodsDetailFullShareUrl(
      h5BgImageUrl: config.h5BgImageUrl,
      h5Title: h5Title,
      goodsID: goodsID,
    );
    if (webPage == null) {
      return;
    }

    var shortUrl = await _getShortUrl(webPage);

    String shareDescription = "我在愿望屋发现了好物，你也来看看！";
    if (config.shareDescription != null &&
        config.shareDescription!.isNotEmpty) {
      shareDescription = config.shareDescription!;
    }
    var model = WeChatShareWebPageModel(
      shortUrl,
      title: goodsName,
      description: shareDescription,
      thumbnail: WeChatImage.network(goodsThumbnailUrl),
      scene: scene ?? WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }

  /// 分享个人中心
  static shareUserInfo({
    required String accountId,
    required String nickname,
    required String avatar,
    WeChatScene? scene,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }

    ShareConfig? config = GlobalConfig.userInfoShareConfig;
    if (config == null) {
      return;
    }

    String? webPage = GlobalConfig.userInfoFullShareUrl(
      h5BgImageUrl: config.h5BgImageUrl,
      h5Title: nickname,
      accountId: accountId,
    );
    if (webPage == null) {
      return;
    }
    // print('webPage = $webPage');
    var shortUrl = await _getShortUrl(webPage);

    String shareDescription = "快来愿望屋和我一起玩！";
    if (config.shareDescription != null &&
        config.shareDescription!.isNotEmpty) {
      shareDescription = config.shareDescription!;
    }
    var model = WeChatShareWebPageModel(
      shortUrl,
      title: '@$nickname 这个账号很棒，推荐给你',
      description: shareDescription,
      thumbnail: WeChatImage.network(avatar),
      scene: scene ?? WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }

  /// 分享店铺
  static shareShop({
    required String shopId,
    required String shopName,
    required String icon,
    WeChatScene? scene,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }

    ShareConfig? config = GlobalConfig.shopShareConfig;
    if (config == null) {
      return;
    }

    String? webPage = GlobalConfig.shopShareUrl(
      h5BgImageUrl: config.h5BgImageUrl,
      h5Title: shopName,
      shopId: shopId,
    );
    if (webPage == null) {
      return;
    }
    // print('webPage = $webPage');
    var shortUrl = await _getShortUrl(webPage);

    String shareDescription = "愿望屋的这个店铺不错，推荐给你";
    if (config.shareDescription != null &&
        config.shareDescription!.isNotEmpty) {
      shareDescription = config.shareDescription ?? '';
    }
    var model = WeChatShareWebPageModel(
      shortUrl,
      title: shopName,
      description: shareDescription,
      thumbnail: WeChatImage.network(icon),
      scene: scene ?? WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }

  /// 分享订单详情来进行地址填充
  static shareOrderAddrDetail({
    String? payInfoId,
    String? bizId,
    String? buyerId,
    String? consigneeAccountId,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }

    ShareConfig? config = GlobalConfig.orderAddrDetailShareConfig;
    if (config == null) {
      return;
    }
    String? webPage = GlobalConfig.orderAddrDetailFullShareUrl(
      payInfoId: payInfoId ?? "",
      bizId: bizId ?? "",
      buyerId: buyerId ?? "",
      consigneeAccountId: consigneeAccountId ?? "",
    );
    if (webPage == null) {
      return;
    }
    var shortUrl = await _getShortUrl(webPage);

    var model = WeChatShareWebPageModel(
      shortUrl,
      title: config.shareTitle ?? '',
      description: config.shareDescription,
      thumbnail: WeChatImage.network(config.shareThumbnailUrl ?? ''),
      scene: WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }

  /// 分享待支付的订单(使用于:请TA购买的业务)
  static shareHelpToPayOrder({
    required String wishId,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }

    ShareConfig? config = GlobalConfig.helpToPayOrderShareConfig;
    if (config == null) {
      return;
    }
    String? webPage = GlobalConfig.helpToPayOrderFullShareUrl(
      wishId: wishId,
    );
    if (webPage == null) {
      return;
    }

    var shortUrl = await _getShortUrl(webPage);

    var model = WeChatShareWebPageModel(
      shortUrl,
      title: config.shareTitle ?? '',
      description: config.shareDescription,
      thumbnail: WeChatImage.network(config.shareThumbnailUrl ?? ''),
      scene: WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }

  /// 分享待支付的订单(使用于:众筹购买的业务)
  static crowdToPayOrder({
    required String bizId,
    required String imgUrl,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }
    imgUrl = imgUrl.replaceAll('http:', 'https:');
    ShareConfig? config = GlobalConfig.crowdPayOrderShareConfig;
    if (config == null) {
      return;
    }
    String? webPage = GlobalConfig.crowdToPayOrderFullShareUrl(
      bizId: bizId,
    );
    if (webPage == null) {
      return;
    }
    var shortUrl = await _getShortUrl(webPage);
    var model = WeChatShareWebPageModel(
      shortUrl,
      title: '一起给TA送上好礼',
      description: '距离实现又近了一步',
      thumbnail: WeChatImage.network(imgUrl),
      scene: WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }

  /// 分享邀请好礼(使用于:邀请好礼)
  static shareInvite({
    required String name,
    required String accountId,
    required String avatar,
    required String title,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }

    ShareConfig? config = GlobalConfig.inviteDetailShareConfig;
    if (config == null) {
      return;
    }
    String? webPage = GlobalConfig.inviteDetailFullShareUrl(
      name: name,
      accountId: accountId,
      avatar: avatar,
      title: title,
    );
    if (webPage == null) {
      return;
    }
    var shortUrl = await _getShortUrl(webPage);
    var model = WeChatShareWebPageModel(
      shortUrl,
      title: title,
      description: config.shareDescription,
      thumbnail: WeChatImage.network(config.shareThumbnailUrl ?? ''),
      scene: WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }

  ///豆了个豆邀请好友分享(使用于：豆了个豆游戏邀请分享)
  static shareBeanFullGameInvite({
    required String accountId,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }

    ShareConfig? config = GlobalConfig.beanFullGameInviteShareConfig;
    if (config == null) {
      return;
    }

    String? webPage = GlobalConfig.beanFullGameInviteShareUrl(
      accountId: accountId,
    );
    if (webPage == null) {
      return;
    }
    var shortUrl = await _getShortUrl(webPage);

    var model = WeChatShareWebPageModel(
      shortUrl,
      title: config.shareTitle ?? '',
      description: config.shareDescription,
      thumbnail: WeChatImage.network(config.shareThumbnailUrl ?? ''),
      scene: WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }

  static shareWebPageUrl({
    required String webPage,
    String shareTitle = "",
    String? shareDescription,
    String shareThumbnailUrl = '',
    String shareTo = "WeChatScene.SESSION",
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }
    var shortUrl = await _getShortUrl(webPage);

    WeChatScene scene = WeChatScene.SESSION;
    if (shareTo == "WeChatScene.TIMELINE") {
      scene = WeChatScene.TIMELINE;
    } else if (shareTo == "WeChatScene.FAVORITE") {
      scene = WeChatScene.FAVORITE;
    } else {
      scene = WeChatScene.SESSION;
    }

    var model = WeChatShareWebPageModel(
      shortUrl,
      title: shareTitle,
      description: shareDescription,
      thumbnail: WeChatImage.network(shareThumbnailUrl),
      scene: scene,
    );
    shareToWeChat(model);
  }

  /// 获取短链
  static Future<String> _getShortUrl(String url) async {
    var shortUrl = await _createShortUrl(url);
    return shortUrl;
  }

  /// 获取口令
  // ignore: unused_element
  static Future<String> getWatchWord(String url,
      {String type = "watchword"}) async {
    var watchword = await _createShortUrl(url, type: type);
    return watchword;
  }

  /// 解码口令
  static Future<Map?> decodeWatchWord(String watchWord) async {
    ResponseModel result = await AppNetworkRequestUtil.post(
      "/front-node/short-url/info",
      params: {"watchword": watchWord},
    );
    if (result.isSuccess) {
      return result.result;
    }
    return null;
  }

  /// 创建短链 [type] 默认全文案，shortUrl-短链，watchword-口令
  static Future<String> _createShortUrl(
    String url, {
    String type = "shortUrl",
  }) async {
    ResponseModel result = await AppNetworkRequestUtil.post(
      "/su/createShortUrl",
      params: {"longUrl": url, "type": type},
    );
    if (result.isSuccess) {
      return result.result;
    }
    throw "创建失败";
  }
}
