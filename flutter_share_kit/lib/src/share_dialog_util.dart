/*
 * @Author: dvlproad
 * @Date: 2024-02-28 13:47:54
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-08 17:09:32
 * @Description: 分享面板弹出方法。（使用示例 参见 TSShareHomePage 类中的 ShareDialogUtil.show 调用)
 */
import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import 'widget/share_action_model.dart';
import 'widget/share_dialog_widget.dart';

class ShareDialogUtil {
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
