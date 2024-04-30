// ignore_for_file: non_constant_identifier_names, camel_case_extensions

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 19:25:57
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-29 19:30:33
 * @Description: 
 */
// import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

/// 添加JSChannel
extension AddJSChannel_Share on WebViewController {
  /*
  /// 分享内容到指定的分享方式(微信聊天页面等)
  cjjs_commonShareJsChannel({
    required void Function(
      String webPage, {
      String? title,
      String? description,
      String? thumbnail,
      String? scene,
    })
        shareWebPageUrlHandle,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_share',
      onMessageReceived: (JavaScriptMessage message) {
        Map map = json.decode(message.message);
        String webPageUrl = map["shareWebPageUrl"];
        String shareTitle = map["shareTitle"];
        String? shareDescription = map["shareDescription"];
        String shareThumbnailUrl = map["shareThumbnailUrl"];
        String shareTo = map["shareTo"];

        shareWebPageUrlHandle(
          webPageUrl,
          title: shareTitle,
          description: shareDescription,
          thumbnail: shareThumbnailUrl,
          scene: shareTo,
        );
      },
    );
  }

  /// 分享到微信
  /// [type] text-文字 image-图片 webPage-网页
  /// [source] 当[type]为text时，source为文字内容 当[type]为image时，source为图片地址 当[type]为webPage时，source为网页地址
  /// [thumbnail] 缩略图地址 当[type]为image时，thumbnail为图片地址 当[type]为webPage时，thumbnail为网页缩略logo地址
  cjjs_shareToWeChat({
    required void Function(
      String type,
      String source, {
      String? thumbnail,
      String? title,
    })
        shareToWechatHandle,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_shareToWeChat',
      onMessageReceived: (JavaScriptMessage message) {
        Map<String, dynamic>? map = json.decode(message.message.toString());
        if (map == null) {
          return;
        }
        var contentType = map["contentType"];
        var source = map['source'];
        var thumbnail = map['thumbnail'];
        var title = map['title'];
        shareToWechatHandle(
          contentType,
          source,
          thumbnail: thumbnail,
          title: title,
        );
      },
    );
  }
  */
}
