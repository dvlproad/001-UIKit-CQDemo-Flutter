/*
 * @Author: dvlproad
 * @Date: 2024-03-07 16:39:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-15 18:32:22
 * @Description: 
 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_share_kit/flutter_share_kit.dart';

class TSAppShareBizType {
  static int content = 0; // 分享内容
  static int dynamics = 1; // 分享动态
  static int improveResult = 2; // 完善结果页的分享
}

class TSAppShareSingleton extends ShareSingleton {
  TSAppShareSingleton._();
  static final TSAppShareSingleton _instance = TSAppShareSingleton._();
  factory TSAppShareSingleton() => _instance;

  @override
  void showUIByModel(
    BuildContext context, {
    required List<BaseActionModel> shareActionModels,
    List<BaseActionModel>? operateActionModels,
  }) {
    ShareDialogUtil.show(
      context,
      shareActionModels: shareActionModels,
      operateActionModels: operateActionModels,
    );
  }

  @override
  Future<ShareDataModel?> requestShare({
    String? bizId,
    required int bizType,
    required int shareType,
  }) async {
    Map<String, dynamic> resultMap = {
      "landingUrl": "https://www.baidu.com",
    };
    ShareDataModel shareDataModel = ShareDataModel(
      landingUrl: resultMap['landingUrl'],
      title: resultMap['title'],
      description: resultMap['description'],
      thumbnailUrl: resultMap['thumbnailUrl'],
      qrCode: resultMap['qrCode'],
      paramContent: resultMap['paramContent'],
    );
    return shareDataModel;
  }

  @override
  void report(BuildContext context, {String? bizId, required int bizType}) {
    ToastUtil.showMessage("进入举报页面:bizId=$bizId, bizType=$bizType");
  }

  /// 弹出常见的分享面板(+海报根据key快捷获取)
  void showQuickPosterEasyShareBoard(
    BuildContext context, {
    GlobalKey? posterRepaintBoundaryGlobalKey,
    bool showCopyLink = false, // 是否显示分享复制链接的入口

    String? bizId,
    required int bizType, // 请使用 AppShareBizType
    String? title,
    String? description,
    WeChatImage? thumbnailImage,
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
      thumbnailImage: thumbnailImage,
    );
  }
}
