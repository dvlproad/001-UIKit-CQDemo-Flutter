import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/alert/textInput_alert_view.dart';

// ignore: camel_case_types
class TSAlertView3_TextInputAlertPage extends StatelessWidget {
  const TSAlertView3_TextInputAlertPage({Key key}) : super(key: key);

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
      title: Text('TextInputAlertView'),
    );
  }

  Widget _pageWidget(context) {
    return Column(
      children: <Widget>[
        Text("信息弹窗"),
        SizedBox(height: 40),
        IKnowTextInputAlertView(
          title: "添加的图片数量超过限制",
          placeholder: '请输入',
          inputText: "我是提示",
          iKnowTitle: "我知道了3",
          iKnowHandle: () {
            print("点击Alert按钮:'我知道了'");
          },
        ),
        SizedBox(height: 40),
        // CancelOKTextInputAlertView(
        //   title: "提示",
        //   inputText: "确定删除选中图片",
        //   cancelTitle: "取消",
        //   cancelHandle: () {
        //     print("点击Alert按钮:'取消'");
        //   },
        //   okTitle: "确定",
        //   okHandle: () {
        //     print("点击Alert按钮:'确定'");
        //   },
        // ),
      ],
    );
  }
}
