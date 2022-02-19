import 'package:flutter/material.dart';
import 'package:flutter_environment/flutter_environment.dart';

class OverlayPage2 extends StatefulWidget {
  static GlobalKey<NavigatorState> globalKey;

  @override
  _OverlayPage2State createState() => _OverlayPage2State();
}

class _OverlayPage2State extends State<OverlayPage2> {
  final GlobalKey<NavigatorState> _parentKey = GlobalKey<NavigatorState>();
  // final GlobalKey _parentKey = GlobalKey();

  OverlayEntry overlayEntry;

  @override
  void dispose() {
    super.dispose();
    overlayEntry.remove();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///WidgetsBinding.instance.addPostFrameCallback 这个作用是界面绘制完成的监听回调  必须在绘制完成后添加OverlayEntry
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // 需要在 main.dart 中设置 ApplicationDraggableManager.globalKey = xx; 和 navigatorKey: ApplicationDraggableManager.globalKey,

        ///MediaQuery.of(context).size.width  屏幕宽度
        ///MediaQuery.of(context).size.height 屏幕高度
        // ApplicationDraggableManager.addOverlayEntry(
        //   left: MediaQuery.of(context).size.width - 80,
        //   top: MediaQuery.of(context).size.height - 80,
        //   child: Icon(Icons.add_call, color: Colors.red),
        //   ifExistUseOld: false,
        // );
        double left = MediaQuery.of(context).size.width - 80;
        double top = MediaQuery.of(context).size.height - 80;
        Widget child = Icon(Icons.add_call, color: Colors.blue);

        overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
            top: top,
            left: left,
            child: GestureDetector(
              onTap: () async {},
              child: child,
            ),
          ),
        );

        /// 赋值方便移除
        // ApplicationDraggableManager.overlayEntry = overlayEntry;
        // OverlayPage2.globalKey.currentState.overlay.insert(overlayEntry);
        Overlay.of(context).insert(overlayEntry);
        // widget.key.cu
        // _parentKey.currentState.overlay.insert(overlayEntry);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _parentKey,
      appBar: AppBar(title: Text('Overlay')),
      body: Container(
        key: _parentKey,
      ),
    );
  }
}
