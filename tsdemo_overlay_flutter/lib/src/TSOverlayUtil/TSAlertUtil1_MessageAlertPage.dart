import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/src/message_alert_view.dart';

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
        SizedBox(height: 40),
        IKnowMessageAlertView(
            title: "添加的图片数量超过限制",
            message: "我是提示",
            iKnowTitle: "我知道了3",
            iKnowHandle: () {
              print("点击Alert按钮:'我知道了'");
            }),
        SizedBox(height: 40),
        CancelOKMessageAlertView(
          title: "提示",
          message: "确定删除选中图片",
          cancelTitle: "取消",
          cancelHandle: () {
            print("点击Alert按钮:'取消'");
          },
          okTitle: "确定",
          okHandle: () {
            print("点击Alert按钮:'确定'");
          },
        ),
      ],
    );
  }
}
