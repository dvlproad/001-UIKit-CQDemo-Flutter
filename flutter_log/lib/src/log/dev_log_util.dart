import 'package:flutter/material.dart';
import './draggable_manager.dart';
import './api_data_bean.dart';

class DevLogUtil {
  static List<ApiModel> logModels = [];

  static showLogView({
    void Function() onPressedCloseCompleteBlock,
  }) {
    // MediaQuery.of(context).size.width  屏幕宽度
    // MediaQuery.of(context).size.height 屏幕高度
    ApplicationLogViewManager.showLogOverlayEntry(
      logModels: logModels,
      clickLogCellCallback: (section, row, bApiModel) {
        print('点击${bApiModel.url}');
      },
      onPressedClear: () {
        print('点击清空数据');
        logModels.clear();

        ApplicationLogViewManager.updateLogOverlayEntry();
      },
      onPressedClose: () {
        ApplicationLogViewManager.dismissLogOverlayEntry(
          onlyHideNoSetnull: true,
        );

        if (onPressedCloseCompleteBlock != null) {
          onPressedCloseCompleteBlock();
        }
      },
    );
  }

  static dismissLogView() {
    ApplicationLogViewManager.dismissLogOverlayEntry(
      onlyHideNoSetnull: true,
    );
  }

  static addLogModel({String logTitle, String logText}) {
    ApiModel logModel = ApiModel(name: logTitle, url: logText, mock: false);
    logModels.add(logModel);
    ApplicationLogViewManager.updateLogOverlayEntry();
  }

  static clearLogs() {
    logModels.clear();
    ApplicationLogViewManager.updateLogOverlayEntry();
  }
}
