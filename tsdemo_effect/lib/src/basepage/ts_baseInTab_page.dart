import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';

class TSBaseInTabPage extends StatefulWidget {
  TSBaseInTabPage({Key key}) : super(key: key);

  @override
  _TSBaseInTabPageState createState() => _TSBaseInTabPageState();
}

// 1 实现 SingleTickerProviderStateMixin
class _TSBaseInTabPageState extends State<TSBaseInTabPage>
    with SingleTickerProviderStateMixin {
  // 2 定义 TabController 变量
  TabController _tabController;

  // 3 覆盖重写 initState，实例化 _tabController
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      print(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _bodyWidget,
    );
  }

  // @override
  // bool appBarIsAddToSuccess() {
  //   return false;
  // }

  // @override
  // Widget buildSuccessWidget(BuildContext context) {}

  AppBar get _appBar {
    return AppBar(
      title: Text('tabController'),
      bottom: TabBar(
        controller: _tabController, // 4 需要配置 controller！！！
        // isScrollable: true,
        tabs: <Widget>[
          Tab(text: '推荐'),
          Tab(text: '最新'),
        ],
      ),
    );
  }

  Widget get _bodyWidget {
    return TabBarView(
      controller: _tabController, // 4 需要配置 controller！！！
      children: <Widget>[
        _subPage1,
        _subPage2,
      ],
    );
  }

  Widget get _subPage1 {
    return ListView(
      children: <Widget>[
        ListTile(
          onTap: () {
            print('点击按钮1-1');
          },
          title: Text(
            'diyigezuixin  推荐',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        ListTile(
          onTap: () {
            print('点击按钮1-2');
          },
          title: Text('diyigezuixin  推荐'),
        ),
      ],
    );
  }

  Widget get _subPage2 {
    return Container(
      child: GestureDetector(
        onTap: () {
          print('点击按钮2-1');
        },
        child: Container(
          color: Colors.green,
          height: 40,
          child: Text('按钮2-1'),
        ),
      ),
    );
  }
}
