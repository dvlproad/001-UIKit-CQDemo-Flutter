import 'package:flutter/material.dart';
import '../src/apimock/log_list.dart';

class ApplicationDraggableManager {
  static GlobalKey<NavigatorState> globalKey;
  static OverlayEntry overlayEntry;

  // 关闭悬浮按钮
  static Future removeOverlayEntry() {
    OverlayEntry overlayEntry = ApplicationDraggableManager.overlayEntry;
    overlayEntry?.remove(); // 删除重新绘制

    ApplicationDraggableManager.overlayEntry = null;
  }

  static Future addOverlayEntry({
    double left,
    double top,
    @required Widget child,
    bool ifExistUseOld, // 如果存在则使用旧的,默认false
  }) async {
    OverlayEntry overlayEntry = ApplicationDraggableManager.overlayEntry;
    if (ifExistUseOld == true && overlayEntry != null) {
      return;
    }
    overlayEntry?.remove(); // 删除重新绘制

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: top,
        left: left,
        child: GestureDetector(
          onTap: () async {},
          child: Draggable(
            child: child, //child是静止时显示的Widget，
            childWhenDragging: Container(), //拖拽时child子组件显示样式
            feedback: child, //feedback是拖动时跟随手指滑动的Widget
            onDragEnd: (DraggableDetails details) {
              //拖动结束,通过重新创建来更新位置
              addOverlayEntry(
                left: details.offset.dx,
                top: details.offset.dy,
                child: child,
              );
            },
          ),
        ),
      ),
    );

    /// 赋值方便移除
    ApplicationDraggableManager.overlayEntry = overlayEntry;
    ApplicationDraggableManager.globalKey.currentState.overlay
        .insert(overlayEntry);
  }

  // 全局log视图
  static OverlayEntry logOverlayEntry;
  static bool logVisible = true;
  // 关闭全局log视图
  static void dismissLogOverlayEntry({
    bool onlyHideNoSetnull =
        false, // true:只隐藏，不set null,下次可继续使用;false,会set null,下次重新创建
  }) {
    OverlayEntry logOverlayEntry = ApplicationDraggableManager.logOverlayEntry;
    if (onlyHideNoSetnull == true) {
      logVisible = false;
      logOverlayEntry.markNeedsBuild(); // 刷新 overlay
      return;
    }

    logOverlayEntry?.remove(); // 删除重新绘制
    ApplicationDraggableManager.logOverlayEntry = null;
  }

  static void updateLogOverlayEntry() {
    print('尝试刷新 overlay 的 chid 视图....');
    logOverlayEntry.markNeedsBuild();
  }

  // 显示全局log视图
  static Future showLogOverlayEntry({
    double left,
    double top,
    @required List logModels,
    @required
        void Function(int section, int row, ApiModel bApiModel)
            clickLogCellCallback, // logCell 的点击
  }) async {
    OverlayEntry logOverlayEntry = ApplicationDraggableManager.logOverlayEntry;
    if (logOverlayEntry != null) {
      logVisible = true;
      logOverlayEntry.markNeedsBuild();
      return;
    }
    logOverlayEntry?.remove(); // 删除重新绘制

    logOverlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        print('正式刷新 overlay 的 chid 视图....');

        return Positioned(
          bottom: 0,
          child: GestureDetector(
            onTap: () async {},
            child: Visibility(
              visible: logVisible,
              // child: child,
              child: LogList(
                logModels: logModels,
                clickLogCellCallback: clickLogCellCallback,
              ),
            ),
          ),
        );
      },
    );

    /// 赋值方便移除
    ApplicationDraggableManager.logOverlayEntry = logOverlayEntry;
    ApplicationDraggableManager.globalKey.currentState.overlay
        .insert(logOverlayEntry);
  }
}
