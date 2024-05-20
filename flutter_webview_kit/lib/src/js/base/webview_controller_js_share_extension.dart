// ignore_for_file: non_constant_identifier_names, camel_case_extensions

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 19:25:57
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-20 10:47:01
 * @Description: 分享(TEXT文本、IMAGE图片地址、VIDEO视频地址、WEBPAGE网页链接)到微信
 */
// import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

// import '../../js_add_check_run/h5_call_bridge_response_model.dart';
import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

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

  cjjs_share({
    required void Function(String? shareTo, String? shareContentSource)
        shareTextHandle, // 分享文本
    required void Function(
            String? shareTo,
            String? shareContentSource,
            String? shareTitle,
            String? shareDescription,
            String? shareThumbnailUrl)
        shareImageUrlHandle, // 分享图片 Url
    required void Function(
            String? shareTo,
            String? shareContentSource,
            String? shareTitle,
            String? shareDescription,
            String? shareThumbnailUrl)
        shareImageBase64Handle, // 分享图片 base64 (避免网页要保存海报，还得先上传网络得到地址后才能分享)
    required void Function(
            String? shareTo,
            String? shareContentSource,
            String? shareTitle,
            String? shareDescription,
            String? shareThumbnailUrl)
        shareVideoHandle, // 分享视频
    required void Function(
            String? shareTo,
            String? shareContentSource,
            String? shareTitle,
            String? shareDescription,
            String? shareThumbnailUrl)
        shareWebPageHandle, // 分享视频
  }) {
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_share_TEXT',
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? shareTo = h5Params?["shareTo"];
        String? shareContentSource = h5Params?["shareContentSource"];
        shareTextHandle(shareTo, shareContentSource);
      },
    );
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_share_IMAGE_url',
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? shareTo = h5Params?["shareTo"];
        String? shareContentSource = h5Params?["shareContentSource"];
        String? shareTitle = h5Params?["shareTitle"];
        String? shareDescription = h5Params?["shareDescription"];
        String? shareThumbnailUrl = h5Params?["shareThumbnailUrl"];
        shareImageUrlHandle(shareTo, shareContentSource, shareTitle,
            shareDescription, shareThumbnailUrl);
      },
    );
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_share_IMAGE_base64',
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? shareTo = h5Params?["shareTo"];
        String? shareContentSource = h5Params?["shareContentSource"];
        String? shareTitle = h5Params?["shareTitle"];
        String? shareDescription = h5Params?["shareDescription"];
        String? shareThumbnailUrl = h5Params?["shareThumbnailUrl"];
        shareImageBase64Handle(shareTo, shareContentSource, shareTitle,
            shareDescription, shareThumbnailUrl);
      },
    );
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_share_VIDEO',
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? shareTo = h5Params?["shareTo"];
        String? shareContentSource = h5Params?["shareContentSource"];
        String? shareTitle = h5Params?["shareTitle"];
        String? shareDescription = h5Params?["shareDescription"];
        String? shareThumbnailUrl = h5Params?["shareThumbnailUrl"];
        shareVideoHandle(shareTo, shareContentSource, shareTitle,
            shareDescription, shareThumbnailUrl);
      },
    );
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_share_WEBPAGE',
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? shareTo = h5Params?["shareTo"];
        String? shareContentSource = h5Params?["shareContentSource"];
        String? shareTitle = h5Params?["shareTitle"];
        String? shareDescription = h5Params?["shareDescription"];
        String? shareThumbnailUrl = h5Params?["shareThumbnailUrl"];
        shareWebPageHandle(shareTo, shareContentSource, shareTitle,
            shareDescription, shareThumbnailUrl);
      },
    );
  }
}
