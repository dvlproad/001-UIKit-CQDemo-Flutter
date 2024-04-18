/*
 * @Author: dvlproad
 * @Date: 2024-03-12 18:26:56
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-18 11:25:22
 * @Description: 分享复制链接的工具类
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base_share_singleton.dart';
import './wechat_share_util.dart';

class CopyLinkShareUtil {
  static copyLink(
    BuildContext context, {
    bool needCallPopPage = true, // 是否调用退出页面的操作(一般用于关闭分享面板)
    required String lastShareString, // 最后分享的文本
  }) async {
    // BaseShareSingleton.loadingShowHandle?.call();
    Clipboard.setData(ClipboardData(text: lastShareString));

    if (needCallPopPage) {
      Navigator.pop(context); // 复制完之后退出当前页
    }

    /*
    AlertUtil.showCancelOKAlert(
      context: context,
      title: "已复制到粘贴板",
      message: "快去分享给好友吧!\n",
      cancelTitle: "好的",
      okTitle: "去微信分享",
      okHandle: () {
        WechatShareUtil.shareText(lastShareString);
      },
    );
    */
    BaseShareSingleton.copySuccessHandle?.call(
      context,
      lastShareString: lastShareString,
      okHandle: () {
        WechatShareUtil.shareText(lastShareString);
      },
    );
  }
}
