import 'package:fluwx/fluwx.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

class WechatShareUtil {
  /// 分享到微信
  /// [type] text-文字 image-图片 webPage-网页
  /// [source] 当[type]为text时，source为文字内容 当[type]为image时，source为图片地址 当[type]为webPage时，source为网页地址
  /// [thumbnail] 缩略图地址 当[type]为image时，thumbnail为图片地址 当[type]为webPage时，thumbnail为网页缩略logo地址
  static shareToWechat(
    String type,
    String source, {
    String? thumbnail,
    String title = "",
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.forceShowMessage("未安装微信");
      return;
    }
    WeChatShareBaseModel? shareModel;
    if (type == "TEXT") {
      shareModel = WeChatShareTextModel(source);
    } else if (type == "IMAGE") {
      var image = WeChatImage.network(source);
      var thumb = thumbnail != null ? WeChatImage.network(thumbnail) : null;
      shareModel = WeChatShareImageModel(image, thumbnail: thumb, title: title);
    } else if (type == "WEBPAGE") {
      var thumb = thumbnail != null ? WeChatImage.network(thumbnail) : null;
      shareModel =
          WeChatShareWebPageModel(source, thumbnail: thumb, title: title);
    }
    if (shareModel != null) {
      shareToWeChat(shareModel);
    }
  }

  static shareWebPageUrl(
    String webPage, {
    String title = "",
    String? description,
    String thumbnail = '',
    String scene = "WeChatScene.SESSION",
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.forceShowMessage("未安装微信");
      return;
    }

    WeChatScene shareTo = WeChatScene.SESSION;
    if (scene == "WeChatScene.TIMELINE") {
      shareTo = WeChatScene.TIMELINE;
    } else if (scene == "WeChatScene.FAVORITE") {
      shareTo = WeChatScene.FAVORITE;
    } else {
      shareTo = WeChatScene.SESSION;
    }

    var model = WeChatShareWebPageModel(
      webPage,
      title: title,
      description: description,
      thumbnail: WeChatImage.network(thumbnail, suffix: ".png"),
      scene: shareTo,
    );
    shareToWeChat(model);
  }

  /// H5分享图片
  /// [weChatImage] 图片数据
  /// [shareTo] 分享渠道
  static shareH5ImageByWeChatImage(
    WeChatImage weChatImage, {
    required WeChatScene scene,
    String shareTitle = '',
    String? shareDescription,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.forceShowMessage("未安装微信");
      return;
    }

    final weChatShareImageModel = WeChatShareImageModel(
      weChatImage,
      scene: scene,
      description: shareDescription,
      title: shareTitle,
    );
    shareToWeChat(weChatShareImageModel);
  }

  /// H5分享视频
  /// [videoUrl] 图片链接
  /// [shareTo] 分享渠道
  static shareH5Video({
    required String videoUrl,
    String? videoLowBandUrl,
    String? thumbnail,
    String shareTo = "WeChatScene.SESSION",
    String shareTitle = '',
    String? shareDescription,
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.forceShowMessage("未安装微信");
      return;
    }
    WeChatScene scene = WeChatScene.SESSION;
    if (shareTo == "WeChatScene.TIMELINE") {
      scene = WeChatScene.TIMELINE;
    } else if (shareTo == "WeChatScene.FAVORITE") {
      scene = WeChatScene.FAVORITE;
    } else {
      scene = WeChatScene.SESSION;
    }
    final weChatShareVideoModel = WeChatShareVideoModel(
      scene: scene,
      videoUrl: videoUrl,
      videoLowBandUrl: videoLowBandUrl,
      description: shareDescription,
      thumbnail: WeChatImage.network(thumbnail ?? ""),
      title: shareTitle,
    );
    shareToWeChat(weChatShareVideoModel);
  }

  /// 分享小程序
  /// [imageUrl] 图片链接
  /// [shareTo] 分享渠道
  static shareMiniProgram({
    required String path,
    required String userName,
    required String thumbnail,
    String webPageUrl = "",
    String title = "",
    String description = "",
  }) async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.forceShowMessage("未安装微信");
      return;
    }
    final wechatShareMiniProgramModel = WeChatShareMiniProgramModel(
      webPageUrl: webPageUrl,
      path: path,
      title: title,
      description: description,
      userName: userName,
      thumbnail: WeChatImage.network(thumbnail),
    );
    shareToWeChat(wechatShareMiniProgramModel);
  }
}
