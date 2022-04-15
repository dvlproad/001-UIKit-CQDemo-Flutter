import 'package:flutter/material.dart';

class ApplicationDraggableManager {
  static GlobalKey<NavigatorState> _globalKey; // 用来处理悬浮按钮的展示
  static ImageProvider _floatingToolImageProvider; // 悬浮按钮上的图片
  static String _floatingToolTextDefaultEnv; // 悬浮按钮上的文本:此包的默认环境
  static void Function() _onTap; // 点击事件
  static void Function() _onLongPress; // 长按事件
  static void Function() _onDoubleTap; // 双击事件
  static init({
    @required GlobalKey navigatorKey,
    @required ImageProvider floatingToolImageProvider, // 悬浮按钮上的图片
    @required String floatingToolTextDefaultEnv, // 悬浮按钮上的文本:此包的默认环境
    @required void Function() onTap, // 点击事件
    @required void Function() onLongPress, // 长按事件
    @required void Function() onDoubleTap, // 双击事件
  }) {
    _globalKey = navigatorKey;
    _floatingToolImageProvider = floatingToolImageProvider;
    _floatingToolTextDefaultEnv = floatingToolTextDefaultEnv;
    _onTap = onTap;
    _onLongPress = onLongPress;
    _onDoubleTap = onDoubleTap;
  }

  static GlobalKey<NavigatorState> get globalKey => _globalKey;

  static String _currentEnvName; // 悬浮按钮上的文本:此包的当前环境
  static void updateDevToolFloatingIconOverlayEntry(String currentEnvName) {
    //print('尝试刷新 overlay 的 chid 视图....');
    _currentEnvName = currentEnvName;
    if (overlayEntry != null) {
      overlayEntry.markNeedsBuild();
    }
  }

  static OverlayEntry overlayEntry;
  static bool overlayEntryIsShow = false; // overlayEntry 是否在显示中

  // 关闭悬浮按钮
  static Future removeOverlayEntry() {
    OverlayEntry overlayEntry = ApplicationDraggableManager.overlayEntry;
    overlayEntry?.remove(); // 删除重新绘制

    ApplicationDraggableManager.overlayEntry = null;
    ApplicationDraggableManager.overlayEntryIsShow = false;
  }

  static Future showEasyOverlayEntry({
    double left,
    double top,
  }) async {
    Widget overlayChildWidget = ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Material(
        child: GestureDetector(
          onTap: _onTap,
          onLongPress: _onLongPress,
          onDoubleTap: _onDoubleTap,
          child: Container(
            // color: Colors.red,
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: _floatingToolImageProvider ??
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
                    _floatingToolTextDefaultEnv ?? '',
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
        ),
      ),
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
    if (_globalKey == null) {
      throw Exception('Error:请先在main.dart中设置 ApplicationDraggableManager.init');
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

    if (_globalKey.currentState != null) {
      _globalKey.currentState.overlay.insert(overlayEntry);
      ApplicationDraggableManager.overlayEntryIsShow = true;
      ApplicationDraggableManager.overlayEntry = overlayEntry;
    }
  }
}
