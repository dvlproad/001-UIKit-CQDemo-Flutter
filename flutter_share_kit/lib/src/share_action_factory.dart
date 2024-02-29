import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
// import 'package:flutter_effect_kit/flutter_effect_kit.dart';

import 'package:fluwx/fluwx.dart';

import './share_action_model.dart';
import './share_util.dart';
import './share_poster_widget.dart';

class ShareActionFactory {
  static BaseActionModel imActionModel(BuildContext context,
      {required Function() handle}) {
    return BaseActionModel(
      imageName: 'assets/share_im.png',
      imagePackage: "flutter_share_kit",
      title: '私信',
      handle: () {
        Navigator.pop(context);
        handle();
      },
    );
  }

  static BaseActionModel wechatActionModel(
    BuildContext context,
    String webPage, {
    String title = "",
    String? description,
    String thumbnail = '',
  }) {
    return BaseActionModel(
      imageName: 'assets/share_wechat.png',
      imagePackage: "flutter_share_kit",
      title: '微信',
      handle: () {
        Navigator.pop(context);
        ShareUtil.shareWebPageUrl(
          webPage,
          title: title,
          description: description,
          thumbnail: thumbnail,
          scene: "WeChatScene.SESSION",
        );
      },
    );
  }

  static BaseActionModel timelineActionModel(
    BuildContext context,
    String webPage, {
    String title = "",
    String? description,
    String thumbnail = '',
  }) {
    return BaseActionModel(
      imageName: 'assets/share_timeline.png',
      imagePackage: "flutter_share_kit",
      title: '朋友圈',
      handle: () {
        Navigator.pop(context);
        ShareUtil.shareWebPageUrl(
          webPage,
          title: title,
          description: description,
          thumbnail: thumbnail,
          scene: "WeChatScene.TIMELINE",
        );
      },
    );
  }

  static BaseActionModel posterActionModel(
    BuildContext context, {
    required Widget Function() contentWidgetGetBlock,
  }) {
    return BaseActionModel(
      imageName: 'assets/share_poster.png',
      imagePackage: "flutter_share_kit",
      title: '生成海报',
      handle: () {
        Navigator.pop(context);

        PopupUtil.popupInBottom(
          context,
          popupViewBulider: (context) {
            return SharePosterWidget(
              contentWidgetGetBlock: contentWidgetGetBlock,
            );
          },
        );

        // handle();
      },
    );
  }

  static BaseActionModel copyLinkActionModel(
    BuildContext context, {
    required Future<String> Function() getShareTextBlock,
  }) {
    return BaseActionModel(
      imageName: 'assets/copy_link.png',
      imagePackage: "flutter_share_kit",
      title: '复制链接',
      titleColor: const Color(0xffA3A3A3),
      handle: () async {
        // LoadingUtil.show();
        String shareString = await getShareTextBlock();
        Clipboard.setData(ClipboardData(text: shareString));

        Navigator.pop(context);

        AlertUtil.showCancelOKAlert(
          context: context,
          title: "已复制到粘贴板",
          message: "快去分享给好友吧!\n",
          cancelTitle: "好的",
          okTitle: "去微信分享",
          okHandle: () async {
            shareToWeChat(
              WeChatShareTextModel(
                shareString,
                scene: WeChatScene.SESSION,
              ),
            );
          },
        );
      },
    );
  }

  static BaseActionModel reportActionModel(BuildContext context,
      {required Function() handle}) {
    return BaseActionModel(
      imageName: 'assets/report.png',
      imagePackage: "flutter_share_kit",
      title: '举报',
      titleColor: const Color(0xffA3A3A3),
      handle: () {
        Navigator.pop(context);
        handle();
      },
    );
  }

  static BaseActionModel editMeansActionModel(BuildContext context,
      {required Function() handle}) {
    return BaseActionModel(
      imageName: 'assets/edit_means_icon.png',
      imagePackage: "flutter_share_kit",
      title: '编辑资料',
      titleColor: const Color(0xffA3A3A3),
      handle: () {
        Navigator.pop(context);
        handle();
      },
    );
  }

  static BaseActionModel blockActionModel(
    BuildContext context, {
    required bool isBlock,
    required Function() handle,
  }) {
    return BaseActionModel(
      imageName: !isBlock ? 'assets/block.png' : 'assets/block_cancel.png',
      imagePackage: "flutter_share_kit",
      title: !isBlock ? '拉黑' : '取消拉黑',
      titleColor: const Color(0xffA3A3A3),
      handle: () {
        Navigator.pop(context);
        handle();
      },
    );
  }
}
