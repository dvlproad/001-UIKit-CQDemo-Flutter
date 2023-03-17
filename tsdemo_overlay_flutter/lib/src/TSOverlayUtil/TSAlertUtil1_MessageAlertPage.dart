import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

class TSMessageAlertViewPage extends StatelessWidget {
  TSMessageAlertViewPage({Key? key}) : super(key: key);

  String shortText = '我是简短的文字';
  String longText =
      '123的322我222233都打了反垄断法林德洛夫饥饿疗法金额of金额非法定法定来得及 了大43242幅度发到3335353f地方了地方了纷纷付222233都打了反垄断法林德洛夫饥饿疗法金额of金额非法定法定来得及 了大43242幅度发到3335353f地方了地方了纷纷付';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _pageWidget(context),
    );
  }

  PreferredSizeWidget? _appBar() {
    return AppBar(
      title: Text('Alert'),
    );
  }

  Widget _pageWidget(context) {
    return Column(
      children: <Widget>[
        _longTextWidet(context),
        Text("信息弹窗"),
        CQTSThemeBGButton(
          bgColorType: CQTSThemeBGType.blue,
          title: '测试 showDialog 方法',
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => _longTextWidet(context),
            );
          },
        ),
        CQTSThemeBGButton(
          title: '测试Alert(短文本)',
          onPressed: () {
            AlertUtil.showCancelOKAlert(
              context: context,
              title: "温馨提示",
              message: "我是一串简短的文字",
              cancelHandle: () {
                print("点击Alert按钮:'取消'");
              },
              okHandle: () {
                print("点击Alert按钮:'确定'");
              },
            );
          },
        ),
        CQTSThemeBGButton(
          title: '测试Alert(长文本)',
          onPressed: () {
            AlertUtil.showCancelOKAlert(
              context: context,
              title: "温馨提示",
              message: "我是一串非常长的文字，我是一串非常长的文字，我是一串非常长的文字，我是一串非常长的文字，",
              cancelHandle: () {
                print("点击Alert按钮:'取消'");
              },
              okHandle: () {
                print("点击Alert按钮:'确定'");
              },
            );
          },
        ),
      ],
    );
  }

  Widget _longTextWidet(context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width - 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xffeeeeee),
          ),
          child: Text(longText),
        ),
      ],
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: 270,
              color: Colors.pink,
              child: Text(
                "123的322我222233都打了反垄断法林德洛夫饥饿疗法金额of金额非法定法定来得及 了大43242幅度发到3335353f地方了地方了纷纷付222233都打了反垄断法林德洛夫饥饿疗法金额of金额非法定法定来得及 了大43242幅度发到3335353f地方了地方了纷纷付",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
