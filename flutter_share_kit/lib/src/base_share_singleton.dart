/*
 * @Author: dvlproad
 * @Date: 2024-03-07 16:39:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-13 16:44:41
 * @Description: 
 */
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:fluwx/fluwx.dart';

import 'share_dialog_util.dart';
import 'share_util/copylink_share_util.dart';
import 'share_util/poster_share_util.dart';
import 'share_util/wechat_share_util.dart';
import 'widget/share_action_model.dart';

class AppShareTo {
  static int wechat = 1; // 分享到微信
  static int timeline = 2; // 分享到朋友圈
  static int poster = 3; // 海报
  static int copylink = 4; // 分享复制链接
}

abstract class AppShareRequest {
  Future<ShareDataModel?> requestShare({
    String? bizId,
    required int bizType,
    required int shareType,
  });
}

abstract class ShareSingleton implements AppShareRequest {
  /// 弹出常见的分享面板
  void showEasyShareBoard2(
    BuildContext context, {
    GlobalKey? posterRepaintBoundaryGlobalKey,
    bool showCopyLink = false, // 是否显示分享复制链接的入口
    String? bizId,
    required int bizType, // 请使用 AppShareBizType
    String title = "",
    String? description,
    String thumbnail = '',
  }) {
    showEasyShareBoard(
      context,
      posterHandle: posterRepaintBoundaryGlobalKey == null
          ? null
          : () {
              PosterShareUtil.getAndSaveScreensShot(
                context,
                screenRepaintBoundaryGlobalKey: posterRepaintBoundaryGlobalKey,
              ).then((value) {
                Navigator.pop(context);
              });
            },
      showCopyLink: showCopyLink,
      bizId: bizId,
      bizType: bizType,
      title: title,
      description: description,
      thumbnail: thumbnail,
    );
  }

  /// 弹出常见的分享面板
  void showEasyShareBoard(
    BuildContext context, {
    void Function()? posterHandle,
    bool showCopyLink = false, // 是否显示分享复制链接的入口
    String? bizId,
    required int bizType, // 请使用 AppShareBizType
    String title = "",
    String? description,
    String thumbnail = '',
  }) {
    List<BaseActionModel> shareActionModels = [];

    // 私信
    shareActionModels.add(BaseActionModel.im(handle: () {
      Navigator.pop(context);
      ToastUtil.showDoing();
    }));

    // 微信
    shareActionModels.add(BaseActionModel.wechat(handle: () {
      Navigator.pop(context);
      shareToWechatOrTimeline(
        context,
        bizId: bizId,
        bizType: bizType,
        shareType: AppShareTo.wechat,
        title: title,
        description: description,
        thumbnail: thumbnail,
      );
    }));

    // 朋友圈
    shareActionModels.add(BaseActionModel.timeline(handle: () {
      Navigator.pop(context);
      shareToWechatOrTimeline(
        context,
        bizId: bizId,
        bizType: bizType,
        shareType: AppShareTo.timeline,
        title: title,
        description: description,
        thumbnail: thumbnail,
      );
    }));

    // 海报
    if (posterHandle != null) {
      shareActionModels.add(BaseActionModel.poster(handle: () {
        Navigator.pop(context);
        posterHandle();
      }));
    }

    List<BaseActionModel> operateActionModels = [];
    if (showCopyLink) {
      operateActionModels.add(BaseActionModel.copyLink(handle: () {
        shareCopyLink(context, bizId: bizId, bizType: bizType);
      }));
    }

    ShareDialogUtil.show(
      context,
      shareActionModels: shareActionModels,
      operateActionModels: operateActionModels,
    );
  }

  /// 分享微信或者朋友圈
  shareToWechatOrTimeline(
    BuildContext context, {
    String? bizId,
    required int bizType,
    required int shareType,
    String title = "",
    String? description,
    String thumbnail = '',
  }) async {
    ShareDataModel? shareDataModel = await requestShare(
      bizId: bizId,
      bizType: bizType,
      shareType: shareType,
    );
    if (shareDataModel == null) {
      return; // 不需要再toast，上述 request 失败的时候就会内部自动 toast
    }

    if (shareDataModel.landingUrl == null) {
      ToastUtil.showMessage("分享失败");
      return;
    }
    String webPage = shareDataModel.landingUrl!;

    WechatShareUtil.shareWebPageUrl(
      webPage,
      title: title,
      description: description,
      thumbnail: thumbnail.isEmpty
          ? null
          : WeChatImage.network(thumbnail, suffix: ".png"),
      scene: shareType == AppShareTo.timeline
          ? WeChatScene.TIMELINE
          : WeChatScene.SESSION,
    );
  }

  /// 分享复制链接
  shareCopyLink(
    BuildContext context, {
    String? bizId,
    required int bizType,
  }) async {
    ShareDataModel? shareDataModel = await requestShare(
      bizId: bizId,
      bizType: bizType,
      shareType: AppShareTo.copylink,
    );
    if (shareDataModel == null) {
      return; // 不需要再toast，上述 request 失败的时候就会内部自动 toast
    }

    if (shareDataModel.landingUrl == null) {
      ToastUtil.showMessage("复制链接失败");
      return;
    }
    String webPage = shareDataModel.landingUrl!;

    CopyLinkShareUtil.copyLink(context, lastShareString: webPage);
  }
}

class ShareDataModel {
  final String? landingUrl;
  final String? qrCode;
  final String? paramContent;

  ShareDataModel({
    this.landingUrl,
    this.qrCode,
    this.paramContent,
  });
}
