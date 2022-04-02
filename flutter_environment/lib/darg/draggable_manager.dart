import 'package:flutter/material.dart';

class ApplicationDraggableManager {
  static GlobalKey<NavigatorState> globalKey;
  static OverlayEntry overlayEntry;
  static bool overlayEntryIsShow = false; // overlayEntry 是否在显示中

  // 关闭悬浮按钮
  static Future removeOverlayEntry() {
    OverlayEntry overlayEntry = ApplicationDraggableManager.overlayEntry;
    overlayEntry?.remove(); // 删除重新绘制

    ApplicationDraggableManager.overlayEntry = null;
    ApplicationDraggableManager.overlayEntryIsShow = false;
  }

  // 弹出只是一个悬浮按钮的视图
  static ImageProvider floatingToolImageProvider; // 悬浮按钮上的图片
  static String floatingToolTextDefaultEnv; // 悬浮按钮上的文本:此包的默认环境
  static String _currentEnvName; // 悬浮按钮上的文本:此包的当前环境
  static void updateDevToolFloatingIconOverlayEntry(String currentEnvName) {
    //print('尝试刷新 overlay 的 chid 视图....');
    _currentEnvName = currentEnvName;
    if (overlayEntry != null) {
      overlayEntry.markNeedsBuild();
    }
  }

  static Future showEasyOverlayEntry({
    double left,
    double top,
    @required void Function() onTap, // 点击事件
    void Function() onLongPress, // 长按事件
  }) async {
    Widget overlayChildWidget = ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Material(
          child: GestureDetector(
        child: Container(
          // color: Colors.red,
          decoration: BoxDecoration(
            color: Colors.red,
            image: DecorationImage(
              image: floatingToolImageProvider ??
                  AssetImage(
                    'assets/icon_dev.png',
                    package: 'flutter_environment',
                  ),
              fit: BoxFit.cover,
            ),
          ),
          width: 44,
          height: 44,
          child: Column(
            children: [
              Center(
                child: Text(
                  floatingToolTextDefaultEnv ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              Center(
                child: Text(
                  _currentEnvName ?? '',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      )),
    );

    ApplicationDraggableManager.addOverlayEntry(
      left: left,
      top: top,
      child: overlayChildWidget,
      ifExistUseOld: true,
    );
  }

  static Future addOverlayEntry({
    double left,
    double top,
    @required Widget child,
    bool ifExistUseOld, // 如果存在则使用旧的,默认false
  }) async {
    if (ApplicationDraggableManager.globalKey == null) {
      throw Exception(
          'Error:请先在main.dart中设置 ApplicationDraggableManager.globalKey = GlobalKey<NavigatorState>();');
    }

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

    if (ApplicationDraggableManager.globalKey.currentState != null) {
      ApplicationDraggableManager.globalKey.currentState.overlay
          .insert(overlayEntry);
      ApplicationDraggableManager.overlayEntryIsShow = true;
      ApplicationDraggableManager.overlayEntry = overlayEntry;
    }
  }
}
