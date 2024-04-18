/*
 * @Author: dvlproad
 * @Date: 2024-03-07 16:39:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-18 11:40:31
 * @Description: 
 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_share_kit/flutter_share_kit.dart';

class TSAppShareBizType {
  static int content = 0; // 分享内容
  static int dynamics = 1; // 分享动态
  static int improveResult = 2; // 完善结果页的分享
}

class TSAppShareSingleton extends BaseShareSingleton {
  TSAppShareSingleton._() {
    BaseShareSingleton.placeholderImageName = 'images/common/placeholder.png';
    /*
    BaseShareSingleton.loadingShowHandle = () {
      LoadingUtil.show();
    };
    BaseShareSingleton.loadingDismissHandle = () {
      LoadingUtil.dismiss();
    };
    BaseShareSingleton.toastHandle = (message) {
      ToastUtil.showMessage(message);
    };
    BaseShareSingleton.copySuccessHandle = (BuildContext context,
        {required String lastShareString, required void Function() okHandle}) {
      AlertUtil.showCancelOKAlert(
        context: context,
        title: "已复制到粘贴板",
        message: "快去分享给好友吧!\n",
        cancelTitle: "好的",
        okTitle: "去微信分享",
        okHandle: okHandle,
      );
    };
    BaseShareSingleton.checkStoragePermissionHandle = () async {
      bool isGranted = await PermissionsManager.storage();
      return isGranted;
    };
    */
  }
  static final TSAppShareSingleton _instance = TSAppShareSingleton._();
  factory TSAppShareSingleton() => _instance;

  @override
  void showUIByModel(
    BuildContext context, {
    required List<BaseActionModel> shareActionModels,
    List<BaseActionModel>? operateActionModels,
  }) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      // useSafeArea: false, // 要设成false，否则底部有间隙
      // backgroundColor: Colors.black.withOpacity(0.3),
      backgroundColor: Colors.transparent,
      // 背景色
      // barrierColor: Colors.blue, // 遮盖背景颜色
      isScrollControlled: true,
      // 解决 showDialog/showModalBottomSheet时高度限制问题
      builder: (BuildContext context) {
        return ShareDialogWidget(
          shareActionModels: shareActionModels,
          operateActionModels: operateActionModels,
        );
      },
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
  void report(BuildContext context,
      {String? bizId, required int bizType, required String bizOwnerId}) {
    BaseShareSingleton.toastHandle
        ?.call("进入举报页面:bizId=$bizId, bizType=$bizType, bizOwnerId=$bizOwnerId");
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
