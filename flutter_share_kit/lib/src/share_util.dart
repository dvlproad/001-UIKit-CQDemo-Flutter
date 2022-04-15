import 'package:meta/meta.dart'; // 为了使用 @required
import 'package:fluwx/fluwx.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:app_global_config/app_global_config.dart';

import '../flutter_share_kit_adapt.dart';

class ShareUtil {
  // shareToWechat({
  //   String webUrl,
  //   Map<String, dynamic> params,
  // }) {
  //   webUrl ??= 'http://dev.h5.xxx.com/#/pages-h5/share/share';

  //   if (!webUrl.contains("?")) {
  //     webUrl += "?";
  //   }
  // }

  /// 分享愿望单详情
  static shareWishDetail({
    @required String wishID,
    @required String buyerId,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }

    ShareConfig config = GlobalConfig.wishDetailShareConfig;
    String webPage = GlobalConfig.wishDetailFullShareUrl(
      wishID: wishID,
      buyerId: buyerId,
    );
    var model = WeChatShareWebPageModel(
      webPage,
      title: config.shareTitle,
      description: config.shareDescription,
      thumbnail: WeChatImage.network(config.shareThumbnailUrl),
      scene: WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }

  /// 分享商品详情
  static shareGoodsDetail({
    @required String h5Title,
    @required String goodsID,
    @required String goodsName,
    @required String goodsThumbnailUrl,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }

    ShareConfig config = GlobalConfig.goodsDetailShareConfig;

    String webPage = GlobalConfig.goodsDetailFullShareUrl(
      h5BgImageUrl: config.h5BgImageUrl,
      h5Title: h5Title,
      goodsID: goodsID,
    );

    String shareDescription = "我在愿望屋发现了好物，你也来看看！";
    if (config.shareDescription != null && config.shareDescription.isNotEmpty) {
      shareDescription = config.shareDescription;
    }
    var model = WeChatShareWebPageModel(
      webPage,
      title: goodsName,
      description: shareDescription,
      thumbnail: WeChatImage.network(goodsThumbnailUrl),
      scene: WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }

  /// 分享订单详情来进行地址填充
  static shareOrderAddrDetail({
    @required String payInfoId,
    @required String bizId,
    @required String buyerId,
    @required String consigneeAccountId,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.showMessage("未安装微信");
      return;
    }

    ShareConfig config = GlobalConfig.orderAddrDetailShareConfig;
    String webPage = GlobalConfig.orderAddrDetailFullShareUrl(
      payInfoId: payInfoId ?? "",
      bizId: bizId ?? "",
      buyerId: buyerId ?? "",
      consigneeAccountId: consigneeAccountId ?? "",
    );
    var model = WeChatShareWebPageModel(
      webPage,
      title: config.shareTitle,
      description: config.shareDescription,
      thumbnail: WeChatImage.network(config.shareThumbnailUrl),
      scene: WeChatScene.SESSION,
    );
    shareToWeChat(model);
  }
}
