import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './popup_logview_manager.dart';
import './log_data_bean.dart';
export './log_data_bean.dart' show LogLevel;

class DevLogUtil {
  static List<LogModel> logModels = [];
  static bool isLogShowing = false;

  static showLogView({
    void Function() onPressedCloseCompleteBlock,
  }) {
    DevLogUtil.isLogShowing = true;

    // MediaQuery.of(context).size.width  屏幕宽度
    // MediaQuery.of(context).size.height 屏幕高度
    ApplicationLogViewManager.showLogOverlayEntry(
      opacity: 1.0,
      logModels: logModels,
      clickLogCellCallback: (section, row, bApiModel) {
        //print('点击${bApiModel.url},复制到粘贴板成功');
        Clipboard.setData(ClipboardData(text: bApiModel.content));
        CJTSToastUtil.showMessage('复制当行到粘贴板成功');
      },
      onPressedCopyAll: (bLogModels) {
        String copyText = '';
        for (LogModel logModel in bLogModels) {
          copyText = '$copyText\n$logModel.name\n$logModel.url';
        }
        Clipboard.setData(ClipboardData(text: copyText));
        CJTSToastUtil.showMessage('复制所有到粘贴板成功');
      },
      onPressedClear: (LogType bLogType) {
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
      onlyHideNoSetnull: true,
    );
  }

  static addLogModel({
    LogLevel logLevel,
    String logTitle,
    String logText,
    Map logInfo,
  }) {
    if (logTitle == null || logTitle.isEmpty == true) {
      logTitle = '第${logModels.length + 1}条日志:';
    }
    LogModel logModel = LogModel(
      logLevel: logLevel,
      title: logTitle,
      content: logText,
      logInfo: logInfo,
    );
    logModels.add(logModel);
    ApplicationLogViewManager.updateLogOverlayEntry();
  }

  static clearLogs() {
    logModels.clear();
    ApplicationLogViewManager.updateLogOverlayEntry();
  }
}

class CJTSToastUtil {
  static showMessage(String message) {
    if (message != null && message is String && message.isNotEmpty) {
      print(message);
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
