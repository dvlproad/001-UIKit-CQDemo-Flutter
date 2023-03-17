/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-28 16:28:38
 * @Description: 日志
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './popup_logview_manager.dart';
import './log_data_bean.dart';

import './dev_log_toast_util.dart';

class DevLogUtil {
  static List<LogModel> logModels = [];
  static bool isLogShowing = false;

  static showLogView({
    void Function()? onPressedCloseCompleteBlock,
  }) {
    DevLogUtil.isLogShowing = true;

    // MediaQuery.of(context).size.width  屏幕宽度
    // MediaQuery.of(context).size.height 屏幕高度
    ApplicationLogViewManager.showLogListOverlayEntry(
      opacity: 1.0,
      logModels: logModels,
      clickLogCellCallback: ({
        required LogModel bLogModel,
        required BuildContext context,
        int? row,
        int? section,
      }) {
        ApplicationLogViewManager.showLogDetailOverlayEntry(
          apiLogModel: bLogModel,
        );
      },
      onPressedCopyAll: (bLogModels) {
        String copyText = '';
        for (LogModel logModel in bLogModels) {
          copyText = '$copyText\n$logModel.name\n$logModel.url';
        }
        Clipboard.setData(ClipboardData(text: copyText));
        CJTSToastUtil.showMessage('复制所有到粘贴板成功');
      },
      onPressedClear: (
          {required LogObjectType logType, required LogCategory bLogCategory}) {
        print('点击清空数据');
        logModels.clear();

        ApplicationLogViewManager.updateLogOverlayEntry();
      },
      onPressedClose: () {
        DevLogUtil.dismissLogView();

        if (onPressedCloseCompleteBlock != null) {
          onPressedCloseCompleteBlock();
        }
      },
    );
  }

  static dismissLogView() {
    DevLogUtil.isLogShowing = false;

    ApplicationLogViewManager.dismissLogOverlayEntry(
      ApplicationLogViewManager.logListOverlayKey,
      onlyHideNoSetnull: true,
    );
  }

  static addLogModel(LogModel logModel) {
    String dateTimeString = logModel.dateTime.toString().substring(5);
    String lastTitle = "第${logModels.length + 1}条日志:$dateTimeString";
    if (logModel.title != null && logModel.title!.isNotEmpty) {
      lastTitle += '\n${logModel.title}';
    }
    logModel.title = lastTitle;

    logModels.add(logModel);
    ApplicationLogViewManager.updateLogOverlayEntry();
  }

  static clearLogs() {
    logModels.clear();
    ApplicationLogViewManager.updateLogOverlayEntry();
  }
}
