import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/alert/message_alert_view.dart';

// ignore: camel_case_types
class TSAlertView1_MessageAlertPage extends StatelessWidget {
  const TSAlertView1_MessageAlertPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: Container(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: double.infinity,
        ),
        child: _pageWidget(context),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('MessageAlertView 模块'),
    );
  }

  Widget _pageWidget(context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("信息弹窗"),
        SizedBox(height: 40),
        IKnowMessageAlertView(
          title: "添加的图片数量超过限制",
          message: "我是提示（我是一串很长的字符串我是一串很长的字符串我是一串很长的字符串我是一串很长的字符串）",
          iKnowTitle: "我知道了3",
          iKnowHandle: () {
            print("点击Alert按钮:'我知道了'");
          },
        ),
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
