import 'package:flutter/material.dart';
import 'package:flutter_environment/flutter_environment.dart';

import '../dev_util.dart';

class TSLogPage extends StatefulWidget {
  TSLogPage({Key key}) : super(key: key);

  @override
  _TSLogPageState createState() => new _TSLogPageState();
}

class _TSLogPageState extends State<TSLogPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: appBar(),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: contentWidget(),
      ),
    );
  }

  /// 导航栏
  PreferredSize appBar() {
    return PreferredSize(
        child: AppBar(
          title: Text('测试 Test', style: TextStyle(fontSize: 17)),
        ),
        preferredSize: Size.fromHeight(44));
  }

  /// 内容视图
  Widget contentWidget() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;
    double loginIconBottom = screenHeight <= 667 ? 50 : 71;

    return new Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: TextButton(
            child: Text('显示全局log视图'),
            onPressed: () {
              // DevUtil.showDevFloatingWidget(context, showTestApiWidget: true);

              ///MediaQuery.of(context).size.width  屏幕宽度
              ///MediaQuery.of(context).size.height 屏幕高度
              ApplicationDraggableManager.showLogOverlayEntry(
                child: logWidget(context),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: Text('1'),
        ),
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: Text('1'),
        ),
      ],
    );
  }

  Widget logWidget(BuildContext context) {
    return LogList(
      apiMockModels: [
        ApiModel(name: '111', url: 'hfhf'),
        ApiModel(name: '222', url: 'hfhf'),
        ApiModel(name: '333', url: 'hfhf'),
      ],
      clickApiMockCellCallback: (section, row, bApiModel) {
        print('点击');
      },
    );
  }
}
