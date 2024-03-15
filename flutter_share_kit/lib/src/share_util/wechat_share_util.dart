import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fluwx/fluwx.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

class WechatShareUtil {
  /// 检查是否可以进行分享(若不行，则弹出对应提示)
  static Future<bool> get checkWeChatInstalled async {
    var isInstalled = await isWeChatInstalled;
    if (!isInstalled) {
      ToastUtil.forceShowMessage("未安装微信");
      return false;
    }
    return true;
  }

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
    if (!await checkWeChatInstalled) return;

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
    String? title,
    String? description,
    WeChatImage? thumbnail,
    required WeChatScene scene,
  }) async {
    if (!await checkWeChatInstalled) return;

    // print("title=$title ,description=$description, thumbnail=$thumbnail");
    var model = WeChatShareWebPageModel(
      webPage,
      title: title ?? "",
      description: description,
      thumbnail: thumbnail,
      scene: scene,
    );
    shareToWeChat(model);
  }

  static shareText(
    String lastShareString, {
    WeChatScene scene = WeChatScene.SESSION,
  }) async {
    if (!await checkWeChatInstalled) return;

    var model = WeChatShareTextModel(
      lastShareString,
      scene: scene,
    );
    shareToWeChat(model);
  }

  /// H5分享图片(常用于绘制的海报数据)
  /// [image] 图片数据
  /// [scene] 分享渠道
  static shareH5ImageByUIImage(
    ui.Image image, {
    required WeChatScene scene,
    String shareTitle = '',
    String? shareDescription,
  }) async {
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      ToastUtil.showMessage("海报绘制出错21");
      return false;
    }

    Uint8List pngBytes = byteData.buffer.asUint8List(); // 图片byte数据转化unit8
    WeChatImage weChatImage = WeChatImage.binary(Uint8List.fromList(pngBytes));
    shareH5ImageByWeChatImage(
      weChatImage,
      scene: scene,
      shareTitle: shareTitle,
      shareDescription: shareDescription,
    );
  }

  /// H5分享图片
  /// [weChatImage] 图片数据
  /// [scene] 分享渠道
  static shareH5ImageByWeChatImage(
    WeChatImage weChatImage, {
    required WeChatScene scene,
    String shareTitle = '',
    String? shareDescription,
  }) async {
    if (!await checkWeChatInstalled) return;

    final weChatShareImageModel = WeChatShareImageModel(
      weChatImage,
      scene: scene,
      title: shareTitle,
      description: shareDescription,
    );
    shareToWeChat(weChatShareImageModel);
  }

  /// H5分享视频
  /// [videoUrl] 图片链接
  /// [scene] 分享渠道
  static shareH5Video({
    required String videoUrl,
    String? videoLowBandUrl,
    WeChatImage? thumbnail,
    required WeChatScene scene,
    String shareTitle = '',
    String? shareDescription,
  }) async {
    if (!await checkWeChatInstalled) return;

    final weChatShareVideoModel = WeChatShareVideoModel(
      scene: scene,
      videoUrl: videoUrl,
      videoLowBandUrl: videoLowBandUrl,
      description: shareDescription,
      thumbnail: thumbnail,
      title: shareTitle,
    );
    shareToWeChat(weChatShareVideoModel);
  }

  /// 分享小程序
  /// [path] 小程序
  static shareMiniProgram({
    required String path,
    required String userName,
    required WeChatImage thumbnail,
    String webPageUrl = "",
    String title = "",
    String description = "",
  }) async {
    if (!await checkWeChatInstalled) return;

    final wechatShareMiniProgramModel = WeChatShareMiniProgramModel(
      webPageUrl: webPageUrl,
      path: path,
      title: title,
      description: description,
      userName: userName,
      thumbnail: thumbnail,
    );
    shareToWeChat(wechatShareMiniProgramModel);
  }
}
