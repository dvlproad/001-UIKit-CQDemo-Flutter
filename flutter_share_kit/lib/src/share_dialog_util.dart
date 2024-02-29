/*
 * @Author: dvlproad
 * @Date: 2024-02-28 13:47:54
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-28 15:50:20
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import 'share_action_model.dart';
import 'share_dialog_widget.dart';

class ShareDialogUtil {
  /*
  // 示例
  _clickShare() {
    ShareDialogUtil.show(
      context,
      shareActionModels: [
        ShareActionFactory.imActionModel(context, handle: () {
          ToastUtil.showDoing();
        }),
        ShareActionFactory.wechatActionModel(context, "webPage"),
        ShareActionFactory.timelineActionModel(context, "webPage"),
        ShareActionFactory.posterActionModel(
          context,
          contentWidgetGetBlock: () {
            return Container(color: Colors.green);
          },
        ),
      ],
      operateActionModels: [
        ShareActionFactory.copyLinkActionModel(
          context,
          getShareTextBlock: () async {
            return Future.value("abc");
          },
        ),
      ],
    );
  }
  */

  static show(
    BuildContext context, {
    required List<BaseActionModel> shareActionModels,
    List<BaseActionModel>? operateActionModels,
  }) {
    // BuriedPointManager().addEvent(
    //   "click_share",
    //   {
    //     "position": "live",
    //     "liveId": _liveProvider.liveDetail?.id,
    //   },
    // );
    PopupUtil.popupInBottom(
      context,
      popupViewBulider: (context) {
        return ShareDialogWidget(
          shareActionModels: shareActionModels,
          operateActionModels: operateActionModels,
        );
      },
    );
  }
}
