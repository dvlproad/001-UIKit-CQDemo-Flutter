import 'package:flutter/material.dart';
import '../../darg/draggable_manager.dart';
import '../apimock/manager/api_data_bean.dart';

class DevLogUtil {
  static List<ApiModel> logModels = [];

  static showLogView({
    @required void Function() onPressedCloseCompleteBlock,
  }) {
    // MediaQuery.of(context).size.width  屏幕宽度
    // MediaQuery.of(context).size.height 屏幕高度
    ApplicationDraggableManager.showLogOverlayEntry(
      logModels: logModels,
      clickLogCellCallback: (section, row, bApiModel) {
        print('点击${bApiModel.url}');
      },
      onPressedClear: () {
        print('点击清空数据');
        logModels.clear();

        ApplicationDraggableManager.updateLogOverlayEntry();
      },
      onPressedClose: () {
        ApplicationDraggableManager.dismissLogOverlayEntry(
          onlyHideNoSetnull: true,
        );

        if (onPressedCloseCompleteBlock != null) {
          onPressedCloseCompleteBlock();
        }
      },
    );
  }

  static dismissLogView() {
    ApplicationDraggableManager.dismissLogOverlayEntry(
      onlyHideNoSetnull: true,
    );
  }

  static addLogModel(ApiModel logModel) {
    logModels.add(logModel);
    print('添加log:${logModel.name}');
    ApplicationDraggableManager.updateLogOverlayEntry();
  }

  static clearLogs() {
    logModels.clear();
    ApplicationDraggableManager.updateLogOverlayEntry();
  }
}
