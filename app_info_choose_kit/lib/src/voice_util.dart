/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-14 21:00:04
 * @Description: 语音工具
 */
import 'dart:async';
import 'dart:math';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:wish/tool/sound_dialog_view_new.dart';
import './voice_bean.dart';
export './voice_bean.dart';

class VoiceUtil {
  static Future<bool> addVoice(
    BuildContext context, {
    @required void Function(VoiceBean bVoiceBean) valueChangeBlock,
  }) async {
    // [Flutter等待异步内容](https://blog.csdn.net/weixin_41735943/article/details/119168792?utm_medium=distribute.pc_aggpage_search_result.none-task-blog-2~aggregatepage~first_rank_ecpm_v1~rank_v31_ecpm-1-119168792.pc_agg_new_rank&utm_term=flutter等待执行&spm=1000.2123.3001.4430)
    Completer c = Completer<bool>();

    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      enableDrag: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SoundDialogViewNewPage(
          onClick: (filePath, timeTxt, timeInt) {
            if (filePath != null && filePath.isNotEmpty) {
              int voiceSeconds = timeInt.toInt();
              voiceSeconds = max(voiceSeconds, 1);

              VoiceBean voiceBean = VoiceBean();
              voiceBean.localPath = filePath;
              voiceBean.timeInt = voiceSeconds;
              voiceBean.recorderTxt = timeTxt;

              // if (voiceSeconds < 1) {
              //   ToastUtil.showMessage('语音太短');
              //   c.complete(false);
              //   return;
              // }

              if (valueChangeBlock != null) {
                valueChangeBlock(voiceBean);
              }

              c.complete(true);
            } else {
              c.complete(false);
            }
          },
        );
      },
    );

    return c.future;
  }

  static void clearVoice(
    BuildContext context, {
    @required void Function(VoiceBean bVoiceBean) valueChangeBlock,
  }) {
    BrnDialogManager.showConfirmDialog(
      context,
      title: "提醒",
      cancel: "取消",
      confirm: "确定",
      message: "你确定清空语音吗？",
      onConfirm: () {
        Navigator.of(context).pop();
        Singleton.instance.stopPlayer().then((value) {
          if (valueChangeBlock != null) {
            valueChangeBlock(null);
          }
        });
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }
}
