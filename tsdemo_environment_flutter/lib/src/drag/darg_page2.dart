import 'package:flutter/material.dart';
import 'package:flutter_environment/flutter_environment.dart';

import '../dev_util.dart';

class DraggablePage2 extends StatefulWidget {
  @override
  _DraggablePage2State createState() => _DraggablePage2State();
}

class _DraggablePage2State extends State<DraggablePage2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///WidgetsBinding.instance.addPostFrameCallback 这个作用是界面绘制完成的监听回调  必须在绘制完成后添加OverlayEntry
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // 需要在 main.dart 中设置 ApplicationDraggableManager.globalKey = xx; 和 navigatorKey: ApplicationDraggableManager.globalKey,
        DevUtil.showDevFloatingWidget(
          showTestApiWidget: true,
        );

        ///MediaQuery.of(context).size.width  屏幕宽度
        ///MediaQuery.of(context).size.height 屏幕高度
        // ApplicationDraggableManager.addOverlayEntry(
        //   left: MediaQuery.of(context).size.width - 80,
        //   top: MediaQuery.of(context).size.height - 80,
        //   child: Icon(Icons.add_call, color: Colors.red),
        //   ifExistUseOld: true,
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
