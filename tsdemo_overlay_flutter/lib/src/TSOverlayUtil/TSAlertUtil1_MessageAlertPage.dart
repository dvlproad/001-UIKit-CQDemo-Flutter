import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

class TSMessageAlertViewPage extends StatelessWidget {
  const TSMessageAlertViewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _pageWidget(context),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('Overlay模块'),
    );
  }

  Widget _pageWidget(context) {
    return Column(
      children: <Widget>[
        Text("信息弹窗"),
        CQTSThemeBGButton(
          title: '测试Alert',
          onPressed: () {
            AlertUtil.showCancelOKAlert(context, "提示", null, () {
              print("点击Alert按钮:'取消'");
            }, () {
              print("点击Alert按钮:'确定'");
            });
          },
        ),
      ],
    );
  }
}
