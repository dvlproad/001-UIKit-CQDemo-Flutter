import 'package:flutter/material.dart';

class ApplicationDraggableManager {
  static GlobalKey<NavigatorState> globalKey;
  static OverlayEntry overlayEntry;

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
}
