import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ApplicationDraggableManager {
  static late GlobalKey<NavigatorState> _globalKey; // 用来处理悬浮按钮的展示
  static ImageProvider? _floatingToolImageProvider; // 悬浮按钮上的图片
  static late String _floatingToolTextNetworkNameOrigin; // 悬浮按钮上的文本:此包的默认网络环境
  static late String _floatingToolTextNetworkNameCurrent; // 悬浮按钮上的文本:此包的当前网络环境
  static late String _floatingToolTextTargetNameOrigin; // 悬浮按钮上的文本:此包的默认发布网站
  static late String _floatingToolTextTargetNameCurrent; // 悬浮按钮上的文本:此包的当前发布网站
  static late void Function() _onTap; // 点击事件
  static late void Function() _onLongPress; // 长按事件
  static late void Function() _onDoubleTap; // 双击事件

  static String _app_drag_floating_button_key = '';

  static Future init({
    required GlobalKey<NavigatorState> navigatorKey,
    ImageProvider? floatingToolImageProvider, // 悬浮按钮上的图片
    required String floatingToolTextNetworkNameOrigin, // 悬浮按钮上的文本:此包的默认网络环境
    required String floatingToolTextNetworkNameCurrent, // 悬浮按钮上的文本:此包的当前网络环境
    required String floatingToolTextTargetNameOrigin, // 悬浮按钮上的文本:此包的默认发布网站
    required String floatingToolTextTargetNameCurrent, // 悬浮按钮上的文本:此包的当前发布网站
    required void Function() onTap, // 点击事件
    required void Function() onLongPress, // 长按事件
    required void Function() onDoubleTap, // 双击事件
    required bool overlayEntryShouldShowIfNil,
  }) async {
    _globalKey = navigatorKey;
    _floatingToolImageProvider = floatingToolImageProvider;
    _floatingToolTextNetworkNameOrigin = floatingToolTextNetworkNameOrigin;
    _floatingToolTextNetworkNameCurrent = floatingToolTextNetworkNameCurrent;
    _floatingToolTextTargetNameOrigin = floatingToolTextTargetNameOrigin;
    _floatingToolTextTargetNameCurrent = floatingToolTextTargetNameCurrent;
    _onTap = onTap;
    _onLongPress = onLongPress;
    _onDoubleTap = onDoubleTap;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    _app_drag_floating_button_key =
        "_app_drag_floating_button_should_show_${version}";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _overlayEntryIsShow = prefs.getBool(_app_drag_floating_button_key);
    if (_overlayEntryIsShow == null) {
      _overlayEntryIsShow = overlayEntryShouldShowIfNil;
    }
  }

  static void updateDevToolFloatingIconOverlayEntry(String currentEnvName) {
    //print('尝试刷新 overlay 的 chid 视图....');
    _floatingToolTextNetworkNameCurrent = currentEnvName;
    if (overlayEntry != null) {
      overlayEntry!.markNeedsBuild();
    }
  }

  static OverlayEntry? overlayEntry;
  static bool? _overlayEntryIsShow; // overlayEntry 是否在显示中
  static bool get overlayEntryIsShow {
    return _overlayEntryIsShow ?? false;
  }

  // 关闭悬浮按钮
  static void removeOverlayEntry() {
    OverlayEntry? overlayEntry = ApplicationDraggableManager.overlayEntry;
    overlayEntry?.remove(); // 删除重新绘制

    ApplicationDraggableManager.overlayEntry = null;
    ApplicationDraggableManager._overlayEntryIsShow = false;
    _updateShowState(false);
  }

  static _updateShowState(bool shouldShow) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_app_drag_floating_button_key, shouldShow);
  }

  static void showEasyOverlayEntry({
    double left = 80.0,
    double top = 100.0,
  }) {
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
                      package: 'flutter_environment_base',
                    ),
                fit: BoxFit.cover,
              ),
            ),
            width: 44,
            height: 44,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                targetNetworkWidget(
                  networkDes: _floatingToolTextNetworkNameOrigin,
                  targetDes: _floatingToolTextTargetNameOrigin,
                  networkTextColor: Colors.pink,
                  targetTextColor: Colors.pink,
                ),
                targetNetworkWidget(
                  networkDes: _floatingToolTextNetworkNameCurrent,
                  targetDes: _floatingToolTextTargetNameCurrent,
                  networkTextColor: _floatingToolTextNetworkNameCurrent !=
                          _floatingToolTextNetworkNameOrigin
                      ? Colors.red
                      : Colors.pink,
                  targetTextColor: _floatingToolTextTargetNameCurrent !=
                          _floatingToolTextTargetNameOrigin
                      ? Colors.red
                      : Colors.pink,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    _addOverlayEntry(
      left: left,
      top: top,
      child: overlayChildWidget,
      ifExistUseOld: true,
    );
  }

  static Widget targetNetworkWidget({
    required String targetDes,
    required String networkDes,
    required Color targetTextColor,
    required Color networkTextColor,
  }) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: 5),
          Text(
            networkDes,
            style: TextStyle(
              fontFamily: 'PingFang SC',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: targetTextColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                // color: Colors.green,
                child: Text(
                  targetDes,
                  style: TextStyle(
                    fontFamily: 'PingFang SC',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: networkTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void _addOverlayEntry({
    double left = 80.0,
    double top = 100.0,
    required Widget child,
    bool ifExistUseOld = false, // 如果存在则使用旧的,默认false
  }) async {
    // if (_globalKey == null) {
    //   throw Exception('Error:请先在main.dart中设置 ApplicationDraggableManager.init');
    // }

    OverlayEntry? overlayEntry = ApplicationDraggableManager.overlayEntry;
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
              _addOverlayEntry(
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

    if (_globalKey.currentState != null &&
        _globalKey.currentState!.overlay != null) {
      _globalKey.currentState!.overlay!.insert(overlayEntry);
      ApplicationDraggableManager._overlayEntryIsShow = true;
      _updateShowState(true);
      ApplicationDraggableManager.overlayEntry = overlayEntry;
    }
  }
}
