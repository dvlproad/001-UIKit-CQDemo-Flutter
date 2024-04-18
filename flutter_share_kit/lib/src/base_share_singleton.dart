/*
 * @Author: dvlproad
 * @Date: 2024-03-07 16:39:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-18 11:36:54
 * @Description: 
 */
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:fluwx/fluwx.dart';

import 'share_util/copylink_share_util.dart';
// import 'share_util/poster_share_util.dart';
import 'share_util/wechat_share_util.dart';
import 'widget/share_action_model.dart';

class AppShareTo {
  static int wechat = 1; // 分享到微信
  static int timeline = 2; // 分享到朋友圈
  static int poster = 3; // 海报
  static int copylink = 4; // 分享复制链接
}

abstract class AppShareShow {
  /// 展示UI
  void showUIByModel(
    BuildContext context, {
    required List<BaseActionModel> shareActionModels,
    List<BaseActionModel>? operateActionModels,
  });
}

abstract class AppShareRequest {
  /// 请求分享的信息
  Future<ShareDataModel?> requestShare({
    String? bizId,
    required int bizType,
    required int shareType,
  });
}

abstract class AppShareHandel {
  /// 举报 的事件
  void report(BuildContext context,
      {String? bizId, required int bizType, required String bizOwnerId});

  // /// 拉黑/取消拉黑 的事件(不需要，而是直接传model,因为拉黑操作结束需要更新isBlock)
  // void block(BuildContext context, {String? bizId, required int bizType});
}

abstract class BaseShareSingleton
    implements AppShareShow, AppShareRequest, AppShareHandel {
  static String? placeholderImageName; // 图片加载失败的占位图
  static void Function()? loadingShowHandle;
  static void Function()? loadingDismissHandle;
  static void Function(String message)? toastHandle;
  static void Function(BuildContext context,
      {required String lastShareString,
      required void Function() okHandle})? copySuccessHandle;
  static Future<bool> Function()? checkStoragePermissionHandle;

  /// 弹出常见的分享面板
  void showEasyShareBoard(
    BuildContext context, {
    void Function()? imHandle,
    void Function()? posterHandle,
    bool showCopyLink = false, // 是否显示分享复制链接的入口
    bool showReport = false, // 是否显示举报的入口
    BaseActionModel? blockModel, // 是否显示拉黑的入口，操作完需要刷新bool值
    String? bizId,
    required int bizType, // 请使用 AppShareBizType
    String? bizOwnerId,
    String? title,
    String? description,
    WeChatImage? thumbnailImage,
  }) {
    List<BaseActionModel> shareActionModels = [];

    // 私信
    if (imHandle != null) {
      shareActionModels.add(BaseActionModel.im(handle: () {
        Navigator.pop(context);
        imHandle();
      }));
    }

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
        thumbnailImage: thumbnailImage,
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
        thumbnailImage: thumbnailImage,
      );
    }));

    // 海报
    if (posterHandle != null) {
      shareActionModels.add(BaseActionModel.poster(handle: () {
        Navigator.pop(context);
        posterHandle();
      }));
    }

    // 复制链接
    List<BaseActionModel> operateActionModels = [];
    if (showCopyLink) {
      operateActionModels.add(BaseActionModel.copyLink(handle: () {
        shareCopyLink(context, bizId: bizId, bizType: bizType);
      }));
    }

    // 举报
    if (showReport) {
      operateActionModels.add(BaseActionModel.report(handle: () {
        Navigator.pop(context);
        if (bizOwnerId == null) {
          BaseShareSingleton.toastHandle?.call("举报时候不能缺少 bizOwnerId");
          return;
        }
        report(context, bizId: bizId, bizType: bizType, bizOwnerId: bizOwnerId);
      }));
    }

    // 拉黑
    if (blockModel != null) {
      operateActionModels.add(blockModel);
    }

    showUIByModel(
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
    String? title,
    String? description,
    WeChatImage? thumbnailImage,
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
      BaseShareSingleton.toastHandle?.call("分享失败");
      return;
    }
    String webPage = shareDataModel.landingUrl!;

    WeChatImage? remoteWechatImage;
    String? thumbnailUrl = shareDataModel.thumbnailUrl;
    if (thumbnailUrl != null) {
      remoteWechatImage = WeChatImage.network(thumbnailUrl, suffix: ".png");
    }

    WechatShareUtil.shareWebPageUrl(
      webPage,
      title: shareDataModel.title ?? title,
      description: shareDataModel.description ?? description,
      thumbnail: remoteWechatImage ?? thumbnailImage,
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
      BaseShareSingleton.toastHandle?.call("复制链接失败");
      return;
    }
    String webPage = shareDataModel.landingUrl!;

    CopyLinkShareUtil.copyLink(context, lastShareString: webPage);
  }
}

class ShareDataModel {
  final String? landingUrl;
  final String? title;
  final String? description;
  final String? thumbnailUrl;
  final String? qrCode;
  final String? paramContent;

  ShareDataModel({
    this.landingUrl,
    this.title,
    this.description,
    this.thumbnailUrl, // 图片地址
    this.qrCode,
    this.paramContent,
  });
}
